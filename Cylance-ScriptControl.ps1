$path = $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $path"\Neo4j.ps1"
function ParseCsv-ParseMessages{
    param(
        [string]$filepath
    )
    $data = Import-Csv $filepath
    $messages = $data | Select-Object message
    $acc = @()
    foreach ($message in $messages) {
        $obj = @{}
        $entries = $message.PSObject.Properties.Value -split ', '
        foreach ($kv in $entries) {
            $key_value = $kv -split ': '
            $obj.($key_value[0]) = $key_value[1]
        }
        Neo4j-PostJson $obj
        #$acc += $obj
    }
    #return $acc
}
ParseCsv-ParseMessages .\ScriptControl-Messages.csv 


