Write-Output "***** Wait for network connection"
do {
    $ping = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet
    Start-Sleep -Seconds 1    
} until ($ping)

$indexUrl = "https://packages.vmware.com/tools/releases/latest/windows/x64/index.html"
$package = ((Invoke-WebRequest $indexUrl -UseBasicParsing).Links | Where-Object { $_.HREF -notmatch '^\.\.|^\?.*' }).HREF
$url = "https://packages.vmware.com/tools/releases/latest/windows/x64/$package"

$exe = "C:\Windows\Temp\$package"
Write-Output "***** Downloading latest released VMWare tools: $package"
# Can't use Invoke-Webrequest here - does skip to the next provisioner (normally reboot) instead of waiting so VMW tools are never installed
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $exe)

$parameters = '/S /l C:\Windows\Temp\vmw-msi.log /v "/qn REBOOT=R ADDLOCAL=ALL"'
Write-Output "***** Installing VMWare Guest Tools"
Start-Process $exe $parameters -Wait

Write-Output "***** Deleting $exe"
Remove-Item $exe