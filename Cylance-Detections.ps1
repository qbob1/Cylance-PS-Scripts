$path = $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $path"\Cylance-Const.ps1"
. $path"\JWT.ps1"
. $path"\utils.ps1"
. $path"\Authorize.ps1"
function Get-Detection {
    param(
        [Parameter(Mandatory=$true)][string] $detection_id
    )
    $url = $DETECT_URL + $detection_id + "/details"
    $detail = Invoke-WebRequest $url -Headers $header -Method Get |
    ConvertFrom-Json
    return $detail
}

function Get-Detections {
    param(
        [Parameter(Mandatory=$true)][string] $query_string
    )
    $dtect_ids = Invoke-WebRequest ($DETECT_URL +`
    $query_string    ) `
    -Headers $header -Method GET |
    ConvertFrom-Json
    return $dtect_ids.page_items
}

function Update-Status {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
        [string] $detection_id,
        [Parameter(Mandatory=$true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("False Positive")]
        [string] $Status
        
    )
    $detection_id
    $Status
    $payload = ConvertTo-Json @(@{
        detection_id = $detection_id
        field_to_update = @{
            status = $Status
            }
        })
       $payload 
       $response = Invoke-WebRequest  -Headers $header -Uri $DETECT_URL"update" -Method POST -Body $payload
       return $response     
}
function Filter-Detection-Artifacts {
    params(
        [Parameter(Mandatory=$true)]$detail,
        [Parameter(Mandatory=$true)]
        [scriptblock]$filter
        )
        $acc = @()
        foreach ($artifact in $detail.AssociatedArtifacts) {
            $result = $filter.invoke($artifact)
            $acc += @{$detection.id = $result }
        }
        retrun $acc

}
