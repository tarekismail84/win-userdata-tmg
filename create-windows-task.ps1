#region create-domain-join-task
$action = New-ScheduledTaskAction -Execute 'powershell' -Argument C:\awstemp\join-domain.ps1

$time = [DateTime]::Now.AddMinutes(5)
$hourMinute=$time.ToString("HH:mm")

$trigger = New-ScheduledTaskTrigger -Once -At $hourMinute
Register-ScheduledTask -Action $action -Trigger $trigger -TaskPath "aws-userdata" -TaskName "join-domain" -Description "This task to join the domain" 
#endregion create-domain-join-task

$action1 = New-ScheduledTaskAction -Execute 'powershell' -Argument "git clone https://github.com/tarekismail84/wordpress.git"
$time1 = [DateTime]::Now.AddMinutes(5)
$hourMinute1=$time1.ToString("HH:mm")
$trigger1 = New-ScheduledTaskTrigger -Once -At $hourMinute1
Register-ScheduledTask -Action $action1 -Trigger $trigger1 -TaskPath "aws-userdata" -TaskName "git-clone" -Description "This task to clone repo" 