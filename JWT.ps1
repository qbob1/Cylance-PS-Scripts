

$headers = [ordered]@{
    "alg"="HS256"    
    "typ"="JWT"
}

Add-Type -AssemblyName System.Security
Function Get-HMACSHA512 {
    
    param(
         [Parameter(Mandatory=$true)][String]$data
        ,[Parameter(Mandatory=$true)][String]$key
    )
    
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256  
    $hmacsha.key = [Text.Encoding]::UTF8.GetBytes($key)
    $bytesToSign = [Text.Encoding]::UTF8.GetBytes($data)
    $sign = $hmacsha.ComputeHash($bytesToSign)

    return $sign

}

Function Get-StringFromByte {
    
    param(
        [Parameter(Mandatory=$true)][byte[]]$byteArray
    )

    $stringBuilder = ""
    $byteArray | ForEach { $stringBuilder += $_.ToString("x2") }
    return $stringBuilder

}

Function Get-Base64UrlEncodeFromString {
    
    param(
         [Parameter(Mandatory=$true)][String]$inputString
    )

    $inputBytes = [Text.Encoding]::UTF8.GetBytes($inputString)
    
    # Special "url-safe" base64 encode.
    $base64 = [System.Convert]::ToBase64String($inputBytes,[Base64FormattingOptions]::None).Replace('+', '-').Replace('/', '_').Replace("=", "")

    return $base64

}

Function Get-Base64UrlEncodeFromByteArray {
    
    param(
         [Parameter(Mandatory=$true)][byte[]]$byteArray
    )
   
    # Special "url-safe" base64 encode.
    $base64 = [System.Convert]::ToBase64String($byteArray,[Base64FormattingOptions]::None).Replace('+', '-').Replace('/', '_').Replace("=", "")

    return $base64

}

Function Get-Base64FromString {
    
    param(
         [Parameter(Mandatory=$true)][String]$inputString
    )

    $inputBytes = [Text.Encoding]::UTF8.GetBytes($inputString)
    
    # Special "url-safe" base64 encode.
    $base64 = [System.Convert]::ToBase64String($inputBytes,[Base64FormattingOptions]::None)

    return $base64

}

Function Get-Base64FromByteArray {
    
    param(
         [Parameter(Mandatory=$true)][byte[]]$byteArray
    )
    
    $base64 = [System.Convert]::ToBase64String($byteArray,[Base64FormattingOptions]::None)

    return $base64

}

# Add missing "=" at the end and check url-safe encodings
Function Check-Base64 {

    param(
         [Parameter(Mandatory=$true)][String]$inputString
    )

    #$input
    $encoded = $inputString.Replace('-','+').Replace('_','/')
    $d = $encoded.Length % 4
    if ( $d -ne 0 ) {
        $encoded  = $encoded.TrimEnd('=')
        if ( $d % 2 -gt 0 ) {
            $encoded += '='
        } else {
            $encoded += '=='
        }
    }
    return $encoded

}

Function Create-JWT {

    param(
        [Parameter(Mandatory=$true)][hashtable]$payload
        ,[Parameter(Mandatory=$true)][string]$secret
    )
    $headersJson = $headers | ConvertTo-Json -Compress
    $payloadJson = $payload | ConvertTo-Json -Compress
    $headersEncoded = Get-Base64UrlEncodeFromString -inputString $headersJson #[System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($headersJson),[Base64FormattingOptions]::None)
    $payloadEncoded = Get-Base64UrlEncodeFromString -inputString $payloadJson #[System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($payloadJson),[Base64FormattingOptions]::None)

    $content = "$( $headersEncoded ).$( $payloadEncoded )"
    
    $signatureByte = Get-HMACSHA512 -data $content -key $secret
    $signature = Get-Base64UrlEncodeFromByteArray -byteArray $signatureByte

    $jwt =  "$( $headersEncoded ).$( $payloadEncoded ).$( $signature )"
    return $jwt

}