[CmdletBinding()]
param(
    [string[]]$Targets = @("codex", "claude", "copilot"),
    [switch]$Force,
    [switch]$DryRun,
    [switch]$InstallCodexLegacySkills
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-ProfileRoot {
    param(
        [string]$EnvironmentName,
        [string]$DefaultLeaf
    )

    $value = [Environment]::GetEnvironmentVariable($EnvironmentName)
    if ([string]::IsNullOrWhiteSpace($value)) {
        return (Join-Path $script:UserProfile $DefaultLeaf)
    }

    return $value
}

function Get-FullPath {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path) {
        return (Resolve-Path -LiteralPath $Path).ProviderPath.TrimEnd("\")
    }

    return ([System.IO.Path]::GetFullPath($Path)).TrimEnd("\")
}

function Get-ReparseTarget {
    param([System.IO.FileSystemInfo]$Item)

    if (($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -eq 0) {
        return $null
    }

    $target = $Item.Target
    if ($target -is [array]) {
        $target = $target[0]
    }

    if ([string]::IsNullOrWhiteSpace($target)) {
        return $null
    }

    return $target
}

function Resolve-LinkTargetPath {
    param(
        [string]$LinkPath,
        [string]$Target
    )

    if ([System.IO.Path]::IsPathRooted($Target)) {
        return Get-FullPath $Target
    }

    $linkParent = Split-Path -Parent ([System.IO.Path]::GetFullPath($LinkPath))
    return Get-FullPath (Join-Path $linkParent $Target)
}

function Install-Link {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][ValidateSet("File", "Directory")][string]$Kind
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Source not found: $Source"
    }

    $sourceFull = Get-FullPath $Source
    $destinationFull = [System.IO.Path]::GetFullPath($Destination)
    $parent = Split-Path -Parent $destinationFull
    $existing = Get-Item -LiteralPath $destinationFull -Force -ErrorAction SilentlyContinue

    if ($null -ne $existing) {
        $target = Get-ReparseTarget $existing
        if ($null -ne $target) {
            $targetFull = Resolve-LinkTargetPath -LinkPath $destinationFull -Target $target
            if ($targetFull -ieq $sourceFull) {
                Write-Host "OK      $destinationFull -> $sourceFull"
                return
            }

            if (-not $Force) {
                throw "Existing link points elsewhere: $destinationFull -> $targetFull. Use -Force to replace it."
            }

            Write-Host "RELINK  $destinationFull -> $sourceFull"
            if (-not $DryRun) {
                Remove-Item -LiteralPath $destinationFull -Force
            }
        }
        else {
            if (-not $Force) {
                throw "Existing non-link path: $destinationFull. Use -Force to back it up and replace it."
            }

            $backup = "$destinationFull.backup.$script:Timestamp"
            Write-Host "BACKUP  $destinationFull -> $backup"
            if (-not $DryRun) {
                Move-Item -LiteralPath $destinationFull -Destination $backup
            }
        }
    }

    Write-Host "LINK    $destinationFull -> $sourceFull"
    if ($DryRun) {
        return
    }

    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    try {
        New-Item -ItemType SymbolicLink -Path $destinationFull -Target $sourceFull | Out-Null
    }
    catch {
        throw "Failed to create symbolic link: $destinationFull -> $sourceFull. Enable Developer Mode or run PowerShell as Administrator. $($_.Exception.Message)"
    }
}

function Remove-LinkIfOwned {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $destinationFull = [System.IO.Path]::GetFullPath($Destination)
    $existing = Get-Item -LiteralPath $destinationFull -Force -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        return
    }

    $target = Get-ReparseTarget $existing
    if ($null -eq $target) {
        return
    }

    $sourceFull = Get-FullPath $Source
    $targetFull = Resolve-LinkTargetPath -LinkPath $destinationFull -Target $target
    if ($targetFull -ine $sourceFull) {
        return
    }

    Write-Host "REMOVE  $destinationFull"
    if (-not $DryRun) {
        Remove-Item -LiteralPath $destinationFull -Force
    }
}

function Remove-DirectoryLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory,
        [object[]]$LegacyLinks = @()
    )

    $destinationFull = [System.IO.Path]::GetFullPath($DestinationDirectory)
    $existing = Get-Item -LiteralPath $destinationFull -Force -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        return
    }

    if ($null -ne (Get-ReparseTarget $existing)) {
        Remove-LinkIfOwned -Source $SourceDirectory -Destination $DestinationDirectory
        return
    }

    if (-not $existing.PSIsContainer) {
        return
    }

    foreach ($legacyLink in @($LegacyLinks)) {
        $destination = Join-Path $DestinationDirectory $legacyLink.DestinationName
        Remove-LinkIfOwned -Source $legacyLink.Source -Destination $destination
    }
}

