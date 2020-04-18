Add-WindowsFeature Web-Server;
Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install apache-httpd --params '"/installLocation:C:\HTTPD /port:6060"' -y
New-NetFirewallRule -DisplayName "Inbound Port 6060" -Direction inbound -LocalPort 6060 -Protocol TCP -Action allow
netsh int ipv4 set dynamicport tcp start=1025 num=64511
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters -Name "TcpTimedWaitDelay" -Value "30" -PropertyType DWORD -Force
