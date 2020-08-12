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
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminIPAddress" -Context $AzContext
    }
    
    process
    {
        $Items = Get-AzTableRow -Table $AzTable.CloudTable -PartitionKey 'IPAddress'

        if ($Id) {
            $Items = $Items | Where-Object { $_.Id -match $Id }
        }
        
        if ($Name) {
            $Items = $Items | Where-Object { $_.Name -match $ComputerName }
        }

        $Items

    }

    end
    {

    }
}
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
        $Exists = Get-AzCentralAdminIPAddress -ComputerName $Name
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
function Set-AzCentralAdminMachine
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
        # Specify ComputerName
        # </summary>
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $ComputerName

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
        
        if ($ComputerName) {
            $Items = $Items | Where-Object { $_.ComputerName -match $ComputerName }
        }

        $Items

    }

    end
    {

    }
}
function New-AzCentralAdminMachine
{
    [CmdletBinding()]
    param(
        # <summary>
        # Specify VaultName
        # </summary>
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $ComputerName,

        # <summary>
        # Specify a Description
        # </summary>
        [Parameter()]
        [string] $Description,

        # <summary>
        # Specify a LastOnline
        # </summary>
        [Parameter()]
        [Nullable[DateTime]] $LastOnline,

        # <summary>
        # Specify an AssetNumber
        # </summary>
        [Parameter()]
        [string] $AssetNumber,

        # <summary>
        # Specify an SerialNumber
        # </summary>
        [Parameter()]
        [string] $SerialNumber,

        # <summary>
        # Specify an DeviceSKU
        # </summary>
        [Parameter()]
        [string] $DeviceSKU,

        # <summary>
        # Specify an OSVersion
        # </summary>
        [Parameter()]
        [string] $OSVersion,

        # <summary>
        # Specify an Location
        # </summary>
        [Parameter()]
        [string] $Location,

        # <summary>
        # Specify an Building
        # </summary>
        [Parameter()]
        [string] $Building,

        # <summary>
        # Specify an Room
        # </summary>
        [Parameter()]
        [string] $Room,

        # <summary>
        # Specify an Rack
        # </summary>
        [Parameter()]
        [string] $Rack,

        # <summary>
        # Specify an Slot
        # </summary>
        [Parameter()]
        [string] $Slot,

        # <summary>
        # Specify an VMHost
        # </summary>
        [Parameter()]
        [string] $VMHost,

        # <summary>
        # Specify an BuildDefinition
        # </summary>
        [Parameter()]
        [string] $BuildDefinition,

        # <summary>
        # Specify an Location
        # </summary>
        [Parameter()]
        [string] $BuildState,

        # <summary>
        # Specify an Location
        # </summary>
        [Parameter()]
        [string] $BuildDesiredVersion,

        # <summary>
        # Specify an BuildActualVersion
        # </summary>
        [Parameter()]
        [string] $BuildActualVersion,

        # <summary>
        # Specify a Domain
        # </summary>
        [Parameter()]
        [string] $Domain,

        # <summary>
        # Specify a Forest
        # </summary>
        [Parameter()]
        [string] $Forest,

        # <summary>
        # Specify a PublicFQDN
        # </summary>
        [Parameter()]
        [string] $PublicFQDN,

        # <summary>
        # Specify a LoadBalancer
        # </summary>
        [Parameter()]
        [string] $LoadBalancer,

        # <summary>
        # Specify a PublicIP
        # </summary>
        [Parameter()]
        [IPAddress] $PublicIP,

        # <summary>
        # Specify a LocalIP
        # </summary>
        [Parameter()]
        [IPAddress] $LocalIP,

        # <summary>
        # Specify a MACAddress
        # </summary>
        [Parameter()]
        [string] $MACAddress,

        # <summary>
        # Specify a Notes
        # </summary>
        [Parameter()]
        [string] $Notes,

        # <summary>
        # Specify Exact
        # </summary>
        [Parameter()]
        [switch] $Exact,

        # <summary>
        # Specify Tags
        # </summary>
        [Parameter()]
        [String[]] $Tags,

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
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminMachine" -Context $AzContext
    }

    process
    {
        $Exists = Get-AzCentralAdminMachine -ComputerName $ComputerName
        if ($Exists)
        {
            Write-Error "ComputerName $ComputerName already exists"
            return
        }

        $item = @{
            "Id"                      = (New-Guid).Guid.ToString().Replace("-", "")
            "ComputerName"            = $ComputerName
            "Description"             = $Description
            "Created"                 = [DateTime]::UtcNow.ToString()
            "Updated"                 = [DateTime]::UtcNow.ToString()
            "LastOnline"              = "{0}" -f $LastOnline
            "AssetNumber"             = $AssetNumber
            "SerialNumber"            = $SerialNumber
            "DeviceSKU"               = $DeviceSKU
            "OSVersion"               = $OSVersion
            "Location"                = $Location
            "Building"                = $Building
            "Room"                    = $Room
            "Rack"                    = $Rack
            "Slot"                    = $Slot
            "VMHost"                  = $VMHost
            "BuildDefinition"         = $BuildDefinition
            "BuildState"              = $BuildState
            "BuildDesiredVersion"     = $BuildDesiredVersion
            "BuildActualVersion"      = $BuildActualVersion
            "Domain"                  = $Domain
            "Forest"                  = $Forest
            "PublicFQDN"              = $PublicFQDN
            "LoadBalancer"            = $LoadBalancer
            "PublicIP"                = "{0}" -f $PublicIP
            "LocalIP"                 = "{0}" -f $LocalIP
            "MACAddress"              = $MACAddress
            "Notes"                   = $Notes
        }
        
        $Result = Add-AzTableRow                      `
            -Table $AzTable.CloudTable      `
            -PartitionKey 'Machine'         `
            -RowKey $item.Id                `
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
        # Specify ComputerName
        # </summary>
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $ComputerName

    )

    begin
    {

    }

    process
    {
        $AzAccount  = Get-AzStorageAccount -ResourceGroupName AzCentralAdmin -StorageAccountName "azcentraladminstorage"
        $AzContext  = $AzAccount.Context
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminMachine" -Context $AzContext
        #Install-Module AzTable -Scope CurrentUser

        $Computers = Get-AzCentralAdminMachine -ComputerName $ComputerName
        if (-not $Computers)
        {
            Write-Error "ComputerName $ComputerName does not exist"
            return
        }

        foreach ($Computer in $Computers)
        {
            foreach ($Param in $PSBoundParameters.GetEnumerator())
            {
                $Key = $Param.Key
                $Computer.$Key = $Param.Value
            }
            $null = $Computer | Remove-AzTableRow -Table $AzTable.CloudTable
        }

    }

    end
    {

    }
}
function Set-AzCentralAdminMachine
{
    [CmdletBinding()]
    param(

        # <summary>
        # Specify Id
        # </summary>
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Id,

        # <summary>
        # Specify VaultName
        # </summary>
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $ComputerName,

        # <summary>
        # Specify a Description
        # </summary>
        [Parameter()]
        [string] $Description,

        # <summary>
        # Specify a LastOnline
        # </summary>
        [Parameter()]
        [Nullable[DateTime]] $LastOnline,

        # <summary>
        # Specify an AssetNumber
        # </summary>
        [Parameter()]
        [string] $AssetNumber,

        # <summary>
        # Specify an SerialNumber
        # </summary>
        [Parameter()]
        [string] $SerialNumber,

        # <summary>
        # Specify an DeviceSKU
        # </summary>
        [Parameter()]
        [string] $DeviceSKU,

        # <summary>
        # Specify an OSVersion
        # </summary>
        [Parameter()]
        [string] $OSVersion,

        # <summary>
        # Specify an Location
        # </summary>
        [Parameter()]
        [string] $Location,

        # <summary>
        # Specify an Building
        # </summary>
        [Parameter()]
        [string] $Building,

        # <summary>
        # Specify an Room
        # </summary>
        [Parameter()]
        [string] $Room,

        # <summary>
        # Specify an Rack
        # </summary>
        [Parameter()]
        [string] $Rack,

        # <summary>
        # Specify an Slot
        # </summary>
        [Parameter()]
        [string] $Slot,

        # <summary>
        # Specify an VMHost
        # </summary>
        [Parameter()]
        [string] $VMHost,

        # <summary>
        # Specify an BuildDefinition
        # </summary>
        [Parameter()]
        [string] $BuildDefinition,

        # <summary>
        # Specify an Location
        # </summary>
        [Parameter()]
        [string] $BuildState,

        # <summary>
        # Specify an Location
        # </summary>
        [Parameter()]
        [string] $BuildDesiredVersion,

        # <summary>
        # Specify an BuildActualVersion
        # </summary>
        [Parameter()]
        [string] $BuildActualVersion,

        # <summary>
        # Specify a Domain
        # </summary>
        [Parameter()]
        [string] $Domain,

        # <summary>
        # Specify a Forest
        # </summary>
        [Parameter()]
        [string] $Forest,

        # <summary>
        # Specify a PublicFQDN
        # </summary>
        [Parameter()]
        [string] $PublicFQDN,

        # <summary>
        # Specify a LoadBalancer
        # </summary>
        [Parameter()]
        [string] $LoadBalancer,

        # <summary>
        # Specify a PublicIP
        # </summary>
        [Parameter()]
        [IPAddress] $PublicIP,

        # <summary>
        # Specify a LocalIP
        # </summary>
        [Parameter()]
        [IPAddress] $LocalIP,

        # <summary>
        # Specify a MACAddress
        # </summary>
        [Parameter()]
        [string] $MACAddress,

        # <summary>
        # Specify a Notes
        # </summary>
        [Parameter()]
        [string] $Notes,

        # <summary>
        # Specify Exact
        # </summary>
        [Parameter()]
        [switch] $Exact,

        # <summary>
        # Specify Tags
        # </summary>
        [Parameter()]
        [String[]] $Tags,

        # <summary>
        # Specify Passthru
        # </summary>
        [Parameter()]
        [switch] $Passthru
    )

    begin
    {

    }

    process
    {
        $AzAccount  = Get-AzStorageAccount -ResourceGroupName AzCentralAdmin -StorageAccountName "azcentraladminstorage"
        $AzContext  = $AzAccount.Context
        $AzTable    = Get-AzStorageTable -Name "AzCentralAdminMachine" -Context $AzContext
        #Install-Module AzTable -Scope CurrentUser

        $Computers = Get-AzCentralAdminMachine -ComputerName $ComputerName
        if (-not $Computers)
        {
            Write-Error "ComputerName $ComputerName does not exist"
            return
        }

        foreach ($Computer in $Computers)
        {
            foreach ($Param in $PSBoundParameters.GetEnumerator())
            {
                $Key = $Param.Key
                $Computer.$Key = $Param.Value
            }
            $null = $Computer | Update-AzTableRow -Table $AzTable.CloudTable
        }

        if ($Passthru)
        {
            Get-AzCentralAdminMachine -ComputerName $ComputerName
        }
    }

    end
    {

    }
}




