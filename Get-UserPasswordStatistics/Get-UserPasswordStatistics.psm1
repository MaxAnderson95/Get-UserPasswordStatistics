Function Get-UserPasswordStatistics {
    
    <#

        .SYNOPSIS
            This function returns password statistics for a given user

        .DESCRIPTION
            This function returns password statistics, such as if the password is expired, when it was last set
            as well as other properties, and returns them for a given user. This function accepts a single user
            name or object using the -Identity parameter, or multiple user names or objects via the pipeline.

        .PARAMETER Identity
            A string parameter that accepts a single user name or ADUser object. It also accepts pipeline input.

        .EXAMPLE
            PS C:\> Get-UserPasswordStatistics -Identity max
            Name                      : Max Anderson
            SAMAccountName            : max
            Enabled                   : True
            PasswordExpired           : False
            PasswordNeverExpires      : True
            PasswordAge               : 272
            PasswordLastSet           : 8/22/2017 9:38:40 PM
            PasswordChangeOnNextLogon : False

        .EXAMPLE
            PS C:\> Get-ADUser -Filter * | Get-UserPasswordStatistics
            Name                      : Max Anderson
            SAMAccountName            : Max
            Enabled                   : True
            PasswordExpired           : False
            PasswordNeverExpires      : True
            PasswordAge               : 0 days
            PasswordLastSet           : 5/22/2018 5:23:28 PM
            PasswordChangeOnNextLogon : False

            Name                      : Administrator
            SAMAccountName            : Administrator
            Enabled                   : True
            PasswordExpired           : True
            PasswordNeverExpires      : False
            PasswordAge               : 139 days
            PasswordLastSet           : 1/3/2018 5:01:40 PM
            PasswordChangeOnNextLogon : False

    #>
    
    [CmdletBinding()]
    Param (

        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [String]$Identity

    )
    
    Begin {
            
        #Explicity import module for <PS 3.0
        Import-Module ActiveDirectory -ErrorVariable Error_Import

        #Check for errors. Try Catch not used because Import-Module does not generate a terminating error.
        Switch ($Error_Import.Exception.GetType().FullName) {

            "System.IO.FileNotFoundException" {

                Write-Error "Active Directory module not found!"

            }

            Default {

                Write-Error "An unknown error occured."
                
            }

        }

        #If any errors occured, break
        If ($Error_Import -ne $Null) {

            Break

        }

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
                If ($User.PasswordLastSet -ne $Null) { 
                    Write-Output "$(((Get-Date) - $User.PasswordLastSet).Days) days"
                }
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