Connect-ExchangeOnline
Clear-Host
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.Description = 'Select where you would like to save the results.'
$result = $FolderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
#$Folder = Read-Host -Prompt "Where would you like to save the results?"
Write-Host "Gathering all mailboxes. This will take a while..."
$i = 0 #variable for the progress bar
$mailboxes = Get-Mailbox -ResultSize Unlimited

foreach ($mailbox in $mailboxes) {
    Clear-Host
    $i = $i + 1 #increases the progress bar
    $Completed = ($i / $mailboxes.count) * 100 #percentage complete calculation
    Write-Progress -Activity "Checking mailboxes for rules" -Status "Progress:" -PercentComplete $Completed
    Start-Sleep -Milliseconds 50
    Get-InboxRule -Mailbox $mailbox -ErrorAction SilentlyContinue | where-object { $_.deletemessage } | fl MailboxOwnerID, Name, Description >> $FolderBrowser.SelectedPath\AutoDelete_Rules.csv
}
Write-Progress -Completed -Activity "Search Completed"