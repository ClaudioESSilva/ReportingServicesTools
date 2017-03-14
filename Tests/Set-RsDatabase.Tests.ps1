function Get-DatabaseName() {
    $wmiObject = New-RsConfigurationSettingObject -SqlServerInstance MSSQLSERVER
    return $wmiObject.DatabaseName
}

Describe "Set-RsDatabase" {
    Context "Changing database to a new database" {
        $databaseServerName = 'localhost'
        $databaseName = 'ReportServer' + [System.DateTime]::Now.Ticks
        Set-RsDatabase -DatabaseServerName $databaseServerName -DatabaseName $databaseName -DatabaseCredentialType ServiceAccount -Verbose
        
        It "Should complete successfully" {
            Get-DatabaseName | Should be $databaseName
        }
    }
    
    Context "Changing database to an existing database" {
        $databaseServerName = 'localhost'
        $databaseName = 'ReportServer'
        Set-RsDatabase -DatabaseServerName $databaseServerName -DatabaseName $databaseName -DatabaseCredentialType ServiceAccount -IsExistingDatabase -Verbose
        
        It "Should complete successfully" {
            Get-DatabaseName | Should be $databaseName
        }
    }
}