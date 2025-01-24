Connect-ExchangeOnline
Clear-Host
$Rule = Read-Host -Prompt "Please provide the name of the Inbox Rule you would like to search for"
$Folder = Read-Host -Prompt "Where would you like to save the results"
Write-Host "Getting all user mailboxes. This will take a while..."
$i = 0 #variable for the progress bar
$mailboxes = Get-Mailbox -ResultSize Unlimited



foreach ($mailbox in $mailboxes)
{

Clear-Host

$i = $i+1 #increases the progress bar
$Completed = ($i / $mailboxes.count) * 100 #percentage complete calculation
Write-Progress -Activity "Checking mailboxes for rules" -Status "Progress:" -PercentComplete $Completed
Start-Sleep -Milliseconds 50


Get-InboxRule $Rule -Mailbox $mailbox -ErrorAction SilentlyContinue | fl MailboxOwnerID,Name >> $Folder\Mailbox_Rules.csv
}
Write-Progress -Completed -Activity "Search Completed"
