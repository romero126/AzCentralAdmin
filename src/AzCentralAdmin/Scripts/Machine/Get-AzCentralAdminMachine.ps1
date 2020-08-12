function Get-AzCentralAdminMachine
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
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $Name

    )

    begin
    {
        $AzAccount  = Get-AzStorageAccount -ResourceGroupName AzCentralAdmin -StorageAccountName "azcentraladminstorage"
        $AzContext  = $AzAccount.Context
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminMachine" -Context $AzContext
    }
    
    process
    {
        $Items = Get-AzTableRow -Table $AzTable.CloudTable -PartitionKey 'Machine'

        if ($Id) {
            $Items = $Items | Where-Object { $_.Id -match $Id }
        }
        
        if ($Name) {
            $Items = $Items | Where-Object { $_.Name -match $Name }
        }

        $Items

    }

    end
    {

    }
}