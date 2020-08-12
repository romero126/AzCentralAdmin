function Remove-AzCentralAdminMachine
{
    [CmdletBinding()]
    param(

        # <summary>
        # Specify Id
        # </summary>
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Id,

        # <summary>
        # Specify a Name
        # </summary>
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $Name
    )

    begin
    {
        $AzAccount  = Get-AzStorageAccount -ResourceGroupName AzCentralAdmin -StorageAccountName "azcentraladminstorage"
        $AzContext  = $AzAccount.Context
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminIPAddress" -Context $AzContext

    }

    process
    {

        $Items = Get-AzCentralAdminIPAddress -Name $Name
        if (-not $Items)
        {
            Write-Error "Name $Name does not exist"
            return
        }

        foreach ($Item in $Items)
        {
            foreach ($Param in $PSBoundParameters.GetEnumerator())
            {
                $Key = $Param.Key
                $Item.$Key = $Param.Value
            }
            $null = $Item | Remove-AzTableRow -Table $AzTable.CloudTable
        }

    }

    end
    {

    }
}