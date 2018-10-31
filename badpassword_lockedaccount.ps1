#Script asks for the AD username (SamAccountName)
$username = Read-host -prompt 'Input AD username please'

#Select the properties that we want to know such as the name, if it is currnetly locked, how many bad password attempts.
        #The ugly expressions convert the Int64 time to the normal DateTime format.
get-aduser $username -properties * | `
    Select-Object cn, SamAccountName, LockedOut, BadPwdCount, `
    @{name='badPasswordTimeDT'; `
        expression={[datetime]::fromFileTime($_.badPasswordTime)}}, `
    @{name='lastLogonDT'; `
        expression={[datetime]::fromFileTime($_.lastLogon)}}, `
    @{name='lastLogonTimestampDT'; `
        expression={[datetime]::fromFileTime($_.lastLogonTimestamp)}}, `
    @{name='pwdLastSetDT'; `
        expression={[datetime]::fromFileTime($_.pwdlastset)}}, `
    whenChanged

#Search log files for the lockout event for the account.
Get-WinEvent -FilterHashtable @{logname='security';id=4740;data='$username.SamAccountName'} |
Select-Object -Property timecreated,
@{label='username';expression={$_.properties[0].value}},
@{label='computername';expression={$_.properties[1].value}}

#Next will be added the log events for the bad password attempts.