function Get-LegacyChildLinks {
    param(
        [string]$SourceDirectory,
        [Parameter(Mandatory = $true)][ValidateSet("File", "Directory")][string]$Kind,
        [string]$Filter = "*",
        [string]$DestinationExtension,
        [string[]]$ExcludeNames = @()
    )

    if (-not (Test-Path -LiteralPath $SourceDirectory)) {
        return @()
    }

    $items = if ($Kind -eq "File") {
        Get-ChildItem -LiteralPath $SourceDirectory -File -Filter $Filter -Force
    }
    else {
        Get-ChildItem -LiteralPath $SourceDirectory -Directory -Force
    }

    return @($items |
        Where-Object { $ExcludeNames -notcontains $_.Name } |
        ForEach-Object {
            $destinationName = if ([string]::IsNullOrWhiteSpace($DestinationExtension)) {
                $_.Name
            }
            else {
                "$($_.BaseName)$DestinationExtension"
            }

            [pscustomobject]@{
                Source = $_.FullName
                DestinationName = $destinationName
            }
        })
}

function Get-LegacySharedAgentLinks {
    param(
        [string]$SourceDirectory,
        [string]$LegacySourceDirectory,
        [string]$DestinationExtension
    )

    if (-not (Test-Path -LiteralPath $SourceDirectory)) {
        return @()
    }

    return @(Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.agent.md" -Force | ForEach-Object {
        $agentName = $_.Name -replace "\.agent\.md$", ""
        [pscustomobject]@{
            Source = Join-Path $LegacySourceDirectory "$agentName.md"
            DestinationName = "$agentName$DestinationExtension"
        }
    })
}

function Test-OwnedLegacyDirectory {
    param(
        [string]$DestinationDirectory,
        [object[]]$LegacyLinks
    )

    $existing = Get-Item -LiteralPath $DestinationDirectory -Force -ErrorAction SilentlyContinue
    if ($null -eq $existing -or -not $existing.PSIsContainer) {
        return $false
    }

    if ($null -ne (Get-ReparseTarget $existing)) {
        return $false
    }

    $expectedTargets = @{}
    foreach ($legacyLink in @($LegacyLinks)) {
        if (-not $expectedTargets.ContainsKey($legacyLink.DestinationName)) {
            $expectedTargets[$legacyLink.DestinationName] = @()
        }

        $expectedTargets[$legacyLink.DestinationName] += @(Get-FullPath $legacyLink.Source)
    }

    $children = @(Get-ChildItem -LiteralPath $DestinationDirectory -Force)
    if ($children.Count -eq 0) {
        return $false
    }

    foreach ($child in $children) {
        $target = Get-ReparseTarget $child
        if ($null -eq $target) {
            return $false
        }

        if (-not $expectedTargets.ContainsKey($child.Name)) {
            return $false
        }

        $targetFull = Resolve-LinkTargetPath -LinkPath $child.FullName -Target $target
        $matchesExpectedTarget = $false
        foreach ($expectedFull in @($expectedTargets[$child.Name])) {
            if ($targetFull -ieq $expectedFull) {
                $matchesExpectedTarget = $true
                break
            }
        }

        if (-not $matchesExpectedTarget) {
            return $false
        }
    }

    return $true
}

function Remove-OwnedLegacyDirectory {
    param([string]$DestinationDirectory)

    Get-ChildItem -LiteralPath $DestinationDirectory -Force | ForEach-Object {
        Remove-Item -LiteralPath $_.FullName -Force
    }
    Remove-Item -LiteralPath $DestinationDirectory -Force
}

function Add-DirectoryLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory,
        [object[]]$LegacyLinks = @()
    )

    if (-not (Test-Path -LiteralPath $SourceDirectory)) {
        throw "Source not found: $SourceDirectory"
    }

    $destinationFull = [System.IO.Path]::GetFullPath($DestinationDirectory)
    $sourceFull = Get-FullPath $SourceDirectory
    if (Test-OwnedLegacyDirectory -DestinationDirectory $DestinationDirectory -LegacyLinks $LegacyLinks) {
        Write-Host "MIGRATE $destinationFull owned legacy links"
        if ($DryRun) {
            Write-Host "LINK    $destinationFull -> $sourceFull"
            return
        }

        Remove-OwnedLegacyDirectory -DestinationDirectory $DestinationDirectory
    }

    Install-Link -Source $SourceDirectory -Destination $DestinationDirectory -Kind Directory
}

