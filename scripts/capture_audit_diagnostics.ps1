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

$pid = (Invoke-AdbText shell "pidof $Package 2>/dev/null || true").Trim()
$currentIme = Invoke-AdbText shell "settings get secure default_input_method"
$device = Invoke-AdbText shell "printf 'manufacturer='; getprop ro.product.manufacturer; printf 'model='; getprop ro.product.model; printf 'build='; getprop ro.build.fingerprint; printf 'sdk='; getprop ro.build.version.sdk; printf 'release='; getprop ro.build.version.release"

Save-Text "summary.txt" @"
Package: $Package
PID: $pid
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
Save-Text "dropbox-crash-anr.txt" (Invoke-AdbText shell "dumpsys dropbox --print data_app_crash 2>/dev/null | grep -F -A80 -B8 '$Package' || true; dumpsys dropbox --print data_app_anr 2>/dev/null | grep -F -A80 -B8 '$Package' || true")
Save-Text "private-files.txt" (Invoke-AdbText shell "run-as $Package sh -c 'find files shared_prefs databases cache -type f -exec stat -c \"%n %s %y\" {} \\; 2>/dev/null | sort'")
Save-Text "private-file-hashes.txt" (Invoke-AdbText shell "run-as $Package sh -c 'find files -type f -exec sha256sum {} \\; 2>/dev/null | sort'")

if (-not [string]::IsNullOrWhiteSpace($pid)) {
    Save-Text "meminfo.txt" (Invoke-AdbText shell "dumpsys meminfo $Package")
    Save-Text "gfxinfo.txt" (Invoke-AdbText shell "dumpsys gfxinfo $Package")
    Save-Text "process.txt" (Invoke-AdbText shell "su -c 'cat /proc/$pid/status; echo ===LIMITS===; cat /proc/$pid/limits; echo ===MAPS===; cat /proc/$pid/maps; echo ===FDS===; ls -l /proc/$pid/fd; echo ===THREADS===; ls /proc/$pid/task'")
    Save-Text "logcat-warning-error.txt" (Invoke-AdbText logcat -d "--pid=$pid" -v threadtime "*:W")
    if ($IncludeVerboseLog) {
        Save-Text "logcat-verbose.txt" (Invoke-AdbText logcat -d "--pid=$pid" -v threadtime "*:V")
    }
} else {
    Save-Text "process-not-running.txt" "The package had no running process at capture time."
}

Write-Host "Diagnostics captured at: $OutputDirectory"
