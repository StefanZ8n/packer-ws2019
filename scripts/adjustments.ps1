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