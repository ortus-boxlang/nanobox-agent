# NanoBox — AI Agent Platform
# Windows PowerShell entry point

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$BoxLang = Get-Command boxlang -ErrorAction SilentlyContinue
if (-not $BoxLang) {
    $candidates = @(
        "$env:USERPROFILE\.bvm\current\bin\boxlang.bat",
        "$env:LOCALAPPDATA\boxlang\bin\boxlang.bat",
        "$env:ProgramFiles\boxlang\bin\boxlang.bat",
        "$env:USERPROFILE\.boxlang\bin\boxlang.bat"
    )
    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            $BoxLang = $candidate
            break
        }
    }
}

if (-not $BoxLang) {
    Write-Error "Error: boxlang was not found. Install BoxLang: https://boxlang.ortusbooks.com/getting-started/installation"
    exit 4
}

if (-not $env:NANOBOX_HOME) {
    $env:NANOBOX_HOME = Join-Path $env:USERPROFILE ".nanobox"
}

$CliScript = Join-Path $env:NANOBOX_HOME "current\nanobox.bx"
if (-not (Test-Path $CliScript)) {
    $CliScript = Join-Path $ScriptDir "nanobox.bx"
}
if (-not (Test-Path $CliScript)) {
    Write-Error "Error: nanobox.bx not found in $env:NANOBOX_HOME\current or beside this wrapper."
    exit 1
}

& $BoxLang $CliScript @args
exit $LASTEXITCODE
