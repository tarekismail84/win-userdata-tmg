


#$action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument C:\scripts\myscript.bat
$action = New-ScheduledTaskAction -Execute 'notepad.exe'
#In the command, make sure to replace 'PROGRAM' with the name of the program you want to start. 
#The "$action" is a variable, and it does not matter the name as long as you keep it short, simple, and descriptive.For example, 
#this command tells Task Scheduler to start the Notepad app:$action = New-ScheduledTaskAction -Execute 'notepad.exe'
#Quick tip: If you are trying to schedule a Command Prompt or PowerShell script, you will use the name of the program for the "-Execute" option and "-Argument" option to specify the path of the script

$trigger = New-ScheduledTaskTrigger -Daily -At 11am
# For "SETTING," you can use -Once, -Daily, -Weekly, or -Monthly. And for the time, 
# you can use the 12 or 24-hour format. If you are using the "Weekly" option, then you also provide the "-DaysInterval" or "-DaysOfWeek" 
# information followed by the corresponding information. For example, with "-DaysOfWeek," you can use Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday 
# (example: -DaysOfWeek Monday to run the task every Monday), 
# and "-DaysInterval," you will provide the interval as number (example: -DaysInterval 2 to run the task every two days).


Register-ScheduledTask -Action $action -Trigger $trigger -TaskPath "MyTasks" -TaskName "testTask" -Description "This task opens the Notepad editor"
