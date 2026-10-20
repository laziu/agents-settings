[CmdletBinding()]
param(
    [string[]]$Targets = @("codex", "claude", "copilot", "antigravity", "opencode"),
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

function Test-SettingsLink {
    param([System.IO.FileSystemInfo]$Item)

    $target = Get-ReparseTarget $Item
    if ($null -eq $target) {
        return $false
    }

    $targetFull = Resolve-LinkTargetPath -LinkPath $Item.FullName -Target $target
    return $targetFull.StartsWith("$script:SettingsRoot\", [System.StringComparison]::OrdinalIgnoreCase)
}

# Link each child separately so tool-managed entries can share the directory.
function Add-ChildLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    if (-not (Test-Path -LiteralPath $SourceDirectory)) {
        throw "Source not found: $SourceDirectory"
    }

    $destinationFull = [System.IO.Path]::GetFullPath($DestinationDirectory)
    $existing = Get-Item -LiteralPath $destinationFull -Force -ErrorAction SilentlyContinue
    $sourceChildren = @(Get-ChildItem -LiteralPath $SourceDirectory -Force | Where-Object { -not $_.Name.StartsWith(".") })
    if ($null -ne $existing -and $null -ne (Get-ReparseTarget $existing)) {
        if (-not (Test-SettingsLink $existing) -and -not $Force) {
            throw "Existing link points elsewhere: $destinationFull. Use -Force to replace it."
        }

        Write-Host "UNLINK  $destinationFull"
        if ($DryRun) {
            foreach ($child in $sourceChildren) {
                Write-Host "LINK    $(Join-Path $destinationFull $child.Name) -> $($child.FullName)"
            }
            return
        }
        Remove-Item -LiteralPath $destinationFull -Force
        $existing = $null
    }

    if ($null -ne $existing) {
        foreach ($child in @(Get-ChildItem -LiteralPath $destinationFull -Force)) {
            # Test-Path on the link itself reports dangling file links as present.
            if ((Test-SettingsLink $child) -and -not (Test-Path -LiteralPath (Resolve-LinkTargetPath -LinkPath $child.FullName -Target (Get-ReparseTarget $child)))) {
                Write-Host "REMOVE  $($child.FullName)"
                if (-not $DryRun) {
                    Remove-Item -LiteralPath $child.FullName -Force
                }
            }
        }
    }

    foreach ($child in $sourceChildren) {
        $kind = if ($child.PSIsContainer) { "Directory" } else { "File" }
        Install-Link -Source $child.FullName -Destination (Join-Path $destinationFull $child.Name) -Kind $kind
    }
}

$script:UserProfile = [Environment]::GetFolderPath("UserProfile")
if ([string]::IsNullOrWhiteSpace($script:UserProfile)) {
    $script:UserProfile = $env:USERPROFILE
}

$script:Timestamp = Get-Date -Format "yyyyMMddHHmmss"
$repoRoot = $PSScriptRoot
$script:SettingsRoot = Get-FullPath (Join-Path $repoRoot "settings")
$policySource = Join-Path $repoRoot "settings\AGENTS.md"
$claudePolicySource = Join-Path $repoRoot "settings\CLAUDE.md"
$skillsSource = Join-Path $repoRoot "settings\skills"
$referencesSource = Join-Path $repoRoot "settings\references"
$sharedAgentsSource = Join-Path $repoRoot "settings\agents\shared"
$codexAgentsSource = Join-Path $repoRoot "settings\agents\codex"
$localEnvironmentGenerator = Join-Path $skillsSource "local-environment\scripts\generate.ps1"


$requested = @($Targets | ForEach-Object { $_.ToLowerInvariant() })
if ($requested -contains "all") {
    $requested = @("codex", "claude", "copilot", "antigravity", "opencode")
}

$validTargets = @("codex", "claude", "copilot", "antigravity", "opencode")
foreach ($target in $requested) {
    if ($validTargets -notcontains $target) {
        throw "Unknown target: $target. Valid targets: $($validTargets -join ', ')"
    }
}

$codexHome = Get-ProfileRoot -EnvironmentName "CODEX_HOME" -DefaultLeaf ".codex"
$claudeHome = Get-ProfileRoot -EnvironmentName "CLAUDE_CONFIG_DIR" -DefaultLeaf ".claude"
$copilotHome = Get-ProfileRoot -EnvironmentName "COPILOT_HOME" -DefaultLeaf ".copilot"
$antigravityHome = Get-ProfileRoot -EnvironmentName "GEMINI_CONFIG_DIR" -DefaultLeaf ".gemini"
$xdgConfigHome = Get-ProfileRoot -EnvironmentName "XDG_CONFIG_HOME" -DefaultLeaf ".config"
$opencodeHome = Join-Path $xdgConfigHome "opencode"
$sharedAgentsHome = Get-ProfileRoot -EnvironmentName "AGENTS_HOME" -DefaultLeaf ".agents"
$localEnvironmentProfile = Join-Path $sharedAgentsHome "context\local-environment.md"

if (-not (Test-Path -LiteralPath $localEnvironmentGenerator)) {
    throw "Local environment generator not found: $localEnvironmentGenerator"
}

& $localEnvironmentGenerator -OutputPath $localEnvironmentProfile -DryRun:$DryRun

if ($requested -contains "codex") {
    Install-Link -Source $policySource -Destination (Join-Path $codexHome "AGENTS.md") -Kind File
    Install-Link -Source $referencesSource -Destination (Join-Path $codexHome "references") -Kind Directory
    Add-ChildLinks -SourceDirectory $codexAgentsSource -DestinationDirectory (Join-Path $codexHome "agents")

    if ($InstallCodexLegacySkills) {
        Add-ChildLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $codexHome "skills")
    }
}