$script:UserProfile = [Environment]::GetFolderPath("UserProfile")
if ([string]::IsNullOrWhiteSpace($script:UserProfile)) {
    $script:UserProfile = $env:USERPROFILE
}

$script:Timestamp = Get-Date -Format "yyyyMMddHHmmss"
$repoRoot = $PSScriptRoot
$policySource = Join-Path $repoRoot "settings\AGENTS.md"
$skillsSource = Join-Path $repoRoot "settings\skills"
$agentsSource = Join-Path $repoRoot "settings\agents"
$sharedAgentsSource = Join-Path $repoRoot "settings\agents\shared"
$codexAgentsSource = Join-Path $repoRoot "settings\agents\codex"
$commandsSource = Join-Path $repoRoot "settings\commands"

$legacySkillLinks = Get-LegacyChildLinks -SourceDirectory $skillsSource -Kind Directory
$obsoleteCommandNames = @("build.md", "code-simplify.md", "plan.md", "review.md", "ship.md", "spec.md", "test.md")
$obsoleteCommandLinks = @($obsoleteCommandNames | ForEach-Object {
    [pscustomobject]@{
        Source = Join-Path $commandsSource $_
        DestinationName = $_
    }
})
$legacyCodexAgentLinks = Get-LegacyChildLinks -SourceDirectory $codexAgentsSource -Kind File -Filter "*.toml"
$legacyClaudeAgentLinks = Get-LegacySharedAgentLinks -SourceDirectory $sharedAgentsSource -LegacySourceDirectory $agentsSource -DestinationExtension ".md"
$legacyCopilotAgentLinks = Get-LegacySharedAgentLinks -SourceDirectory $sharedAgentsSource -LegacySourceDirectory $agentsSource -DestinationExtension ".agent.md"

$requested = @($Targets | ForEach-Object { $_.ToLowerInvariant() })
if ($requested -contains "all") {
    $requested = @("codex", "claude", "copilot")
}

$validTargets = @("codex", "claude", "copilot")
foreach ($target in $requested) {
    if ($validTargets -notcontains $target) {
        throw "Unknown target: $target. Valid targets: $($validTargets -join ', ')"
    }
}

$codexHome = Get-ProfileRoot -EnvironmentName "CODEX_HOME" -DefaultLeaf ".codex"
$claudeHome = Get-ProfileRoot -EnvironmentName "CLAUDE_CONFIG_DIR" -DefaultLeaf ".claude"
$copilotHome = Get-ProfileRoot -EnvironmentName "COPILOT_HOME" -DefaultLeaf ".copilot"
$sharedAgentsHome = Get-ProfileRoot -EnvironmentName "AGENTS_HOME" -DefaultLeaf ".agents"

if ($requested -contains "codex") {
    Install-Link -Source $policySource -Destination (Join-Path $codexHome "AGENTS.md") -Kind File
    Add-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $sharedAgentsHome "skills") -LegacyLinks $legacySkillLinks
    Add-DirectoryLinks -SourceDirectory $codexAgentsSource -DestinationDirectory (Join-Path $codexHome "agents") -LegacyLinks $legacyCodexAgentLinks
    Remove-DirectoryLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "commands") -LegacyLinks $obsoleteCommandLinks
    Remove-DirectoryLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "prompts") -LegacyLinks $obsoleteCommandLinks

    if ($InstallCodexLegacySkills) {
        Add-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $codexHome "skills") -LegacyLinks $legacySkillLinks
    }
}

if ($requested -contains "claude") {
    Install-Link -Source $policySource -Destination (Join-Path $claudeHome "CLAUDE.md") -Kind File
    Add-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $claudeHome "skills") -LegacyLinks $legacySkillLinks
    Add-DirectoryLinks -SourceDirectory $sharedAgentsSource -DestinationDirectory (Join-Path $claudeHome "agents") -LegacyLinks $legacyClaudeAgentLinks
    Remove-DirectoryLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $claudeHome "commands") -LegacyLinks $obsoleteCommandLinks
}

if ($requested -contains "copilot") {
    Install-Link -Source $policySource -Destination (Join-Path $copilotHome "copilot-instructions.md") -Kind File
    Add-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $copilotHome "skills") -LegacyLinks $legacySkillLinks
    Add-DirectoryLinks -SourceDirectory $sharedAgentsSource -DestinationDirectory (Join-Path $copilotHome "agents") -LegacyLinks $legacyCopilotAgentLinks
}
