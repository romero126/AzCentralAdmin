function Set-AzCentralAdminIPAddress
{
    [CmdletBinding()]
    param(
        # <summary>
        # Specify VaultName
        # </summary>
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $Name,

        # <summary>
        # Specify a Interface Index
        # </summary>
        [Parameter()]
        [string] $IfIndex,

        # <summary>
        # Specify an IPAddress
        # </summary>
        [Parameter()]
        [string] $IPAddress,

        # <summary>
        # Specify a Subnet
        # </summary>
        [Parameter()]
        [string] $Subnet,

        # <summary>
        # Specify Passthru
        # </summary>
        [Parameter()]
        [switch] $Passthru

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
            $Item.Updated = [DateTime]::UtcNow.ToString()
            $null = $Item | Update-AzTableRow -Table $AzTable.CloudTable
        }

        if ($Passthru)
        {
            Get-AzCentralAdminIPAddress -Name $Name
        }
    }

    end
    {

    }
}




