#region create-windowstask
$action3 = New-ScheduledTaskAction -Execute 'C:\Program Files\Git\bin\git.exe' -Argument "clone https://github.com/tarekismail84/wordpress.git c:\scripts"

$time3 = [DateTime]::Now.AddMinutes(5)
$hourMinute3=$time3.ToString("HH:mm")

$trigger3 = New-ScheduledTaskTrigger -Once -At $hourMinute3
Register-ScheduledTask -Action $action3 -Trigger $trigger3 -TaskPath "aws-userdata" -TaskName "git-clone3" -Description "Tgit clone" 
#endregion create-windowstask