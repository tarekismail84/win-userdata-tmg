

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

#region Permissions
    # $Acl = Get-ACL $FolderName
    # $AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl","ContainerInherit,Objectinherit","none","Allow")
    # $Acl.AddAccessRule($AccessRule)
    # Set-Acl $FolderName $Acl
#endregion Permissions


#region download-awscli-file
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$URL = “https://awscli.amazonaws.com/AWSCLIV2.msi”
Invoke-WebRequest -URI $URL -OutFile "$FolderName\AWSCLIV2.msi"

##Download then install# /qn "Silent install"
#c:\awstemp\msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /qn
msiexec.exe /i "$FolderName\AWSCLIV2.msi" /qn
Start-Sleep -Seconds 15
#endregion download-awscli-file

#region install-git
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $URL2 =  "https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe"
    Invoke-WebRequest -URI $URL2 -OutFile "$FolderName\Git-2.37.1-64-bit.exe"
    Set-Location $FolderName
    dir
    .\Git-2.37.1-64-bit.exe /VERYSILENT /NORESTART /COMPONENTS=icons,icons\desktop,ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh
#endregion install-git

#region ssm-agent-update
$progressPreference = 'silentlyContinue'
Invoke-WebRequest `
    https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe

Start-Process `
    -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe `
    -ArgumentList "/S"
Start-Sleep -Seconds 30
Remove-Item -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe
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


#region add-ldap-dns-to-hosts-file
# Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n172.31.121.83`ttokiomarine.aws" -Force
# Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n172.31.120.105`ttokiomarine.aws" -Force
# #endregion add-ldap-dns-to-hosts-file

# #region assign-dns-and-join-domain
# Get-NetAdapter -Name '*' |  Set-DnsClientServerAddress  -ServerAddresses ('172.31.121.83','172.31.120.105','172.31.0.2')
# ipconfig /flushdns

# $domainjoin = (aws ssm get-parameter --name "domainjoin-password" --region eu-west-1  --with-decryption --output text --query Parameter.Value)
# $password = $domainjoin | ConvertTo-SecureString -asPlainText -Force

# $username = (aws ssm get-parameter --name "domainjoin-user" --region eu-west-1  --with-decryption --output text --query Parameter.Value)
# $credential = New-Object System.Management.Automation.PSCredential($username,$password)
# $instanceID = invoke-restmethod -uri http://169.254.169.254/latest/meta-data/instance-id
# #$instanceID = HOSTNAME
# Add-Computer -domainname tokiomarine.aws -NewName $instanceID -Credential $credential -Passthru -Verbose -Force -Restart
#endregion assign-dns-and-join-domain


</powershell>