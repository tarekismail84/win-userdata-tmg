


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

$time = [DateTime]::Now.AddMinutes(5)
$hourMinute=$time.ToString("HH:mm")

https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe

.\Git-2.37.1-64-bit.exe /VERYSILENT /NORESTART /COMPONENTS=icons,icons\desktop,ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh

#region Permissions
    # $Acl = Get-ACL $FolderName
    # $AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl","ContainerInherit,Objectinherit","none","Allow")
    # $Acl.AddAccessRule($AccessRule)
    # Set-Acl $FolderName $Acl
#endregion Permissions

##Download then install# /qn "Silent install"
#c:\awstemp\msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /qn

#region ssm-agent-update
$progressPreference = 'silentlyContinue'
Invoke-WebRequest `
    https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe

Start-Process `
    -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe `
    -ArgumentList "/S"
Start-Sleep -Seconds 30
#Remove-Item -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Restart-Service AmazonSSMAgent
#endregion ssm-agent-update

#region reboot-instance
    #shutdown /r
    #Start-Sleep -Seconds 120
#endregion reboot-instance

#region add-new-user
# $windowsuser = "temp-user"
# $windowspass = "Abcd1234"
# New-LocalUser $windowsuser -Password $windowspass -FullName $windowsuser -Description $windowsuser
# Add-LocalGroupMember -Group "Administrators" -Member $windowsuser
# $Credentials = New-Object System.Management.Automation.PSCredential $windowsuser,$windowspass 
#endregion add-new-user

#Start-Process powershell -credential $Credentials {.\scriptInNewPSWindow.ps1}

#region join-domain
# $domainjoin = (aws ssm get-parameter --name "domainjoin-password" --region eu-west-1  --with-decryption --output text --query Parameter.Value)
# $password = $domainjoin | ConvertTo-SecureString -asPlainText -Force

# $username = (aws ssm get-parameter --name "domainjoin-user" --region eu-west-1  --with-decryption --output text --query Parameter.Value)
# $credential = New-Object System.Management.Automation.PSCredential($username,$password)
# $instanceID = invoke-restmethod -uri http://169.254.169.254/latest/meta-data/instance-id
# #$instanceID = HOSTNAME
# Add-Computer -domainname tokiomarine.aws -NewName $instanceID -Credential $credential -Passthru -Verbose -Force -Restart
#endregion join-domain