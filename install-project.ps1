[CmdletBinding()]
param(
    [string]$ProjectDir = "",
    [string[]]$Targets = @("copilot", "junie", "ai"),
    [switch]$Force,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = (Get-Location).Path
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
        [Parameter(Mandatory = $true)][string]$Destination
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

$script:Timestamp = Get-Date -Format "yyyyMMddHHmmss"
$repoRoot = $PSScriptRoot
$policySource = Join-Path $repoRoot "settings\AGENTS.md"

$requested = @($Targets | ForEach-Object { $_.ToLowerInvariant() })
if ($requested -contains "all") {
    $requested = @("copilot", "junie", "ai")
}

$validTargets = @("copilot", "junie", "ai")
foreach ($target in $requested) {
    if ($validTargets -notcontains $target) {
        throw "Unknown target: $target. Valid targets: $($validTargets -join ', ')"
    }
}

if ($requested -contains "copilot") {
    Install-Link -Source $policySource -Destination (Join-Path $ProjectDir ".github\copilot-instructions.md")
}

if ($requested -contains "junie") {
    Install-Link -Source $policySource -Destination (Join-Path $ProjectDir ".junie\guidelines.md")
}

if ($requested -contains "ai") {
    Install-Link -Source $policySource -Destination (Join-Path $ProjectDir ".ai\rules\harness.md")
}
