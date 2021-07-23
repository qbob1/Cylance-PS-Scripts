function Detection-ArtifactFilter-DecodeBase64Commands{
    param(
        [Parameter(Mandatory=$true)]$artifact
        )
        if($null -ne $artifact.CommandLine){
            $b64 =[regex]::Matches($artifact.CommandLine, '(?<=-[Ee]ncodedCommand )\w{1,}').value
            $details += @{ $det.Id = $artifact.CommandLine }
            if($null -ne $b64 ) {
                return @{ $det.Id = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($b64)) }
            }
        }
        }
function Detection-ArtifactFilter-ExtractURL{
        param(
        [Parameter(Mandatory=$true)]$artifact
        )
        if($null -ne $artifact.CommandLine){
            $url = [regex]::match($artifact.CommandLine, $url_regex).Groups
            if ($url.length -gt 0 ) {
                return @{$det.Id = $url[0] }
            }
    
}

