$path = $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $path"\Cylance-Const.ps1"
function Get-Device{
    param(
         [Parameter(Mandatory=$true)][string] $device_id
    )
    $res = Invoke-WebRequest ($DEVICE_URL+'/'+$device_id) `
    -Headers $header -Method GET 

    return $res
}

function Get-DeviceThreat{
    param(
         [Parameter(Mandatory=$true)][string] $device_id
    )
    $res = Invoke-WebRequest ($DEVICE_URL+'/'+$device_id+'/threats') `
    -Headers $header -Method GET 

    return $res
}
function Get-Devices{
    param(
         [Parameter(Mandatory=$false)][string] $query_string
    )
    $res = Invoke-WebRequest ($DEVICE_URL+$query_string) `
    -Headers $header -Method GET 

    return $res
}