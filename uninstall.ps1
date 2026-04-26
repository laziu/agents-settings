[CmdletBinding()]
param(
    [string[]]$Targets = @("codex", "claude", "copilot"),
    [switch]$DryRun,
    [Alias("InstallCodexLegacySkills")]
    [switch]$IncludeCodexLegacySkills
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

function Remove-LinkIfOwned {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $destinationFull = [System.IO.Path]::GetFullPath($Destination)
    $existing = Get-Item -LiteralPath $destinationFull -Force -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        Write-Host "MISS    $destinationFull"
        return
    }

    $target = Get-ReparseTarget $existing
    if ($null -eq $target) {
        Write-Host "SKIP    $destinationFull is not a link"
        return
    }

    $sourceFull = Get-FullPath $Source
    $targetFull = Resolve-LinkTargetPath -LinkPath $destinationFull -Target $target
    if ($targetFull -ine $sourceFull) {
        Write-Host "SKIP    $destinationFull points elsewhere: $targetFull"
        return
    }

    Write-Host "REMOVE  $destinationFull"
    if (-not $DryRun) {
        Remove-Item -LiteralPath $destinationFull -Force
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

function Remove-DirectoryLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory,
        [object[]]$LegacyLinks = @()
    )

    $destinationFull = [System.IO.Path]::GetFullPath($DestinationDirectory)
    $existing = Get-Item -LiteralPath $destinationFull -Force -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        Write-Host "MISS    $destinationFull"
        return
    }

    if ($null -ne (Get-ReparseTarget $existing)) {
        Remove-LinkIfOwned -Source $SourceDirectory -Destination $DestinationDirectory
        return
    }

    if (-not $existing.PSIsContainer) {
        Write-Host "SKIP    $destinationFull is not a link"
        return
    }

    foreach ($legacyLink in @($LegacyLinks)) {
        $destination = Join-Path $DestinationDirectory $legacyLink.DestinationName
        Remove-LinkIfOwned -Source $legacyLink.Source -Destination $destination
    }
}

$script:UserProfile = [Environment]::GetFolderPath("UserProfile")
if ([string]::IsNullOrWhiteSpace($script:UserProfile)) {
    $script:UserProfile = $env:USERPROFILE
}

$repoRoot = $PSScriptRoot
$policySource = Join-Path $repoRoot "settings\AGENTS.md"
$skillsSource = Join-Path $repoRoot "settings\skills"
$agentsSource = Join-Path $repoRoot "settings\agents"
$sharedAgentsSource = Join-Path $repoRoot "settings\agents\shared"
$codexAgentsSource = Join-Path $repoRoot "settings\agents\codex"
$commandsSource = Join-Path $repoRoot "settings\commands"

$legacySkillLinks = Get-LegacyChildLinks -SourceDirectory $skillsSource -Kind Directory
$legacyCommandLinks = Get-LegacyChildLinks -SourceDirectory $commandsSource -Kind File -Filter "*.md"
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
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $codexHome "AGENTS.md")
    Remove-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $sharedAgentsHome "skills") -LegacyLinks $legacySkillLinks
    Remove-DirectoryLinks -SourceDirectory $codexAgentsSource -DestinationDirectory (Join-Path $codexHome "agents") -LegacyLinks $legacyCodexAgentLinks
    Remove-DirectoryLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "commands") -LegacyLinks $legacyCommandLinks
    # Remove the legacy prompts link created by earlier installs.
    Remove-DirectoryLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "prompts") -LegacyLinks $legacyCommandLinks

    if ($IncludeCodexLegacySkills) {
        Remove-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $codexHome "skills") -LegacyLinks $legacySkillLinks
    }
}

if ($requested -contains "claude") {
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $claudeHome "CLAUDE.md")
    Remove-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $claudeHome "skills") -LegacyLinks $legacySkillLinks
    Remove-DirectoryLinks -SourceDirectory $sharedAgentsSource -DestinationDirectory (Join-Path $claudeHome "agents") -LegacyLinks $legacyClaudeAgentLinks
    Remove-DirectoryLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $claudeHome "commands") -LegacyLinks $legacyCommandLinks
}

if ($requested -contains "copilot") {
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $copilotHome "copilot-instructions.md")
    Remove-DirectoryLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $copilotHome "skills") -LegacyLinks $legacySkillLinks
    Remove-DirectoryLinks -SourceDirectory $sharedAgentsSource -DestinationDirectory (Join-Path $copilotHome "agents") -LegacyLinks $legacyCopilotAgentLinks
}
