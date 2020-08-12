function Start-PSBuild
{
    [CmdletBinding()]
    param(
        [switch] $Clean,
        [switch] $Build,
        [switch] $Test
    )

    $BuildPath = "$PSScriptRoot\Module"

    if ($Clean)
    {
        Write-Host "PSBuild [Clean] Begin" -ForegroundColor Yellow
        Remove-Item -Path $BuildPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "PSBuild [Clean] Complete" -ForegroundColor Yellow
    }

    if ($Build)
    {
        Write-Host "PSBuild [Build] Begin" -ForegroundColor Yellow
        $Modules = Get-ChildItem $PSScriptRoot\src\ -Directory
        # Create Build Path Location
        $null = New-item $BuildPath -ItemType Directory -Force

        foreach ($Module in $Modules)
        {
            $null = New-Item $BuildPath\$($Module.Name) -ItemType Directory -Force

            $ModuleFiles = Get-ChildItem -Path "$($Module.FullName)\*" -Exclude "*.psm1" -File -Recurse
            $ModuleCompiledFile = "$BuildPath\$($Module.Name)\$($Module.Name).psm1"
            $ModuleManifestFile = "$BuildPath\$($Module.Name)\$($Module.Name).psd1"
            Set-Content -Path $ModuleCompiledFile -Value $null -Force
            
            foreach ($ModuleFile in $ModuleFiles)
            {

                switch ($ModuleFile.Extension)
                {
                    ".ps1" {
                        Get-Content -Path $ModuleFile.FullName | Add-Content -Path $ModuleCompiledFile
                    }
                    default {
                        #Write-Host "Copy item", $ModuleFile
                        Copy-Item -Path $ModuleFile.FullName -Destination $BuildPath\$($Module.Name)\$($ModuleFile.Name)
                    }
                }
            }

            # Check of Manifest exists
            if (Test-Path $ModuleManifestFile -PathType Leaf) 
            {
                Update-ModuleManifest -Path $ModuleManifestFile -FunctionsToExport ($ModuleFiles | Where-Object { $_.Extension -eq ".ps1" } ).BaseName
            }

        }

        Write-Host "PSBuild [Build] Complete" -ForegroundColor Yellow
    }

    if ($Build -and $Test)
    {

    }
}

