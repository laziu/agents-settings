<#
Output contract and capability selection rationale:
../references/profile-format.md
#>

[CmdletBinding()]
param(
    [string]$OutputPath,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-FirstLine {
    param([object[]]$Value)

    foreach ($line in @($Value)) {
        $text = [string]$line
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            return $text.Trim()
        }
    }

    return $null
}

function Invoke-Probe {
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [string[]]$Arguments = @()
    )

    $resolved = Get-Command -Name $Command -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($null -eq $resolved) {
        return $null
    }

    try {
        $output = & $resolved.Path @Arguments 2>&1
        if ($LASTEXITCODE -ne 0) {
            return $null
        }

        return Get-FirstLine $output
    }
    catch {
        return $null
    }
}

$userProfile = [Environment]::GetFolderPath("UserProfile")
if ([string]::IsNullOrWhiteSpace($userProfile)) {
    $userProfile = $env:USERPROFILE
}

$agentsHome = $env:AGENTS_HOME
if ([string]::IsNullOrWhiteSpace($agentsHome)) {
    $agentsHome = Join-Path $userProfile ".agents"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $agentsHome "context\local-environment.md"
}

$outputFull = [System.IO.Path]::GetFullPath($OutputPath)
if ($DryRun) {
    Write-Host "GENERATE $outputFull"
    return
}

$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
$shellInvocation = if ($PSVersionTable.PSEdition -eq "Core") { "pwsh" } else { "powershell" }

$bashProbe = Invoke-Probe -Command "bash" -Arguments @("--version")
$bashViaWsl = $bashProbe -match "linux-gnu"
$rgProbe = Invoke-Probe -Command "rg" -Arguments @("--version")
$fdProbe = Invoke-Probe -Command "fd" -Arguments @("--version")
$jqProbe = Invoke-Probe -Command "jq" -Arguments @("--version")
$gitProbe = Invoke-Probe -Command "git" -Arguments @("--version")
$nodeProbe = Invoke-Probe -Command "node" -Arguments @("--version")
$bunProbe = Invoke-Probe -Command "bun" -Arguments @("--version")
$ffmpegProbe = Invoke-Probe -Command "ffmpeg" -Arguments @("-version")

$pythonInvocation = $null
$pythonPrefix = @()
foreach ($candidate in @(
    @{ Command = "python"; Invocation = "python"; Prefix = @() },
    @{ Command = "py"; Invocation = "py -3"; Prefix = @("-3") },
    @{ Command = "python3"; Invocation = "python3"; Prefix = @() }
)) {
    $arguments = @($candidate.Prefix) + @("--version")
    $probe = Invoke-Probe -Command $candidate.Command -Arguments $arguments
    if (-not [string]::IsNullOrWhiteSpace($probe)) {
        $pythonInvocation = $candidate.Invocation
        $pythonPrefix = @($candidate.Prefix)
        break
    }
}

$pillowProbe = $null
if ($null -ne $pythonInvocation) {
    $pillowArguments = $pythonPrefix + @("-c", "import PIL; print(PIL.__version__)")
    $pythonCommand = $pythonInvocation.Split(" ")[0]
    $pillowProbe = Invoke-Probe -Command $pythonCommand -Arguments $pillowArguments
}

$imageMagickInvocation = "magick"
$imageMagickProbe = Invoke-Probe -Command "magick" -Arguments @("-version")
if ([string]::IsNullOrWhiteSpace($imageMagickProbe)) {
    $convertProbe = Invoke-Probe -Command "convert" -Arguments @("-version")
    if ($convertProbe -match "ImageMagick") {
        $imageMagickInvocation = "convert"
        $imageMagickProbe = $convertProbe
    }
}

$lines = @(
    "# Local Environment",
    "",
    ('Generated: `{0}`; project/session context wins.' -f (Get-Date -Format "yyyy-MM-ddTHH:mm:ssK")),
    "",
    "## Host",
    "",
    ('- Platform: Windows {0} (Windows paths)' -f $architecture),
    ('- Shell: `{0}`' -f $shellInvocation)
)

if ([string]::IsNullOrWhiteSpace($bashProbe)) {
    $lines += '- POSIX shell: unavailable'
}
elseif ($bashViaWsl) {
    $lines += '- POSIX shell: WSL `bash` (translate paths)'
}
else {
    $lines += '- POSIX shell: `bash`'
}

$lines += ""
$lines += "## Tasks"
$lines += ""

if ([string]::IsNullOrWhiteSpace($rgProbe)) {
    $lines += '- Text search: `Select-String`'
}
else {
    $lines += '- Text search: `rg`'
}

if (-not [string]::IsNullOrWhiteSpace($rgProbe)) {
    $lines += '- Files: `rg --files`'
}
elseif (-not [string]::IsNullOrWhiteSpace($fdProbe)) {
    $lines += '- Files: `fd`'
}
else {
    $lines += '- Files: `Get-ChildItem`'
}

if ([string]::IsNullOrWhiteSpace($jqProbe)) {
    $lines += '- JSON: PowerShell (`ConvertFrom-Json`, `ConvertTo-Json`)'
}
else {
    $lines += '- JSON: `jq`'
}

if ([string]::IsNullOrWhiteSpace($gitProbe)) {
    $lines += '- VCS: unresolved'
}
else {
    $lines += '- VCS: `git`'
}

if ($null -eq $pythonInvocation) {
    $lines += ('- Scripting: `{0}`' -f $shellInvocation)
}
else {
    $lines += ('- Scripting: `{0}`' -f $pythonInvocation)
}

if (-not [string]::IsNullOrWhiteSpace($nodeProbe)) {
    $lines += '- JavaScript: `node`'
}
elseif (-not [string]::IsNullOrWhiteSpace($bunProbe)) {
    $lines += '- JavaScript: `bun`'
}
else {
    $lines += '- JavaScript: unresolved'
}

if (-not [string]::IsNullOrWhiteSpace($imageMagickProbe)) {
    $lines += ('- Raster: `{0}`' -f $imageMagickInvocation)
}
elseif (-not [string]::IsNullOrWhiteSpace($pillowProbe)) {
    $lines += ('- Raster: `{0}` (Pillow)' -f $pythonInvocation)
}
else {
    $lines += '- Raster: unresolved'
}

if ([string]::IsNullOrWhiteSpace($ffmpegProbe)) {
    $lines += '- Media: unresolved'
}
else {
    $lines += '- Media: `ffmpeg`'
}

$parent = Split-Path -Parent $outputFull
New-Item -ItemType Directory -Path $parent -Force | Out-Null
$temporaryPath = Join-Path $parent (".local-environment.{0}.tmp" -f [guid]::NewGuid().ToString("N"))

try {
    [System.IO.File]::WriteAllLines($temporaryPath, $lines, [System.Text.UTF8Encoding]::new($false))
    Move-Item -LiteralPath $temporaryPath -Destination $outputFull -Force
}
finally {
    if (Test-Path -LiteralPath $temporaryPath) {
        Remove-Item -LiteralPath $temporaryPath -Force
    }
}

Write-Host "GENERATED $outputFull"
