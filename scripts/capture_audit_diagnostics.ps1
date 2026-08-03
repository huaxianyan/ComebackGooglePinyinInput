[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^com\.google\.android\.inputmethod\.pinyin\.(target[0-9]+audit|debugaudit)$')]
    [string]$Package,

    [string]$Adb = "adb",

    [string]$OutputDirectory,

    [switch]$IncludeVerboseLog
)

$ErrorActionPreference = "Stop"

function Invoke-AdbText {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments)
    $result = & $Adb @Arguments 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) {
        throw "adb failed: $Adb $($Arguments -join ' ')`n$result"
    }
    return $result.TrimEnd()
}

function Save-Text {
    param([string]$Name, [string]$Content)
    $path = Join-Path $OutputDirectory $Name
    $Content | Out-File -FilePath $path -Encoding utf8
}

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputDirectory = Join-Path "work/device-diagnostics" "$Package-$stamp"
}
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null

$state = Invoke-AdbText get-state
if ($state -ne "device") {
    throw "ADB device is not ready: $state"
}

$packageDump = Invoke-AdbText shell "dumpsys package $Package"
if ($packageDump -notmatch "android:debuggable|DEBUGGABLE") {
    # dumpsys formats differ by Android release. Confirm with run-as as the
    # authoritative check instead of assuming a missing text flag means false.
    $runAsProbe = & $Adb shell "run-as $Package id" 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) {
        throw "Package is not debuggable or run-as is unavailable: $runAsProbe"
    }
} else {
    $runAsProbe = Invoke-AdbText shell "run-as $Package id"
}

$processId = (Invoke-AdbText shell "pidof $Package 2>/dev/null || true").Trim()
$currentIme = Invoke-AdbText shell "settings get secure default_input_method"
$device = Invoke-AdbText shell "printf 'manufacturer='; getprop ro.product.manufacturer; printf 'model='; getprop ro.product.model; printf 'build='; getprop ro.build.fingerprint; printf 'sdk='; getprop ro.build.version.sdk; printf 'release='; getprop ro.build.version.release"

Save-Text "summary.txt" @"
Package: $Package
PID: $processId
Current IME: $currentIme
ADB state: $state
run-as: $runAsProbe
Verbose log included: $($IncludeVerboseLog.IsPresent)

$device

Privacy boundary:
- Clipboard contents, typed text, contacts and dictionary contents are not collected.
- Private-file names, sizes and SHA-256 values are collected, but file contents are not.
- Default log capture is warning/error only. Use -IncludeVerboseLog explicitly when needed and review it before sharing.
"@

Save-Text "package.txt" $packageDump
Save-Text "input-method.txt" (Invoke-AdbText shell "echo CURRENT=$currentIme; ime list -s; dumpsys input_method")
Save-Text "permissions-appops.txt" (Invoke-AdbText shell "dumpsys package $Package; echo ===APPOPS===; cmd appops get $Package")
$dropbox = @()
foreach ($tag in @("data_app_crash", "data_app_anr")) {
    $raw = Invoke-AdbText shell dumpsys dropbox --print $tag
    $lines = $raw -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -like "*$Package*") {
            $start = [Math]::Max(0, $i - 8)
            $end = [Math]::Min($lines.Count - 1, $i + 80)
            $dropbox += "=== $tag ==="
            $dropbox += $lines[$start..$end]
        }
    }
}
if ($dropbox.Count -eq 0) { $dropbox = @("No matching crash or ANR entries.") }
Save-Text "dropbox-crash-anr.txt" ($dropbox -join "`n")

$privateFiles = Invoke-AdbText shell run-as $Package find files shared_prefs -type f
Save-Text "private-files.txt" ((Invoke-AdbText shell run-as $Package ls -laR files shared_prefs) + "`n`n===FILE_PATHS===`n" + $privateFiles)
$privateHashes = @()
foreach ($privatePath in ($privateFiles -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
    $privateHashes += Invoke-AdbText shell run-as $Package sha256sum $privatePath
}
Save-Text "private-file-hashes.txt" (($privateHashes | Sort-Object) -join "`n")

if (-not [string]::IsNullOrWhiteSpace($processId)) {
    Save-Text "meminfo.txt" (Invoke-AdbText shell "dumpsys meminfo $Package")
    Save-Text "gfxinfo.txt" (Invoke-AdbText shell "dumpsys gfxinfo $Package")
    $processReport = @(
        Invoke-AdbText shell run-as $Package cat "/proc/$processId/status"
        "===LIMITS==="
        Invoke-AdbText shell run-as $Package cat "/proc/$processId/limits"
        "===MAPS==="
        Invoke-AdbText shell run-as $Package cat "/proc/$processId/maps"
        "===FDS==="
        Invoke-AdbText shell run-as $Package ls -l "/proc/$processId/fd"
        "===THREADS==="
        Invoke-AdbText shell run-as $Package ls "/proc/$processId/task"
    )
    Save-Text "process.txt" ($processReport -join "`n")
    $warningLogArgs = @("logcat", "-d", "--pid=$processId", "-v", "threadtime", "*:W")
    Save-Text "logcat-warning-error.txt" (Invoke-AdbText -Arguments $warningLogArgs)
    if ($IncludeVerboseLog) {
        $verboseLogArgs = @("logcat", "-d", "--pid=$processId", "-v", "threadtime", "*:V")
        Save-Text "logcat-verbose.txt" (Invoke-AdbText -Arguments $verboseLogArgs)
    }
} else {
    Save-Text "process-not-running.txt" "The package had no running process at capture time."
}

Write-Host "Diagnostics captured at: $OutputDirectory"
