$Theme = "Изменено имя учетной записи"
$Subject = "Переименована учетная запись"

$Server = "smtp.domain.com"
$From = "username1@domain.ru"
$To = "username2@domain.ru"
$pass = ConvertTo-SecureString "smtp_pass_username1" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("username1@domain.ru", $pass)
$encoding = [System.Text.Encoding]::UTF8
$SMTPPort = <port>

$Info = Get-WinEvent -FilterHashtable @{LogName="Security";ID=4781} | Select TimeCreated,@{n="Initiator";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "SubjectUserName"} |%{$_.'#text'}}},@{n="OldName";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "OldTargetUserName"}| %{$_.'#text'}}},@{n="NewName";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "NewTargetUserName"}| %{$_.'#text'}}} | select-object -first 1
$Body = "`nВремя: "+$Info.TimeCreated +"`nИнициатор: "+ $Info.Initiator +"`nСтарое имя: "+ $Info.OldName +"`nНовое имя: "+ $Info.NewName

Send-MailMessage -From $From -To $To -SmtpServer  $server -Port $SMTPPort -Usessl -Body "$Theme `n$Body" -Subject $Subject -Credential $cred -Encoding $encoding