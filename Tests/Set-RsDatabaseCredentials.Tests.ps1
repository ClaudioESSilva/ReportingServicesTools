function Get-CredentialType() {
    $wmiObject = New-RsConfigurationSettingObject -SqlServerInstance MSSQLSERVER
    switch ($wmiObject.DatabaseLogonType) {
        0 { return 'Windows' }
        1 { return 'SQL' }
        2 { return 'ServiceAccount' }
        default { throw 'Invalid Credential Type!' }
    }
}

function Get-SaCredentials() {
    $password = ConvertTo-SecureString -AsPlainText -Force 'i<3ReportingServices'
    return New-Object System.Management.Automation.PSCredential('sa', $password)
}

Describe "Set-RsDatabaseCredentials" {
    Context "Changing database credential type to ServiceAccount credentials" {
        $credentialType = 'SQL'
        $credential = Get-SaCredentials
        Set-RsDatabaseCredentials -DatabaseCredentialType $credentialType -DatabaseCredential $credential -Verbose
        
        It "Should complete successfully" {
            Get-CredentialType | Should be $credentialType
        }
    }

    Context "Changing database credential type to SQL credentials" {
        $credentialType = 'ServiceAccount'
        Set-RsDatabaseCredentials -DatabaseCredentialType $credentialType -Verbose
        
        It "Should complete successfully" {
            Get-CredentialType | Should be $credentialType
        }
    }
}
