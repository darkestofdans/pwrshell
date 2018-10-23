#Powershell command get reboot events from Event Log for the past two hours for 6005, 6006, 6008, 6009, 1074, 1076.
Get-EventLog system -after (get-date).AddHours(-2) | where {$_.EventID -match '[16]0[07][4-9]'} | format-list

#Powershell command to execute from cmd to get reboot events from Event Log for the past two hours for 6005, 6006, 6008, 6009, 1074, 1076
#copy everything from powershell.exe to the end.

#powershell.exe -Command "& {Get-EventLog system -after (get-date).AddHours(-2) | where {$_.EventID -match '[16]0[07][4-9]'} | format-list}"
