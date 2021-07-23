$timeout = 1800
$epoch_time = [int][double]::Parse((Get-Date (Get-Date).ToUniversalTime() -UFormat %s))
$epoch_timeout = $epoch_time + $timeout
$jti_val = New-Guid

$tid_val = "" # The tenant's unique identifier.
$app_id = "" # The application's unique identifier.
$app_secret = "" # The application's secret to sign the auth token

$BASE_URL = "https://protectapi.cylance.com"
$AUTH_URL = $BASE_URL+"/auth/v2/token"
$DETECT_URL = $BASE_URL+"/detections/v2"
$THREAT_URL = $BASE_URL+"/threats/v2"
$DEVICE_URL = $BASE_URL+"/devices/v2"
$GLOBAL_LISTS_URL = $BASE_URL+"/globallists/v2"

$claims = @{
exp= $epoch_timeout
iat= $epoch_time
iss= "http://cylance.com"
sub= $app_id
tid= $tid_val
jti= $jti_val
}
$BASE_URL = "https://protectapi.cylance.com"
$AUTH_URL = $BASE_URL+"/auth/v2/token"
$DETECT_URL = $BASE_URL+"/detections/v2/"

