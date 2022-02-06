$Theme = "Включена учетная запись пользователя"
$Subject = "Включен пользователь"

$Server = "smtp.domain.com"
$From = "username1@domain.ru"
$To = "username2@domain.ru"
$pass = ConvertTo-SecureString "smtp_pass_username1" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("username1@domain.ru", $pass)
$encoding = [System.Text.Encoding]::UTF8
$SMTPPort = <port>

$Info = Get-WinEvent -FilterHashtable @{LogName="Security";ID=4722} | Select TimeCreated,@{n="User";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "TargetUserName"} | %{$_.'#text'}}},@{n="Initiator";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "SubjectUserName"}| %{$_.'#text'}}} | select-object -first 1
$Body = "`nВремя: "+$Info.TimeCreated +"`nИмя пользователя: "+ $Info.User +"`nИнициатор: "+ $Info.Initiator

Send-MailMessage -From $From -To $To -SmtpServer  $server -Port $SMTPPort -Usessl -Body "$Theme `n$Body" -Subject $Subject -Credential $cred -Encoding $encoding