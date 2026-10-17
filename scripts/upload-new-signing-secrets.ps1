#requires -Version 7.2
<#
由维护者在本机终端上传独立的新签名 Secrets。
新 keystore 仅在内存中编码后交给 gh 的标准输入，口令不写入参数、文件或剪贴板。
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SigningDirectory,
    [string]$JdkDirectory
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'signing-material-tools.psm1') -Force
$configDirectory = Join-Path $PSScriptRoot '../signing'
$config = Get-Content -LiteralPath (Join-Path $configDirectory 'signing-materials.json') -Raw |
    ConvertFrom-Json
$newSecretNames = @($config.newSecrets.keystore, $config.newSecrets.storePassword, $config.newSecrets.keyPassword)
if (@($newSecretNames | Where-Object { $_ -notmatch '^ANDROID_ROTATED_SIGNING_[A-Z0-9_]+$' }).Count -or
    @($newSecretNames | Select-Object -Unique).Count -ne 3) {
    throw '新签名 Secret 名称不符合独立命名空间要求，尚未上传。请核对 signing-materials.json。'
}
$gh = Get-Command gh -CommandType Application -ErrorAction SilentlyContinue
if (-not $gh) {
    throw '未找到 GitHub CLI。请先安装 gh 并完成登录，再运行本脚本。'
}
if (-not $JdkDirectory) {
    $JdkDirectory = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
}
if (-not $JdkDirectory) {
    throw '未配置 JAVA_HOME。请通过 -JdkDirectory 指定现有 JDK。'
}
$keytool = Join-Path $JdkDirectory 'bin/keytool.exe'
if (-not (Test-Path -LiteralPath $keytool -PathType Leaf)) {
    throw '未找到 keytool，请检查 JDK 路径。'
}
$keystore = Join-Path $SigningDirectory "$($config.fileBaseName).p12"
if (-not (Test-Path -LiteralPath $keystore -PathType Leaf)) {
    throw '未找到新 keystore，请检查签名目录。'
}
$pinnedCertificate = Join-Path $configDirectory $config.certificates.current
$expected = Get-PemCertificateSha256 (Get-Content -LiteralPath $pinnedCertificate -Raw)

function Invoke-UploadTool {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$InputValue,
        [hashtable]$Environment = @{},
        [string]$FailureAdvice
    )
    $start = [Diagnostics.ProcessStartInfo]::new()
    $start.FileName = $FilePath
    $start.UseShellExecute = $false
    $start.RedirectStandardInput = $true
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.StandardInputEncoding = [Text.UTF8Encoding]::new($false)
    foreach ($argument in $Arguments) { $start.ArgumentList.Add($argument) }
    # Keep uploads on the intended GitHub host and suppress HTTP debug dumps in this child only.
    $start.Environment['GH_HOST'] = 'github.com'
    [void]$start.Environment.Remove('GH_DEBUG')
    foreach ($name in $Environment.Keys) { $start.Environment[$name] = $Environment[$name] }
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $start
    try {
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        if ($null -ne $InputValue) {
            $write = $process.StandardInput.WriteAsync($InputValue)
            if (-not $write.Wait(60000)) {
                $process.Kill($true)
                throw "输入传输超时。$FailureAdvice"
            }
            $flush = $process.StandardInput.FlushAsync()
            if (-not $flush.Wait(60000)) {
                $process.Kill($true)
                throw "输入传输超时。$FailureAdvice"
            }
        }
        $process.StandardInput.Close()
        if (-not $process.WaitForExit(60000)) {
            $process.Kill($true)
            throw "操作超时。$FailureAdvice"
        }
        $output = $stdout.GetAwaiter().GetResult()
        [void]$stderr.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) { throw $FailureAdvice }
        return $output
    } finally {
        $process.Dispose()
    }
}

$account = Invoke-UploadTool -FilePath $gh.Source `
    -Arguments @('api', '--hostname', 'github.com', 'user', '--jq', '.login') `
    -FailureAdvice 'GitHub 登录检查失败。请先执行 gh auth login，再重试。'
Write-Host "GitHub 账号：$($account.Trim())"
Write-Host "目标仓库：$($config.repository)"
Write-Host '只上传配置中独立的新签名 Secrets，现有旧签名 Secrets 保持原样。'
$securePassword = Read-Host '请输入新 keystore 的口令' -AsSecureString
$pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
$password = $null
$encoded = $null
try {
    $password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
    $exported = Invoke-UploadTool -FilePath $keytool `
        -Arguments @('-exportcert', '-rfc', '-storetype', 'PKCS12', '-keystore', $keystore,
            '-alias', $config.keyAlias, '-storepass:env', 'SIGNING_UPLOAD_STORE_PASSWORD') `
        -Environment @{ SIGNING_UPLOAD_STORE_PASSWORD = $password } `
        -FailureAdvice '新 keystore 校验失败，尚未上传。请核对口令、别名和目录后重试。'
    if ((Get-PemCertificateSha256 $exported) -ne $expected) {
        throw '新 keystore 与仓库中已核对的公开证书不一致，尚未上传。请检查所选文件。'
    }
    Write-Host "新证书 SHA-256 已核对：$expected"
    $encoded = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystore))
    $uploads = @(
        @{ Name = $config.newSecrets.keystore; Value = $encoded }
        @{ Name = $config.newSecrets.storePassword; Value = $password }
        @{ Name = $config.newSecrets.keyPassword; Value = $password }
    )
    foreach ($upload in $uploads) {
        [void](Invoke-UploadTool -FilePath $gh.Source `
            -Arguments @('secret', 'set', $upload.Name, '--repo', $config.repository, '--app', 'actions') `
            -InputValue $upload.Value `
            -FailureAdvice "上传 $($upload.Name) 失败。请检查登录、仓库权限或网络后重试。已上传的新 Secrets 可重复设置。")
        Write-Host "已上传：$($upload.Name)"
    }
    Write-Host '三项新签名 Secrets 上传完成，可以手动运行生成 lineage 的工作流。'
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    $password = $null
    $encoded = $null
    $uploads = $null
    $securePassword.Dispose()
}
