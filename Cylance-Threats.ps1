$path = $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $path"\Cylance-Const.ps1"
function Get-Threat {
    param(
        [Parameter(Mandatory=$true)][string] $sha256_id
    )
    $res = Invoke-WebRequest ($THREAT_URL+'/'+$sha256_id) `
    -Headers $header -Method GET 

    return $res.Content 
}
function Get-Threats {
    param(
        [Parameter(Mandatory=$false)][string] $query_string
    )
    $res = Invoke-WebRequest ($THREAT_URL+$query_string) `
    -Headers $header -Method GET 

    return $res.Content | convertfrom-json
}
function Get-AllThreats {
    param(
        [Parameter(Mandatory=$false)][string] $query_string
    )
    $page_content = @()
    $res = Get-Threats -query_string '?page_size=100'
    $res.total_pages
    $page_content += $res.page_items
    for($page= 2; $page -le $res.total_pages; $page++){
        Write-Host "Fetching page:"$page
        $r = Get-Threats -query_string ('?page='+$page+'&page_size=100')
        $page_content += $r.page_items
    }

    return $page_content

}