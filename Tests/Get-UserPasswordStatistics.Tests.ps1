Describe "Get-UserPasswordStatistics" {

    Import-Module $PSScriptRoot\..\Get-UserPasswordStatistics -Force

    It "If a user is specified, it should return an object" {

        Mock Get-ADUser { return Import-Clixml $PSScriptRoot\user.xml }

        $Output = Get-User

    }

}