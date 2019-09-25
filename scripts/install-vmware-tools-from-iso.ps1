$exe = "D:\setup64.exe"
Write-Output "***** Wait for VMware Tools ISO to be mounted and available"
do {
    $exeAvailable = Test-Path $exe
    Start-Sleep -Seconds 5    
} until ($exeAvailable)

$parameters = '/S /l C:\Windows\Temp\vmw-tools.log /v "/qn REBOOT=R ADDLOCAL=ALL"'
Write-Output "***** Installing VMWare Guest Tools"
Start-Process $exe $parameters -Wait
