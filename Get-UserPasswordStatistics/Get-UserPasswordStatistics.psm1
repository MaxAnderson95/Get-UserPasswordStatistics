Function Get-UserPasswordStatistics {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [String]$Identity

    )

    Begin {

    }

    Process {

        $User = Get-ADUser -Identity $User

        Write-Output $User

    }

    End {

    }

}