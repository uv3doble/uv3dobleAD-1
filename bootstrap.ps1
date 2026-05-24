# bootstrap.ps1
# Configure WinRM to accept remote connections

Write-Host "Configuring WinRM..."

# Check if WinRM HTTP listener is already active
$listener = Get-ChildItem WSMan:\localhost\Listener -ErrorAction SilentlyContinue | Where-Object { $_.Keys -contains "Transport=HTTP" }

if (-not $listener) {
    Write-Host "No HTTP listener found. Enabling PS Remoting..."
    Enable-PSRemoting -Force -SkipNetworkProfileCheck
}

# Ensure WinRM service is configured to start automatically
Set-Service WinRM -StartMode Automatic -ErrorAction SilentlyContinue
$service = Get-Service WinRM
if ($service.Status -ne "Running") {
    Start-Service WinRM -ErrorAction SilentlyContinue
}

# Allow WinRM traffic in Windows Defender Firewall
New-NetFirewallRule -Name "WinRM-HTTP-In" -DisplayName "Windows Remote Management (HTTP-In)" -Description "Allow WinRM HTTP traffic" -Protocol TCP -LocalPort 5985 -Action Allow -Profile Any -ErrorAction SilentlyContinue | Out-Null

# Configure WinRM settings
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true -ErrorAction SilentlyContinue
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true -ErrorAction SilentlyContinue

Write-Host "WinRM Configuration completed successfully."

