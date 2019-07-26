$filelocation = "\Documents\ip.txt"
$currenttime = Get-Date 
$ipaddr = $ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

$output = (echo $currenttime $ipaddr) | Out-File ((Get-Content Env:\OneDrive)+$filelocation)