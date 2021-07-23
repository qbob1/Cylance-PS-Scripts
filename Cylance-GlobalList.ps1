$path = $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $path"\Cylance-Const.ps1"
. $path"\JWT.ps1"
. $path"\utils.ps1"
. $path"\Authorize.ps1"

function Post-ToGlobalList{
    param(
         [Parameter(Mandatory=$true)][string] $category,
         [Parameter(Mandatory=$true)][string] $list_type,
         [Parameter(Mandatory=$true)][string] $reason,
         [Parameter(Mandatory=$true)][string] $sha256
    )
    Write-Host "Post $sha256"
    $payload = ConvertTo-Json @{
            category = $category
            list_type = $list_type
            reason = $reason
            sha256 = $sha256
        }
    Write-Host $payload
    $res = Invoke-WebRequest $GLOBAL_LISTS_URL `
    -Headers $header -Method POST -Body $payload

    return $res
}