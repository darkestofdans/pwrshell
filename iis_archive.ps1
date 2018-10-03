#Turn off StrictMode to prevent variable problems.
Set-StrictMode -Off

#create function to zip folders
function Zip-Subfolders {

    #Define the path and that we're interested in the folders inside.  In this case IIS logs.
    $subfolders = Get-ChildItem -Path "c:\inetpub\logs\logfiles" | Where-Object { $_.PSIsContainer }
  
    #loop through subdirectories  
    ForEach ($s in $subfolders)
	{
        $path = $s
        $path
        Set-Location $path.FullName
        $fullpath = $path.FullName
        $pathName = $path.BaseName

        #Pick all .log files older than 2 days.		
        $items = Get-ChildItem -filter "*.log" | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-2))}

        $Date = (Get-Date -format "MM_dd_yyyy")
        $archivename = $path.BaseName + $Date + ".zip"
		#Outputpath puts zips into the folder that is being compressed
        $outputpath = Join-path $fullpath $archivename
        
        Compress-Archive -Path $items -DestinationPath $outputpath -CompressionLevel optimal -update
    }
}

#Test if inetpub logs exist, otherwise skip.
$IISfolder = "c:\inetpub\logs\logfiles"
If (Test-Path $IISfolder) {
	#Call function since path exists
	Zip-Subfolders
    #Delete log files older than 2 days.
	Get-ChildItem –Path "c:\inetpub\logs\logfiles" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-2))} | Remove-Item -Force
} Else { echo "Folder not here" }	

#Delete log files older than 2 days.
Get-ChildItem –Path "c:\inetpub\logs\logfiles" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-2))} | Remove-Item

#Select Windows update files older than 14 days
Get-ChildItem –Path "C:\windows\softwaredistribution\download" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-14))} | Remove-Item

#Define temp folders including User's temp folders.
$tempfolders = @("C:\Temp\*", "C:\Windows\Temp\*", "C:\Users\*\Appdata\Local\Temp\*", "C:\windows\logs\cbs\cbspersist_*")

#Delete temp folders
Remove-Item $tempfolders -force -recurse

#Empty recycling bin as admin (needs testing)
start-process -verb RunAs 'cmd' -ArgumentList "/c rd /s /q C:\`$Recycle.bin"

