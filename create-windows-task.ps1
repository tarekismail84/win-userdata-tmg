$action = New-ScheduledTaskAction -Execute 'powershell' -Argument C:\scripts\join-domain.ps1

$time = [DateTime]::Now.AddMinutes(5)
$hourMinute=$time.ToString("HH:mm")

$trigger = New-ScheduledTaskTrigger -Once -At $hourMinute
Register-ScheduledTask -Action $action -Trigger $trigger -TaskPath "aws-userdata" -TaskName "join-domain" -Description "This task to join the domain" 
