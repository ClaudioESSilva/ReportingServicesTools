# Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
# Licensed under the MIT License (MIT)

function Remove-RsCatalogItem
{
    <#
    .SYNOPSIS
        This function removes an item from the Report Server Catalog.

    .DESCRIPTION
        This function removes an item from the Report Server Catalog. 

    .PARAMETER ReportServerUri
        Specify the Report Server URL to your SQL Server Reporting Services Instance.

    .PARAMETER ReportServerCredentials
        Specify the credentials to use when connecting to your SQL Server Reporting Services Instance.

    .PARAMETER Proxy
        Specify the Proxy to use when communicating with Reporting Services server. If Proxy is not specified, connection to Report Server will be created using ReportServerUri, ReportServerUsername and ReportServerPassword.
    
    .PARAMETER Path
        Specify the path of the catalog item to remove.

    .EXAMPLE
        Remove-RsCatalogItem -ReportServerUri http://localhost/ReportServer -Path /monthlyreports
   
        Description
        -----------
        Removes the monthlyreports folder, located directly at the root of the SSRS instance, and all objects below it.

    .EXAMPLE
        Get-RsCatalogItems -ReportServerUri http://localhost/ReportServer_SQL2016 -Path '/SQL Server Performance Dashboard' |
        Out-GridView -PassThru |
        Remove-RsCatalogItem -ReportServerUri http://localhost/ReportServer_SQL2016
   
        Description
        -----------
        Gets a list of items from the SQL Server Performance Dashboard folder in a GridView from an SSRS instance names SQL2016 and allows the user to select items to be removed, after clicking "OK", only the items selected will be removed.

    #>

    [cmdletbinding()]
    param(
        [string]
        $ReportServerUri = 'http://localhost/reportserver',
                
        [System.Management.Automation.PSCredential]
        $ReportServerCredentials,
        
        $Proxy,
        
        [Parameter(Mandatory=$True,ValueFromPipeline = $true,ValueFromPipelinebyPropertyname = $true)]
        [string]
        $Path
    )
process 
    {

        if(-not $Proxy)
        {
            $Proxy = New-RSWebServiceProxy -ReportServerUri $ReportServerUri -Credentials $ReportServerCredentials 
        }

        try
        {
            Write-Verbose "Deleting catalog item $Path..."
            $Proxy.DeleteItem($Path)
            Write-Verbose "Catalog item deleted successfully!"
        }
        catch
        {
            Write-Error "Exception occurred while deleting catalog item! $($_.Exception.Message)"
            break
        }
    }
}
