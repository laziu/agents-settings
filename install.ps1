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

function Add-SkillLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    Get-ChildItem -LiteralPath $SourceDirectory -Directory -Force | ForEach-Object {
        $destination = Join-Path $DestinationDirectory $_.Name
        Install-Link -Source $_.FullName -Destination $destination -Kind Directory
    }
}

function Add-AgentLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory,
        [string]$DestinationExtension
    )

    Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.md" -Force |
        Where-Object { $_.Name -ne "README.md" } |
        ForEach-Object {
            $destination = Join-Path $DestinationDirectory "$($_.BaseName)$DestinationExtension"
            Install-Link -Source $_.FullName -Destination $destination -Kind File
        }
}

function Add-CommandLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.md" -Force | ForEach-Object {
        $destination = Join-Path $DestinationDirectory $_.Name
        Install-Link -Source $_.FullName -Destination $destination -Kind File
    }
}

function Add-CodexAgentLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.toml" -Force | ForEach-Object {
        $destination = Join-Path $DestinationDirectory $_.Name
        Install-Link -Source $_.FullName -Destination $destination -Kind File
    }
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
$codexAgentsSource = Join-Path $repoRoot "settings\agents\codex"
$commandsSource = Join-Path $repoRoot "settings\commands"

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
    Add-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $sharedAgentsHome "skills")
    Add-CodexAgentLinks -SourceDirectory $codexAgentsSource -DestinationDirectory (Join-Path $codexHome "agents")
    Add-CommandLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "commands")
    Add-CommandLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "prompts")

    if ($InstallCodexLegacySkills) {
        Add-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $codexHome "skills")
    }
}

if ($requested -contains "claude") {
    Install-Link -Source $policySource -Destination (Join-Path $claudeHome "CLAUDE.md") -Kind File
    Add-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $claudeHome "skills")
    Add-AgentLinks -SourceDirectory $agentsSource -DestinationDirectory (Join-Path $claudeHome "agents") -DestinationExtension ".md"
    Add-CommandLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $claudeHome "commands")
}

if ($requested -contains "copilot") {
    Install-Link -Source $policySource -Destination (Join-Path $copilotHome "copilot-instructions.md") -Kind File
    Add-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $copilotHome "skills")
    Add-AgentLinks -SourceDirectory $agentsSource -DestinationDirectory (Join-Path $copilotHome "agents") -DestinationExtension ".agent.md"
}
