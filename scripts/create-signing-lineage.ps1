#requires -Version 7.0
<#
为 Backup 中的旧发布密钥与当前发布密钥生成签名传承记录。
口令由 apksigner 从终端或指定环境变量读取，不接收明文口令参数，也不保存口令。
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SigningDirectory,
    [string]$OldKeyAlias,
    [string]$NewKeyAlias,
    [string]$JdkDirectory,
    [string]$ApksignerJar,
    [string]$OldStorePasswordEnv,
    [string]$OldKeyPasswordEnv,
    [string]$NewStorePasswordEnv,
    [string]$NewKeyPasswordEnv
)

$ErrorActionPreference = 'Stop'
$signingNames = Get-Content -LiteralPath (Join-Path $PSScriptRoot '../signing/signing-materials.json') -Raw |
    ConvertFrom-Json
if (-not $NewKeyAlias) { $NewKeyAlias = $signingNames.keyAlias }

Import-Module (Join-Path $PSScriptRoot 'signing-material-tools.psm1') -Force

if (-not $JdkDirectory) {
    $JdkDirectory = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
}
if (-not $JdkDirectory) {
    throw '未配置 JAVA_HOME。请通过 -JdkDirectory 指定现有 JDK 目录。'
}
$java = Join-Path $JdkDirectory 'bin/java.exe'
if (-not (Test-Path -LiteralPath $java -PathType Leaf)) {
    throw '未找到 Java。请通过 -JdkDirectory 指定有效的现有 JDK 目录。'
}
if (-not $ApksignerJar) {
    $sdk = [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'User')
    if (-not $sdk) {
        throw '未配置 ANDROID_HOME。请通过 -ApksignerJar 指定现有签名工具。'
    }
    # Keep the pinned Build-Tools version in the host builder, not a second definition.
    $buildToolsVersion = & python -c 'import sys; sys.path.insert(0, sys.argv[1]); from build_modern_settings_host import BUILD_TOOLS_VERSION; print(BUILD_TOOLS_VERSION)' $PSScriptRoot
    if ($LASTEXITCODE -ne 0) {
        throw '无法读取项目工具版本。请检查 Python，或通过 -ApksignerJar 指定现有签名工具。'
    }
    $ApksignerJar = Join-Path $sdk "build-tools/$($buildToolsVersion.Trim())/lib/apksigner.jar"
}
if (-not (Test-Path -LiteralPath $ApksignerJar -PathType Leaf)) {
    throw '未找到 apksigner。请通过 -ApksignerJar 指定现有签名工具。'
}

$directory = (Resolve-Path -LiteralPath $SigningDirectory).ProviderPath
$baseName = $signingNames.fileBaseName
$oldKeystore = Join-Path $directory "Backup/$baseName.p12"
$newKeystore = Join-Path $directory "$baseName.p12"
$oldCertificate = Join-Path $directory "Backup/$baseName-certificate.pem"
$newCertificate = Join-Path $directory "$baseName-certificate.pem"
$lineage = Join-Path $directory "$baseName-lineage.bin"
$information = Join-Path $directory 'SIGNING-LINEAGE-INFO.txt'
foreach ($file in @($oldCertificate, $newCertificate)) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "缺少公开证书：$file。请检查目录，不要重新生成已有密钥。"
    }
}
if (-not (Test-Path -LiteralPath $lineage)) {
    foreach ($file in @($oldKeystore, $newKeystore)) {
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
            throw "缺少签名材料：$file。请检查目录，不要重新生成已有密钥。"
        }
    }
    foreach ($name in @($OldStorePasswordEnv, $OldKeyPasswordEnv, $NewStorePasswordEnv, $NewKeyPasswordEnv)) {
        if ($name -and [string]::IsNullOrEmpty([Environment]::GetEnvironmentVariable($name, 'Process'))) {
            throw "缺少指定的口令环境变量：$name。请检查终端或 CI 配置。"
        }
    }
}
$expectedOld = Get-PemCertificateSha256 (Get-Content -LiteralPath $oldCertificate -Raw)
$expectedNew = Get-PemCertificateSha256 (Get-Content -LiteralPath $newCertificate -Raw)
Write-Host "旧证书 SHA-256：$expectedOld"
Write-Host "新证书 SHA-256：$expectedNew"

