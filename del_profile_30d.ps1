$subfolders = Get-ChildItem -Path "C:\Users\*\AppData\Local" | Where-Object { $_.PSIsContainer } | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30)}
$parentfolder = $subfolders.parent.parent
$parentfolder.fullname | remove-item -Recurse -confirm