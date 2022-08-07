

<powershell>
#region folder-create
$FolderName = "c:\awstemp"
if([System.IO.Directory]::Exists($FolderName))
{
    Write-Host "Folder Exists"
    Get-ChildItem -Path $FolderName | Where-Object {$_.CreationTime -gt (Get-Date).Date}   
}
else
{
    Write-Host "Folder Doesn't Exists"
    
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
}
#endregion folder-create

#region download-files
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$progressPreference = 'silentlyContinue'

$URL = “https://awscli.amazonaws.com/AWSCLIV2.msi”
Invoke-WebRequest -URI $URL -OutFile "$FolderName\AWSCLIV2.msi"

$URL2 =  "https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe"
Invoke-WebRequest -URI $URL2 -OutFile "$FolderName\Git-2.37.1-64-bit.exe"

Invoke-WebRequest `
    https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile "$FolderName\SSMAgent_latest.exe"
#endregion download-files

#region install-packages
Set-Location $FolderName
    Get-ChildItem
msiexec.exe /i "$FolderName\AWSCLIV2.msi" /qn
Start-Sleep -Seconds 30
.\Git-2.37.1-64-bit.exe /VERYSILENT /NORESTART /COMPONENTS=icons,icons\desktop,ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh
Start-Sleep -Seconds 30
Start-Process `
    -FilePath "$FolderName\SSMAgent_latest.exe"
    -ArgumentList "/S"
Start-Sleep -Seconds 30
Restart-Service AmazonSSMAgent
#endregion install-packages

#region add-ldap-dns-to-hosts-file
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n172.31.121.83`ttokiomarine.aws" -Force
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n172.31.120.105`ttokiomarine.aws" -Force
# #endregion add-ldap-dns-to-hosts-file

# #region assign-dns
Get-NetAdapter -Name '*' |  Set-DnsClientServerAddress  -ServerAddresses ('172.31.121.83','172.31.120.105','172.31.0.2')
ipconfig /flushdns
#endregion assign-dns

#region create-windowstask
$action1 = New-ScheduledTaskAction -Execute 'C:\Program Files\Git\bin\git.exe' -Argument "clone https://github.com/tarekismail84/wordpress.git c:\scripts"
$time1 = [DateTime]::Now.AddMinutes(3)
$hourMinute1=$time1.ToString("HH:mm")
$trigger1 = New-ScheduledTaskTrigger -Once -At $hourMinute1
Register-ScheduledTask -Action $action1 -Trigger $trigger1 -TaskPath "aws-userdata" -TaskName "git-clone1" -Description "git clone" 

$action = New-ScheduledTaskAction -Execute 'powershell' -Argument C:\scripts\join-domain.ps1
$time = [DateTime]::Now.AddMinutes(5)
$hourMinute=$time.ToString("HH:mm")
$trigger = New-ScheduledTaskTrigger -Once -At $hourMinute
Register-ScheduledTask -Action $action -Trigger $trigger -TaskPath "aws-userdata" -TaskName "join-domain" -Description "This task to join the domain" 
#endregion create-windowstask

</powershell>