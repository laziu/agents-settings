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

$ownedKeys = @("Platform", "Shell", "Bash", "POSIX shell", "Text search", "Files", "JSON", "VCS", "Scripting", "JavaScript", "Raster", "Media")

function Get-LineKey {
    param([string]$Line)

    if ($Line -match '^- ([^:]+):') {
        return $Matches[1]
    }

    return $null
}

# Replace owned lines in place, append missing ones to their section, and keep every other line.
function Merge-Profile {
    param(
        [string[]]$Generated,
        [string[]]$Existing
    )

    $present = @($Existing | ForEach-Object { Get-LineKey $_ } | Where-Object { $null -ne $_ })
    $emitted = @{}
    $missing = @{}
    $generatedHeader = $null
    $section = ""
    foreach ($line in $Generated) {
        $key = Get-LineKey $line
        if ($line.StartsWith("## ")) {
            $section = $line
        }
        elseif ($line.StartsWith("Generated: ")) {
            $generatedHeader = $line
        }
        elseif ($null -ne $key) {
            $emitted[$key] = $line
            if ($present -cnotcontains $key) {
                if (-not $missing.ContainsKey($section)) {
                    $missing[$section] = [System.Collections.Generic.List[string]]::new()
                }
                $missing[$section].Add($line)
            }
        }
    }

    $result = [System.Collections.Generic.List[string]]::new()
    $blanks = 0
    $section = ""
    $flush = {
        if ($missing.ContainsKey($section)) {
            $result.AddRange($missing[$section])
        }
        for (; $blanks -gt 0; $blanks--) { $result.Add("") }
    }

    foreach ($line in $Existing) {
        if ($line.StartsWith("## ")) {
            . $flush
            $section = $line
            $result.Add($line)
            continue
        }

        if ($line -eq "") {
            $blanks++
            continue
        }

        for (; $blanks -gt 0; $blanks--) { $result.Add("") }
        $key = Get-LineKey $line
        if ($line.StartsWith("Generated: ")) {
            $result.Add($generatedHeader)
        }
        elseif ($null -ne $key -and $ownedKeys -ccontains $key) {
            if ($emitted.ContainsKey($key)) {
                $result.Add($emitted[$key])
            }
        }
        else {
            $result.Add($line)
        }
    }
    . $flush

    return $result.ToArray()
}

$outputFull = [System.IO.Path]::GetFullPath($OutputPath)
$existingLines = @()
if (Test-Path -LiteralPath $outputFull) {
    $existingLines = @(Get-Content -LiteralPath $outputFull)
}

if ($existingLines.Count -gt 0) {
    $mergeError = $null
    foreach ($heading in @("# Local Environment", "## Host", "## Tasks")) {
        if ($existingLines -cnotcontains $heading) {
            $mergeError = "missing '$heading'"
            break
        }
    }

    if ($null -eq $mergeError) {
        $duplicate = $existingLines |
            ForEach-Object { Get-LineKey $_ } |
            Where-Object { $ownedKeys -ccontains $_ } |
            Group-Object -CaseSensitive |
            Where-Object { $_.Count -gt 1 } |
            Select-Object -First 1
        if ($null -ne $duplicate) {
            $mergeError = "duplicate '- $($duplicate.Name):'"
        }
    }

    if ($null -ne $mergeError) {
        $savePath = Join-Path (Split-Path -Parent $outputFull) "local-environment.save.md"
        throw "Cannot merge existing ${outputFull}: $mergeError. Move it to $savePath and rerun."
    }
}

$action = if ($existingLines.Count -gt 0) { "MERGE" } else { "GENERATE" }
if ($DryRun) {
    Write-Host "$action $outputFull"
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

if ($action -eq "MERGE") {
    $lines = @(Merge-Profile -Generated $lines -Existing $existingLines)
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

Write-Host "${action}D $outputFull"
