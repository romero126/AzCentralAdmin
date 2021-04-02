function Get-AzCentralAdminIPAddress
{
    [CmdletBinding()]
    param (            
        # <summary>
        # Specify Id
        # </summary>
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Id,

        # <summary>
        # Specify Name
        # </summary>
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $Name,

        [Parameter()]
        [int] $IfIndex
    )

    begin
    {
        $AzAccount  = Get-AzStorageAccount -ResourceGroupName AzCentralAdmin -StorageAccountName "azcentraladminstorage"
        $AzContext  = $AzAccount.Context
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminIPAddress" -Context $AzContext
    }
    
    process
    {
        $Items = Get-AzTableRow -Table $AzTable.CloudTable -PartitionKey 'IPAddress'

        if ($Id) {
            $Items = $Items | Where-Object { $_.Id -match $Id }
        }
        
        if ($Name) {
            $Items = $Items | Where-Object { $_.Name -match $Name }
        }

        if ($IfIndex)
        {
            $Items = $Items | Where-Object { $_.IfIndex -match $IfIndex}
        }
        
        $Items

    }

    end
    {

    }
}