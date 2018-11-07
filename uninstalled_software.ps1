#Searches Event Log for software that Windows Installer removed
Get-EventLog -LogName Application -Source MSiInstaller | Where-Object {$_.EventID -eq '1034'} | format-list