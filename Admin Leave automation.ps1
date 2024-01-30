Function Get-RandomPassword #random password generator
{
    #define parameters
    param([int]$PasswordLength = 18)
 
    #ASCII Character set for Password
    $CharacterSet = @{
            Lowercase   = (97..122) | Get-Random -Count 18 | % {[char]$_}
            Uppercase   = (65..90)  | Get-Random -Count 18 | % {[char]$_}
            Numeric     = (48..57)  | Get-Random -Count 18 | % {[char]$_}
            SpecialChar = (33..47)+(58..64)+(91..96)+(123..126) | Get-Random -Count 18 | % {[char]$_}
    }
 
    #Frame Random Password from given character set
    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    -join(Get-Random -Count $PasswordLength -InputObject $StringSet)
}

$newpass1 = get-randompassword
$newpass2 = get-randompassword
$TimeStamp = ((get-date).toshortdatestring())
$user = read-host -prompt "Please enter the staff member's name"
get-aduser -filter 'Name -like $user'
$confirmation = read-host "Is this the correct staff member? [Y/N]"

If ($confirmation -eq 'y'){
    #$user = get-aduser -filter 'Name -like $user'
    Disable-ADAccount -Identity $user
    Set-ADAccountPassword -identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newpass1 -Force)
    Start-Sleep -seconds 1
    Set-ADAccountPassword -identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newpass2 -Force)
    Set-ADUser -Identity $user -Description "DISABLED - Admin Leave, $timestamp"
    Write-Host "User's password has been reset and account disabled." -ForegroundColor Green
    Start-Sleep -seconds 3
    exit
    }
while ($confirmation -ne "y"){

        If ($confirmation -eq "n") {
        $user = read-host -prompt "Please enter the staff member's name"
        get-aduser -filter 'Name -like $user'
        $confirmation = read-host "Is this the correct user? [Y/N]"
        }

    If ($confirmation -eq "y"){
    #$user = get-aduser -filter 'Name -like $user'
    Disable-ADAccount -Identity $user
    Set-ADAccountPassword -identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newpass1 -Force)
    Start-Sleep -seconds 1
    Set-ADAccountPassword -identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newpass2 -Force)
    Set-ADUser -Identity $user -Description "DISABLED - Admin Leave, $timestamp"
    Write-Host "User's password has been reset and account disabled." -ForegroundColor Green
    Start-Sleep -seconds 3
    exit
    }

 Write-Host "Invalid input, please try again." -ForegroundColor Red
 $user = read-host -prompt "Please enter the staff member's name"
 get-aduser -filter 'Name -like $user'
 $confirmation = read-host "Is this the correct user? [Y/N]"
}