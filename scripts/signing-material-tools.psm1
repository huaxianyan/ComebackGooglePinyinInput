function Get-PemCertificateSha256([string]$Pem) {
    $match = [regex]::Match($Pem, '(?s)-----BEGIN CERTIFICATE-----(.*?)-----END CERTIFICATE-----')
    if (-not $match.Success) {
        throw '无法读取公开证书，请确认文件由签名工具导出。'
    }
    $der = [Convert]::FromBase64String($match.Groups[1].Value)
    $hash = [Security.Cryptography.SHA256]::Create()
    try {
        return [BitConverter]::ToString($hash.ComputeHash($der)).Replace('-', '')
    } finally {
        $hash.Dispose()
    }
}

Export-ModuleMember -Function Get-PemCertificateSha256
