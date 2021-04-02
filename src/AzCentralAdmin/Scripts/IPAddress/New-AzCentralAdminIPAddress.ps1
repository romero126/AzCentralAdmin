function New-AzCentralAdminIPAddress
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
        $Exists = Get-AzCentralAdminIPAddress -Name $Name -IfIndex $IfIndex
        if ($Exists)
        {
            Write-Error "Name $Name already exists"
            return
        }

        $item = @{
            "Id"                      = (New-Guid).Guid.ToString().Replace("-", "")
            "Name"                    = $Name
            "Created"                 = [DateTime]::UtcNow.ToString()
            "Updated"                 = [DateTime]::UtcNow.ToString()
            "IfIndex"                 = $IfIndex
            "IPAddress"               = "{0}" -f $IPAddress
            "Subnet"                  = $Subnet
        }
        
        $Result = Add-AzTableRow        `
            -Table $AzTable.CloudTable  `
            -PartitionKey 'IPAddress'   `
            -RowKey $item.Id            `
            -Property $item

        if ($Passthru)
        {
            return $Result
        }
    }

    end
    {

    }
}