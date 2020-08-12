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
        # Specify Name
        # </summary>
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string] $Name

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
            $null = $Computer | Remove-AzTableRow -Table $AzTable.CloudTable
        }

    }

    end
    {

    }
}