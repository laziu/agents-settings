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

function Remove-SkillLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    Get-ChildItem -LiteralPath $SourceDirectory -Directory -Force | ForEach-Object {
        $destination = Join-Path $DestinationDirectory $_.Name
        Remove-LinkIfOwned -Source $_.FullName -Destination $destination
    }
}

function Remove-AgentLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory,
        [string]$DestinationExtension
    )

    Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.md" -Force |
        Where-Object { $_.Name -ne "README.md" } |
        ForEach-Object {
            $destination = Join-Path $DestinationDirectory "$($_.BaseName)$DestinationExtension"
            Remove-LinkIfOwned -Source $_.FullName -Destination $destination
        }
}

function Remove-CommandLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.md" -Force | ForEach-Object {
        $destination = Join-Path $DestinationDirectory $_.Name
        Remove-LinkIfOwned -Source $_.FullName -Destination $destination
    }
}

function Remove-CodexAgentLinks {
    param(
        [string]$DestinationDirectory,
        [string]$SourceDirectory
    )

    Get-ChildItem -LiteralPath $SourceDirectory -File -Filter "*.toml" -Force | ForEach-Object {
        $destination = Join-Path $DestinationDirectory $_.Name
        Remove-LinkIfOwned -Source $_.FullName -Destination $destination
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
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $codexHome "AGENTS.md")
    Remove-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $sharedAgentsHome "skills")
    Remove-CodexAgentLinks -SourceDirectory $codexAgentsSource -DestinationDirectory (Join-Path $codexHome "agents")
    Remove-CommandLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "commands")
    Remove-CommandLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $codexHome "prompts")

    if ($IncludeCodexLegacySkills) {
        Remove-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $codexHome "skills")
    }
}

if ($requested -contains "claude") {
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $claudeHome "CLAUDE.md")
    Remove-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $claudeHome "skills")
    Remove-AgentLinks -SourceDirectory $agentsSource -DestinationDirectory (Join-Path $claudeHome "agents") -DestinationExtension ".md"
    Remove-CommandLinks -SourceDirectory $commandsSource -DestinationDirectory (Join-Path $claudeHome "commands")
}

if ($requested -contains "copilot") {
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $copilotHome "copilot-instructions.md")
    Remove-SkillLinks -SourceDirectory $skillsSource -DestinationDirectory (Join-Path $copilotHome "skills")
    Remove-AgentLinks -SourceDirectory $agentsSource -DestinationDirectory (Join-Path $copilotHome "agents") -DestinationExtension ".agent.md"
}
