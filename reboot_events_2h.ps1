#Get-EventLog for the last 2 hours for EventIDs associated with reboots - 6005, 6006, 6008, 6009, 1074
Get-EventLog system -after (get-date).Addhours(-2) | where {$_.eventID -match '[16]0[07][4-9]'} | format-list