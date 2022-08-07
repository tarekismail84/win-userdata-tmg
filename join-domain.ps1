#region join-domain
$domainjoin = (aws ssm get-parameter --name "domainjoin-password" --region eu-west-1  --with-decryption --output text --query Parameter.Value)
$password = $domainjoin | ConvertTo-SecureString -asPlainText -Force
$username = (aws ssm get-parameter --name "domainjoin-user" --region eu-west-1  --with-decryption --output text --query Parameter.Value)
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$instanceID = invoke-restmethod -uri http://169.254.169.254/latest/meta-data/instance-id
#$instanceID = HOSTNAME
Add-Computer -domainname tokiomarine.aws -NewName $instanceID -Credential $credential -Passthru -Verbose -Force -Restart
#endregion join-domain