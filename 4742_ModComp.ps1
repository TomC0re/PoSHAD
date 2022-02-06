$Theme = "Учетная запись компьютера изменена"
$Subject = "Изменение компьютера"

$Server = "smtp.domain.com"
$From = "username1@domain.ru"
$To = "username2@domain.ru"
$pass = ConvertTo-SecureString "smtp_pass_username1" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("username1@domain.ru", $pass)
$encoding = [System.Text.Encoding]::UTF8
$SMTPPort = <port>

$Info = Get-WinEvent -FilterHashtable @{LogName="Security";ID=4742} | Select TimeCreated,`
    @{n="Computer";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "TargetUserName"}| %{$_.'#text'}}},`
    @{n="Initiator";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "SubjectUserName"}| %{$_.'#text'}}},`
    @{n="SamAccountName";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "SamAccountName"}| %{$_.'#text'}}},`
    @{n="DisplayName";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "DisplayName"}| %{$_.'#text'}}},`
    @{n="UserPrincipalName";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "UserPrincipalName"}| %{$_.'#text'}}},`
    @{n="HomeDirectory";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "HomeDirectory"}| %{$_.'#text'}}},`
    @{n="HomePath";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "HomePath"}| %{$_.'#text'}}},`
    @{n="ScriptPath";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "ScriptPath"}| %{$_.'#text'}}},`
    @{n="ProfilePath";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "ProfilePath"}| %{$_.'#text'}}},`
    @{n="UserWorkstations";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "UserWorkstations"}| %{$_.'#text'}}},`
    @{n="PasswordLastSet";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "PasswordLastSet"}| %{$_.'#text'}}},`
    @{n="AccountExpires";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "AccountExpires"}| %{$_.'#text'}}},`
    @{n="PrimaryGroupId";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "PrimaryGroupId"}| %{$_.'#text'}}},`
    @{n="AllowedToDelegateTo";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "AllowedToDelegateTo"}| %{$_.'#text'}}},`
    @{n="OldUacValue";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "OldUacValue"}| %{$_.'#text'}}},`
    @{n="NewUacValue";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "NewUacValue"}| %{$_.'#text'}}},`
    @{n="UserAccountControl";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "UserAccountControl"}| %{$_.'#text'}}},`
    @{n="UserParameters";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "UserParameters"}| %{$_.'#text'}}},`
    @{n="SidHistory";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "SidHistory"}| %{$_.'#text'}}},`
    @{n="LogonHours";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "LogonHours"}| %{$_.'#text'}}},`
    @{n="DnsHostName";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "DnsHostName"}| %{$_.'#text'}}},`
    @{n="ServicePrincipalNames";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "ServicePrincipalNames"}| %{$_.'#text'}}} | select-object -first 1

$Body = "`nВремя: "+$Info.TimeCreated +"`nИмя компьютера: "+ $Info.Computer +"`nИнициатор: "+ $Info.Initiator`
     +"`n`nИЗМЕНЕННЫЕ АТРИБУТЫ:"`
     +"`n`tИмя учетной записи SAM: "+ $Info.SamAccountName`
     +"`n`tОтображаемое имя: "+ $Info.DisplayName`
     +"`n`tОсновное имя пользователя: "+ $Info.UserPrincipalName`
     +"`n`tДомашний каталог: "+ $Info.HomeDirectory`
     +"`n`tДомашний диск: "+ $Info.HomePath`
     +"`n`tПуть к сценарию: "+ $Info.ScriptPath`
     +"`n`tПуть к профилю: "+ $Info.ProfilePath`
     +"`n`tРабочие станции пользователя: "+ $Info.UserWorkstations`
     +"`n`tПоследний пароль задан: " + $Info.PasswordLastSet`
     +"`n`tСрок действия учетной записи истекает: " + $Info.AccountExpires`
     +"`n`tИдентификатор основной группы: " + $Info.PrimaryGroupId`
     +"`n`tРазрешено делегировать: " + $Info.AllowedToDelegateTo`
     +"`n`tСтарое значение UAC: " + $Info.OldUacValue`
     +"`n`tНовое значение UAC: " + $Info.NewUacValue`
     +"`n`tУправление учетной записью пользователя: " + $Info.UserAccountControl`
     +"`n`tПараметры пользователя: " + $Info.UserParameters`
     +"`n`tЖурнал SID: " + $Info.SidHistory`
     +"`n`tЧасы входа: " + $Info.LogonHours`
     +"`n`tОтображаемое имя: " + $Info.DisplayName`
     +"`n`tDNS имя: " + $Info.DnsHostName`
     +"`n`tОсновное имя сервиса: " + $Info.ServicePrincipalNames

Send-MailMessage -From $From -To $To -SmtpServer  $server -Port $SMTPPort -Usessl -Body "$Theme `n$Body" -Subject $Subject -Credential $cred -Encoding $encoding