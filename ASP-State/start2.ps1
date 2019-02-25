# The script sets the sa password and start the SQL Service 
# Also it attaches additional database from the disk

# start the service
Write-Verbose "Starting SQL Server"
Start-Service MSSQL`$SQLEXPRESS
Write-Verbose "Started SQL Server."

$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
    Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}