$temporaryLineage = Join-Path $directory ([IO.Path]::GetRandomFileName() + '.lineage')
try {
    if (Test-Path -LiteralPath $lineage) {
        Write-Host '已有传承记录，本次仅核对其证书与迁移权限。'
        $candidate = $lineage
    } else {
        Write-Host '即将生成旧密钥到新密钥的传承记录。'
        Write-Host '口令通过指定的环境变量或签名工具的终端提示读取。'
        $arguments = @('-jar', $ApksignerJar, 'rotate', '--out', $temporaryLineage,
            '--old-signer', '--ks', $oldKeystore, '--ks-type', 'PKCS12')
        if ($OldKeyAlias) { $arguments += @('--ks-key-alias', $OldKeyAlias) }
        if ($OldStorePasswordEnv) { $arguments += @('--ks-pass', "env:$OldStorePasswordEnv") }
        if ($OldKeyPasswordEnv) { $arguments += @('--key-pass', "env:$OldKeyPasswordEnv") }
        $arguments += @('--set-installed-data', 'true', '--set-rollback', 'false',
            '--new-signer', '--ks', $newKeystore, '--ks-type', 'PKCS12',
            '--ks-key-alias', $NewKeyAlias)
        if ($NewStorePasswordEnv) { $arguments += @('--ks-pass', "env:$NewStorePasswordEnv") }
        if ($NewKeyPasswordEnv) { $arguments += @('--key-pass', "env:$NewKeyPasswordEnv") }
        # Do not capture or pipe the interactive process: keep passwords in its console.
        & $java @arguments
        if ($LASTEXITCODE -ne 0) {
            throw '传承记录生成失败。请核对口令和别名。旧库有多条私钥时，请通过 -OldKeyAlias 指定。已有密钥保持原样。'
        }
        $candidate = $temporaryLineage
    }

    # This command only reads the public lineage and never requests a password.
    $details = @(& $java -jar $ApksignerJar lineage --in $candidate --print-certs)
    if ($LASTEXITCODE -ne 0) {
        throw '无法校验传承记录。请保留已有密钥，检查签名工具的错误信息。'
    }
    $text = $details -join "`n"
    $certificates = [regex]::Matches($text, '(?m)^Signer #\d+ in lineage certificate SHA-256 digest: ([0-9a-fA-F]+)\s*$')
    if ($certificates.Count -ne 2 -or
        $certificates[0].Groups[1].Value.ToUpperInvariant() -ne $expectedOld -or
        $certificates[1].Groups[1].Value.ToUpperInvariant() -ne $expectedNew) {
        throw '传承记录的证书或顺序与公开证书不一致。请检查所选目录与密钥别名。'
    }
    $oldSection = ($text -split '(?m)^Signer #2 in lineage')[0]
    if ($oldSection -notmatch '(?m)^Has installed data capability\s*:\s*true\s*$' -or
        $oldSection -notmatch '(?m)^Has rollback capability\s*:\s*false\s*$') {
        throw '传承记录的迁移权限不符合本次方案。请保留文件并核对配置，不要直接用于发布。'
    }
    if ($candidate -eq $temporaryLineage) {
        Move-Item -LiteralPath $temporaryLineage -Destination $lineage
    }
    $details | Set-Content -LiteralPath $information -Encoding utf8
    $details | ForEach-Object { Write-Host $_ }
    Write-Host ''
    Write-Host "传承记录已核对：$lineage"
    Write-Host "公开核对信息：$information"
    Write-Host '记录仅包含公开证书及轮换证明，可以在核对后交给构建使用。'
    Write-Host '本步骤完成后仍需接入构建与 CI，并核对正式迁移版产物。'
} finally {
    if (Test-Path -LiteralPath $temporaryLineage) {
        Remove-Item -LiteralPath $temporaryLineage
    }
}
