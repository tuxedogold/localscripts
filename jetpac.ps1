param (
    [string]$db = "blpops-portal"
)


function main() {
choco install sqlpackage

$dir = "G:\Shared drives\Devteam\ASCENT\Databases"
$latest = Get-ChildItem -Path $dir | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$bacpac = $dir+"\"+$latest.name
$dbname = $db

$sqlinstance = "localhost\SQL2017"

Write-Host "restoring $bacpac into a database called $dbname"

invoke-sqlcmd -ServerInstance $sqlinstance -Query "DROP DATABASE IF EXISTS [$dbname]" 
# -U "username" -P "password"

sqlpackage.exe /a:Import /tsn:localhost\SQL2017 /tdn:$dbname /sf:$bacpac > null
<# 
sqlpackage.exe /a:Import /tsn:                           #<ServerName>
                         /tdn:                           #<DatabaseName> 
                         /tu:                            #<UserName> 
                         /tp:                            #<Password> 
                         /sf:$bacpac                     #<ExportFileName>
#>

Invoke-Sqlcmd -ServerInstance $sqlinstance -Database $dbname -InputFile "C:\Projects\BLPOpsPlatform\blpops-portal\blpOps.Web\Data\Scripts\Reset_Production_for_Dev.sql"

Write-Host -NoNewLine "
Update your appsettings.json to use the $dbname databasename now if you haven't already.. 



"
#Then press any key to deidentify. 
#Ctrl+C to skip
#";
#$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}






#here is where I would put my helper functions...
#if I had any.


  main