Function Get-UserPasswordStatistics {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [String]$Identity

    )

    Begin {

        #Explicity import module for <PS 3.0
        Import-Module ActiveDirectory

    }

    Process {

        $User = Get-ADUser -Identity $Identity -Properties "msDS-UserPasswordExpiryTimeComputed", "PasswordExpired", "PasswordNeverExpires", "PasswordLastSet"
        
        $Obj = [PSCustomObject] @{

            "Name" = $User.Name
            "SAMAccountName" = $User.SAMAccountName
            "Enabled" = $User.Enabled
            "PasswordExpired" = $User.PasswordExpired
            "PasswordNeverExpires" = $User.PasswordNeverExpires
            "PasswordAge" = $(
                If ($User.PasswordLastSet -ne $Null) {((Get-Date) - $User.PasswordLastSet).Days}
            )
            "PasswordLastSet" = $User.PasswordLastSet
            "PasswordChangeOnNextLogon" = $(
                If ($User.PasswordLastSet -eq $Null) {$True}
                Else {$False} 
            )

        }

        Write-Output $Obj

    }

    End {

    }

}