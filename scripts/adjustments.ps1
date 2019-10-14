# Written by Stefan Zimmermann

# Configure basic telemetry settings
# https://docs.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
$settingName = "AllowTelemetry"
$settingValue = "0" # Security
New-ItemProperty -Path $registryPath -Name $settingName -Value $settingValue -PropertyType DWORD -Force | Out-Null