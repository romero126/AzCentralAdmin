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
        [string] $Name,

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
        # [Parameter()]
        # [string] $VMHost,

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
        # [Parameter()]
        # [string] $Domain,

        # <summary>
        # Specify a Forest
        # </summary>
        # [Parameter()]
        # [string] $Forest,

        # <summary>
        # Specify a PublicFQDN
        # </summary>
        # [Parameter()]
        # [string] $PublicFQDN,

        # <summary>
        # Specify a LoadBalancer
        # </summary>
        # [Parameter()]
        # [string] $LoadBalancer,

        # <summary>
        # Specify a PublicIP
        # </summary>
        # [Parameter()]
        # [IPAddress] $PublicIP,

        # <summary>
        # Specify a LocalIP
        # </summary>
        # [Parameter()]
        # [IPAddress] $LocalIP,

        # <summary>
        # Specify a MACAddress
        # </summary>
        # [Parameter()]
        # [string] $MACAddress,

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

        $Computers = Get-AzCentralAdminMachine -Name $Name
        if (-not $Computers)
        {
            Write-Error "Name $Name does not exist"
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
            Get-AzCentralAdminMachine -Name $Name
        }
    }

    end
    {

    }
}




