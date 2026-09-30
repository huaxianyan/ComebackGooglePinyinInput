[CmdletBinding()]
param(
    [string]$ApplicationId = "com.google.android.inputmethod.pinyin.pairauto",
    [int]$VersionCode = 0,
    [string]$VersionName = "",
    [switch]$NoDebuggable
)

# Builds an isolated audit APK from the pristine Google Pinyin 4.5.2 APK.
#
# Real-device acceptance must never overwrite the formal application ID with an
# unverified build. This script always patches a coexisting audit ID and signs
# with the local audit keystore, so the formal `compat` install on the device is
# untouched and the audit package can be uninstalled afterwards.
#
# The audit keystore is generated on first run and kept under work/audit-signing/.
# It is deliberately separate from the formal signing identity, which lives
# outside the repository.

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$ToolsDir = Join-Path $RepoRoot "work/tools"
$FrameworkDir = Join-Path $RepoRoot "work/apktool-framework-audit"
$DecodedDir = Join-Path $RepoRoot "work/audit-decoded"
$BuildDir = Join-Path $RepoRoot "build-audit"
$DistDir = Join-Path $RepoRoot "dist-audit"
$TempDir = Join-Path $RepoRoot "work/tmp-audit"
$SigningDir = Join-Path $RepoRoot "work/audit-signing"
$Keystore = Join-Path $SigningDir "audit-signing.p12"
$KeyAlias = "audit"
$KeyPassword = "audit123"

$ApkPath = Join-Path $RepoRoot "work/source/google-pinyin-4.5.2-original.apk"
$ApktoolJar = Join-Path $ToolsDir "apktool.jar"
$SignerJar = Join-Path $ToolsDir "uber-apk-signer.jar"

foreach ($required in @($ApkPath, $ApktoolJar, $SignerJar)) {
    if (-not (Test-Path $required)) { throw "missing required file: $required" }
}

if ($ApplicationId -eq "com.google.android.inputmethod.pinyin.compat") {
    throw "Refusing to build an audit package under the formal application ID"
}

New-Item -ItemType Directory -Force $BuildDir, $DistDir, $FrameworkDir, $TempDir, $SigningDir | Out-Null
if (Test-Path $DecodedDir) { Remove-Item -Recurse -Force $DecodedDir }

# Keep apktool and signer temporary files inside the repository workspace.
$env:TEMP = $TempDir
$env:TMP = $TempDir
$env:JAVA_TOOL_OPTIONS = "-Djava.io.tmpdir=$TempDir"

# 1. Generate the audit keystore on first run. It only needs to be stable across
#    rebuilds of the audit package so re-installing keeps the same identity.
if (-not (Test-Path $Keystore)) {
    Write-Host "[0/5] Generating the local audit keystore..."
    & keytool -genkeypair `
        -keystore $Keystore `
        -storetype PKCS12 `
        -alias $KeyAlias `
        -keyalg RSA -keysize 2048 -validity 10000 `
        -storepass $KeyPassword -keypass $KeyPassword `
        -dname "CN=Google Pinyin Audit, OU=Coexistence, O=Local, L=Local, S=Local, C=CN"
    if ($LASTEXITCODE -ne 0) { throw "audit keystore generation failed" }
}

Write-Host "[1/5] Decoding the pristine APK..."
& java -jar $ApktoolJar d -f -p $FrameworkDir -o $DecodedDir $ApkPath
if ($LASTEXITCODE -ne 0) { throw "apktool decode failed" }

Write-Host "[2/5] Applying compatibility patches for $ApplicationId..."
# The patcher reads version.properties by default, so an explicit version code
# is only needed when the caller wants to pin one.
$PatchArguments = @($DecodedDir, "--application-id", $ApplicationId)
if (-not $NoDebuggable) { $PatchArguments += "--debuggable" }
if ($VersionCode -gt 0) { $PatchArguments += @("--version-code", "$VersionCode") }
if ($VersionName -ne "") { $PatchArguments += @("--version-name", $VersionName) }
& python (Join-Path $PSScriptRoot "apply_patches.py") @PatchArguments
if ($LASTEXITCODE -ne 0) { throw "patching failed" }

Write-Host "[3/5] Rebuilding the APK..."
$UnsignedApk = Join-Path $BuildDir "google-pinyin-4.5.2-audit-unsigned.apk"
& java -jar $ApktoolJar b -p $FrameworkDir -o $UnsignedApk $DecodedDir
if ($LASTEXITCODE -ne 0) { throw "apktool build failed" }

Write-Host "[4/5] Aligning and signing the audit APK..."
& java -jar $SignerJar `
    -a $UnsignedApk `
    --ks $Keystore `
    --ksAlias $KeyAlias `
    --ksPass $KeyPassword `
    --ksKeyPass $KeyPassword `
    -o $DistDir
if ($LASTEXITCODE -ne 0) { throw "audit APK signing failed" }

Write-Host "[5/5] Done. Audit APK is in: $DistDir"
Get-ChildItem $DistDir -Filter "*.apk" | Select-Object Name, Length
