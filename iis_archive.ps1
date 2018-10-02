
function Zip-Subfolders
{

    $subfolders = Get-ChildItem -Path "c:\inetpub\logs\logfiles" | Where-Object { $_.PSIsContainer }
#Define the path and that we're interested in the folders inside.  In this case IIS logs.

    ForEach ($s in $subfolders) 
    {
    #loop through subdirectories

        $path = $s
        $path
        $fullpath = $path.FullName
        $pathName = $path.BaseName
 
        $items = Get-ChildItem -filter "*.log" | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-2))}
        #Pick all .log files older than 2 days.

        $Date = (Get-Date -format "MM_dd_yyyy")
        $archivename = $path.name + $Date + ".zip"
        
        Compress-Archive -Path $items -DestinationPath $archivename -CompressionLevel optimal -update
    }
}

Zip-Subfolders

Get-ChildItem –Path "c:\inetpub\logs\logfiles" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-2))} | Remove-Item
#Delete log files older than 2 days.

Get-ChildItem –Path "C:\windows\softwaredistribution\download" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-14))} | Remove-Item
#Select Windows update files older than 14 days

$tempfolders = @("C:\Temp\*", "C:\Windows\Temp\*", "C:\Users\*\Appdata\Local\Temp\*", "C:\windows\logs\cbs\cbspersist_*")
#Define temp folders including User's temp folders.

Remove-Item $tempfolders -force -recurse
#Delete temp folders

cmd /c "rd /s /q C:\`$Recycle.bin"
#Empty recycling bin