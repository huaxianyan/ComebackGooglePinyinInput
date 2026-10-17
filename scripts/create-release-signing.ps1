#requires -Version 7.0
<#
在给定目录中生成发布密钥，或继续导出已有密钥的公开证书。
口令仅由 keytool 在终端中交互读取，不作为脚本参数或文件保存。
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,
    [string]$KeyAlias,
    [string]$DistinguishedName = 'CN=ComebackGooglePinyinInput Release,O=ComebackGooglePinyinInput',
    [string]$KeytoolPath
)

$ErrorActionPreference = 'Stop'
$signingNames = Get-Content -LiteralPath (Join-Path $PSScriptRoot '../signing/signing-materials.json') -Raw |
    ConvertFrom-Json
if (-not $KeyAlias) { $KeyAlias = $signingNames.keyAlias }

if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
    throw '无法访问输出目录。请检查路径和存储连接后重试。'
}
if ([string]::IsNullOrWhiteSpace($KeytoolPath)) {
    $jdk = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
    if ($jdk) {
        $candidate = Join-Path $jdk 'bin/keytool.exe'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            $KeytoolPath = $candidate
        }
    }
    if (-not $KeytoolPath) {
        $command = Get-Command keytool -CommandType Application -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($command) { $KeytoolPath = $command.Source }
    }
}
if (-not $KeytoolPath -or -not (Test-Path -LiteralPath $KeytoolPath -PathType Leaf)) {
    throw '未找到 keytool。请通过 -KeytoolPath 指定现有 JDK 中的 keytool。'
}

$directory = (Resolve-Path -LiteralPath $OutputDirectory).ProviderPath
$baseName = $signingNames.fileBaseName
$keystore = Join-Path $directory "$baseName.p12"
$certificate = Join-Path $directory "$baseName-certificate.pem"
$information = Join-Path $directory 'SIGNING-INFO.txt'

if (-not (Test-Path -LiteralPath $keystore)) {
    if (Test-Path -LiteralPath $certificate) {
        throw '目录中已有公开证书，但缺少对应私钥文件。请先确认文件来源，再选择新目录生成。'
    }
    Write-Host '即将生成 RSA 3072 位发布密钥，有效期约 30 年。'
    Write-Host "保存位置：$keystore"
    Write-Host '请先在密码管理器中保存一份随机口令，再按 keytool 提示输入并确认。'
    & $KeytoolPath -genkeypair -storetype PKCS12 -keystore $keystore `
        -alias $KeyAlias -keyalg RSA -keysize 3072 -sigalg SHA256withRSA `
        -validity 10958 -dname $DistinguishedName
    if ($LASTEXITCODE -ne 0) {
        throw '密钥生成失败。请保留现场并检查错误信息，再决定如何重试。'
    }
    Write-Host '新密钥已生成。'
} else {
    Write-Host "已有私钥文件：$keystore"
    Write-Host '本次仅继续导出和核对公开证书。如需另一套新密钥，请选择另一个目录。'
}

$temporaryCertificate = Join-Path $directory ([IO.Path]::GetRandomFileName() + '.pem')
try {
    Write-Host '接下来导出公开证书，请再次按 keytool 提示输入口令。'
    & $KeytoolPath -exportcert -rfc -storetype PKCS12 -keystore $keystore `
        -alias $KeyAlias -file $temporaryCertificate
    if ($LASTEXITCODE -ne 0) {
        throw '公开证书导出失败，私钥文件已保留。请核对口令和别名后重新运行脚本。'
    }
    if (Test-Path -LiteralPath $certificate) {
        $existing = (Get-FileHash -LiteralPath $certificate -Algorithm SHA256).Hash
        $exported = (Get-FileHash -LiteralPath $temporaryCertificate -Algorithm SHA256).Hash
        if ($existing -ne $exported) {
            throw '已有公开证书与本次导出结果不同。原文件已保留，请核对目录和密钥别名。'
        }
    } else {
        Move-Item -LiteralPath $temporaryCertificate -Destination $certificate
    }

    $details = @(& $KeytoolPath '-J-Duser.language=en' '-J-Duser.country=US' `
        -printcert -file $certificate)
    if ($LASTEXITCODE -ne 0) {
        throw '无法读取公开证书。私钥和证书文件已保留，请检查错误信息。'
    }
    @(
        "Keystore: $baseName.p12"
        "Alias: $KeyAlias"
        'Store type: PKCS12'
        ''
        $details
    ) | Set-Content -LiteralPath $information -Encoding utf8
    $details | ForEach-Object { Write-Host $_ }
    Write-Host ''
    Write-Host "公开证书：$certificate"
    Write-Host "公开签名信息：$information"
    Write-Host '请核对 SHA256 证书指纹，并妥善保存私钥文件和口令。'
    Write-Host '签名迁移和发布配置留待后续步骤，此次仅准备签名材料。'
} finally {
    if (Test-Path -LiteralPath $temporaryCertificate) {
        Remove-Item -LiteralPath $temporaryCertificate
    }
}