if ($requested -contains "claude") {
    Install-Link -Source $policySource -Destination (Join-Path $claudeHome "AGENTS.md") -Kind File
    $claudePolicyDestination = Join-Path $claudeHome "CLAUDE.md"
    $existingClaudePolicy = Get-Item -LiteralPath ([System.IO.Path]::GetFullPath($claudePolicyDestination)) -Force -ErrorAction SilentlyContinue
    $migratedClaudePolicy = $false
    if ($null -ne $existingClaudePolicy) {
        $target = Get-ReparseTarget $existingClaudePolicy
        if ($null -ne $target) {
            $targetFull = Resolve-LinkTargetPath -LinkPath $claudePolicyDestination -Target $target
            if ($targetFull -ieq (Get-FullPath $policySource)) {
                Write-Host "RELINK  $claudePolicyDestination -> $(Get-FullPath $claudePolicySource)"
                if (-not $DryRun) {
                    Remove-Item -LiteralPath $claudePolicyDestination -Force
                }
                $migratedClaudePolicy = $true
            }
        }
    }

    if ($DryRun -and $migratedClaudePolicy) {
        Write-Host "LINK    $claudePolicyDestination -> $(Get-FullPath $claudePolicySource)"
    }
    else {
        Install-Link -Source $claudePolicySource -Destination $claudePolicyDestination -Kind File
    }
    Install-Link -Source $referencesSource -Destination (Join-Path $claudeHome "references") -Kind Directory
    Add-ChildLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $claudeHome "skills")
    Add-ChildLinks -SourceDirectory $sharedAgentsSource -DestinationDirectory (Join-Path $claudeHome "agents")
}

if ($requested -contains "copilot") {
    Install-Link -Source $policySource -Destination (Join-Path $copilotHome "copilot-instructions.md") -Kind File
    Install-Link -Source $referencesSource -Destination (Join-Path $copilotHome "references") -Kind Directory
    Add-ChildLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $copilotHome "skills")
    Add-ChildLinks -SourceDirectory $sharedAgentsSource -DestinationDirectory (Join-Path $copilotHome "agents")
}

if ($requested -contains "antigravity") {
    Install-Link -Source $policySource -Destination (Join-Path $antigravityHome "GEMINI.md") -Kind File
    Install-Link -Source $referencesSource -Destination (Join-Path $antigravityHome "references") -Kind Directory
    Add-ChildLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $antigravityHome "skills")
}

if ($requested -contains "opencode") {
    Install-Link -Source $policySource -Destination (Join-Path $opencodeHome "AGENTS.md") -Kind File
}

if (($requested -contains "codex") -or ($requested -contains "opencode")) {
    Add-ChildLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $sharedAgentsHome "skills")
}
