Add-WindowsFeature Web-Server;
Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
New-Item -ItemType Directory c:\inetpub\wwwroot\probe
Add-Content -Path "C:\inetpub\wwwroot\probe\Default.htm" -Value $($env:computername),PROBE
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-command " $rule = Get-NetFirewallRule -Direction Inbound -DisplayGroup \"world*\";if(($rule).action -eq \"Allow\"){Set-NetFirewallRule -Direction Inbound -Action Block -DisplayGroup \"world*\"} else {Set-NetFirewallRule -Direction Inbound -DisplayGroup \"World*\" -Action Allow}"'
$mins = 20,30,40,50,60 | Get-Random
$trigger =  New-ScheduledTaskTrigger -Daily -At ((get-date).AddMinutes($mins))
$task = Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Port80Toggler" -Description "Port80Toggler" -User "NT Authority\System"
$task.Triggers.Repetition.Duration = "P5D"
$task.Triggers.Repetition.Interval = "PT06M"
$task | Set-ScheduledTask
