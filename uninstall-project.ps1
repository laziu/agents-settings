[CmdletBinding()]
param(
    [string]$ProjectDir = "",
    [string[]]$Targets = @("copilot", "junie", "ai"),
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
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $ProjectDir ".github\copilot-instructions.md")
}

if ($requested -contains "junie") {
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $ProjectDir ".junie\guidelines.md")
}

if ($requested -contains "ai") {
    Remove-LinkIfOwned -Source $policySource -Destination (Join-Path $ProjectDir ".ai\rules\harness.md")
}
