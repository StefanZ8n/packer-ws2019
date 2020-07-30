# Written by Stefan Zimmermann

# Configure basic telemetry settings
# https://docs.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
$settingName = "AllowTelemetry"
$settingValue = "0" # Security
New-ItemProperty -Path $registryPath -Name $settingName -Value $settingValue -PropertyType DWORD -Force | Out-Null

# Show file extentions by default in Windows Explorer
# https://social.technet.microsoft.com/Forums/en-US/78efe17d-1faa-4da1-a0e2-3387493a1e97/powershell-loading-unloading-and-reading-hku?forum=ITCG
$registryPath = "HKU:\UserHive\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$null = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
$null = reg load HKU\UserHive C:\Users\Default\NTUSER.DAT
$settingName = "HideFileExt"
$settingValue = "0"
New-ItemProperty -Path $registryPath -Name $settingName -Value $settingValue -PropertyType DWORD -Force

[gc]::Collect() # Required that unloading is possible
$null = reg unload HKU\UserHive
$null = Remove-PSDrive -Name HKU

# Install Microsoft Edge Chromium 
# Inspriation from https://github.com/haavarstein/Applications/blob/master/Microsoft/Edge%20Enterprise
# Great Evergreen module: https://github.com/aaronparker/Evergreen
Install-Module Evergreen -Force | Import-Module Evergreen

$EvergreenEdge = Get-MicrosoftEdge | Where-Object { $_.Architecture -eq "x64" -and $_.Channel -eq "Stable" -and $_.Platform -eq "Windows" }
$EvergreenEdge = $EvergreenEdge | Sort-Object -Property Version -Descending | Select-Object -First 1
$msiPath = "${env:SystemRoot}\Temp\edgechromium.msi"
if (!(Test-Path -Path $msiPath)) {
    Invoke-WebRequest -UseBasicParsing -Uri $EvergreenEdge.uri -OutFile $msiPath
}
$UnattendedArgs = "/i ${msiPath} ALLUSERS=1 /qn /liewa ${env:SystemRoot}\Temp\edgeinstall.log"
Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -PassThru
Copy-Item -Path "A:\edge_chromium_preferences.json" "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\master_preferences" -Recurse -Force