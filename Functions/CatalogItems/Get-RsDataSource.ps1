# Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
# Licensed under the MIT License (MIT)

function Get-RsDataSource
{
    <#
    .SYNOPSIS
        This script retrieves information about data source on Report Server.

    .DESCRIPTION
        This script retrieves  information about data source found at the specified location on Report Server. 

    .PARAMETER ReportServerUri
        Specify the Report Server URL to your SQL Server Reporting Services Instance.

    .PARAMETER ReportServerCredentials
        Specify the credentials to use when connecting to your SQL Server Reporting Services Instance.

    .PARAMETER Proxy
        Specify the Proxy to use when communicating with Reporting Services server. If Proxy is not specified, connection to Report Server will be created using ReportServerUri, ReportServerUsername and ReportServerPassword.

    .PARAMETER DataSourcePath 
        Specify the path to the data source.

    .EXAMPLE 
        Get-RsDataSource -DataSourcePath '/path/to/my/datasource'
        Description
        -----------
        This command will establish a connection to the Report Server located at http://localhost/reportserver using current user's credentials and retrieve details of data source found at '/path/to/my/datasource'.
    
    .EXAMPLE 
        Get-RsDataSource -ReportServerUri 'http://remote-machine:8080/reportserver_sql16' -DataSourcePath '/path/to/my/datasource'
        Description
        -----------
        This command will establish a connection to the Report Server located at http://remote-machine:8080/reportserver_sql16 using current user's credentials and retrieve details of data source found at '/path/to/my/datasource'.

    .EXAMPLE 
        Get-RsDataSource -ReportServerUri 'http://remote-machine:8080/reportserver_sql16' -ReportServerCredentials 'CaptainAwesome' -DataSourcePath '/path/to/my/datasource'
        Description
        -----------
        This command will establish a connection to the Report Server located at http://remote-machine:8080/reportserver_sql16 using CaptainAwesome's credentials and retrieve details of data source found at '/path/to/my/datasource'.
    #>

    [cmdletbinding()]
    param
    (
        [string]
        $ReportServerUri = 'http://localhost/reportserver',

        [System.Management.Automation.PSCredential]
        $ReportServerCredentials,

        $Proxy,

        [Parameter(Mandatory=$True)]
        [string]
        $DataSourcePath
    )

    if (-not $Proxy) 
    {
        $Proxy = New-RSWebServiceProxy -ReportServerUri $ReportServerUri -Credentials $ReportServerCredentials
    }
    
    try
    {
        Write-Verbose "Retrieving data source contents..."
        $Proxy.GetDataSourceContents($DataSourcePath)
        Write-Verbose "Data source retrieved successfully!"
    }
    catch
    {
        Write-Error "Exception while retrieving datasource! $($_.Exception.Message)"
        break
    }
}
