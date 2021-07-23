$path = $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $path"\Cylance-Const.ps1"
. $path"\JWT.ps1"

$header = @{"Content-Type"= "application/json; charset=utf-8"}
function Auth {
    $encoded = Create-JWT -payload $claims -secret $app_secret 
    $payload = @{auth_token = $encoded } | ConvertTo-Json
    $token = Invoke-WebRequest -Headers $header -Uri $AUTH_URL -Method POST -Body $payload 
    $res = @{}
    (ConvertFrom-Json $token).psobject.properties | Foreach { $res[$_.Name] = $_.Value }
    $header.Add("Authorization", "Bearer " + $res['access_token'] )
}




    
