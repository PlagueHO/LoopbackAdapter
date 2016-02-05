<#
.SYNOPSIS
   Install a new Loopback Network Adapter.
.DESCRIPTION
   Uses Chocolatey to download the DevCon (Windows Device Console) package and 
   uses it to install a new Loopback Network Adapter with the name specified.
   The Loopback Adapter will need to be configured like any other adapter (e.g. configure IP and DNS)
.PARAMETER AdapterName
   The name of the Loopback Adapter to create. Defaults to 'Loopback'.
.PARAMETER Force
   Force the install of Chocolatey and the Devcon.portable pacakge if not already installed, without confirming with the user.
.EXAMPLE
    $Adapter = New-LoopbackAdapter -AdapterName 'MyNewLoopback'
   Creates a new Loopback Adapter called MyNewLoopback.
.OUTPUTS
   Returns the newly created Loopback Adapter.
.COMPONENT
   LoopbackAdapter
#>
function New-LoopbackAdapter
{
    [OutputType(Microsoft.Management.Infrastructure.CimInstance#ROOT/StandardCimv2/MSFT_NetAdapter)]
    [CmdLetBinding()]
    param
    (
        [string]
        $AdapterName = 'Loopback',
        
        [Swtich]
        $Force
    )
    $PSBoundParameters.Remove('AdapterName')

    # Check for the existing Loopback Adapter
    $Adapter = Get-NetAdapter `
        -Name $AdapterName `
        -ErrorAction SilentlyContinue
    
    # Is the loopback adapter installed?
    if ($Adapter)
    {
        Throw "A Network Adapter $AdapterName is already installed."
    }

    # Make sure DevCon is installed.
    $DevConExe = (Install-Devcon @PSBoundParamters).Name

    # Use Devcon.exe to install the Microsoft Loopback adapter
    # Requires local Admin privs.
    & $DevConExe @('install',"$($ENV:SystemRoot)\inf\netloop.inf",'*MSLOOP')

    # Rename the new Loopback adapter - there could be multiple
    $Adapter = Get-NetAdapter | Where-Object -Property InterfaceDescription -eq 'Microsoft KM-TEST Loopback Adapter'
    if (! $Adapter)
    {
        Throw "The new Loopback Adapter was not found."
    } 
    $Adapter | Rename-NetAdapter -NewName $AdapterName

    Set-NetAdapter `
        -Name $AdapterName `
        -
    # Set the metric to 254
    Set-NetIPInterface `
        -InterfaceAlias $AdapterName`
        -InterfaceMetric 254
    
    # Pull the newly named adapter (to be safe)
    $Adapter = Get-NetAdapter `
        -Name $AdapterName

    Return $Adapter
}


<#
.SYNOPSIS
   Uninstall an existing Loopback Network Adapter.
.DESCRIPTION
   Uses Chocolatey to download the DevCon (Windows Device Console) package and 
   uses it to uninstall a new Loopback Network Adapter with the name specified.
.PARAMETER AdapterName
   The name of the Loopback Adapter to create. Defaults to 'Loopback'.
.PARAMETER Force
   Force the install of Chocolatey and the Devcon.portable pacakge if not already installed, without confirming with the user.
.EXAMPLE
    Remove-LoopbackAdapter -AdapterName 'MyNewLoopback'
   Removes an existing Loopback Adapter called MyNewLoopback.
.OUTPUTS
   None
.COMPONENT
   LoopbackAdapter
#>
function Remove-LoopbackAdapter
{
    [CmdLetBinding()]
    param
    (
        [string]
        $AdapterName = 'Loopback',
        
        [Swtich]
        $Force          
    )
    $PSBoundParameters.Remove('AdapterName')

    # Check for the existing Loopback Adapter
    $Adapter = Get-NetAdapter `
        -Name $AdapterName `
        -ErrorAction SilentlyContinue
    
    # Is the loopback adapter installed?
    if (! $Adapter)
    {
        # Adapter doesn't exist
        return
    }

    # Is the adapter Loopback adapter?
    if ($Adapter.DriverDescription -ne 'Microsoft KM-TEST Loopback Adapter')
    {
        # Not a loopback adapter - don't uninstall this!
        Throw "Network Adapter $AdapterName is not a Microsoft KM-TEST Loopback Adapter."
    }

    # Make sure DevCon is installed.
    $DevConExe = (Install-Devcon @PSBoundParamters).Name

    # Use Devcon.exe to remove the Microsoft Loopback adapter using the PnPDeviceID.
    # Requires local Admin privs.
    & $DevConExe @('remove',"@$($Adapter.PnPDeviceID)")
}


# Support functions - not exposed

<#
.SYNOPSIS
   Install the DevCon.Portable (Windows Device Console) pacakge using Chocolatey.
.DESCRIPTION
   Installs Chocolatey from the internet if it is not installed, then uses
   it to download the DevCon.Portable (Windows Device Console) package.
   The devcon.portable Chocolatey package can be found here and installed manually
   if no internet connection is available:
   https://chocolatey.org/packages/devcon.portable/
   
   Chocolatey will remain installed after this function is called.   
.PARAMETER Force
   Force the install of Chocolatey and the Devcon.portable pacakge if not already installed, without confirming with the user.
.EXAMPLE
    Install-Devcon
.OUTPUTS
   The fileinfo object containing the appropriate DevCon*.exe application that was installed for this architecture.
.COMPONENT
   LoopbackAdapter
#>
function Install-Devcon
{
    [OutputType([System.IO.FileInfo])]
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param
    (
        [Switch]
        $Force
    )
    # Check chocolatey is installed - if not install it
    $ChocolateyInstalled = Test-Path -Path (Join-Path -Path $ENV:ProgramData -ChildPath 'Chocolatey\Choco.exe')
    if (! $ChocolateyInstalled)
    {
        If ($Force -or $PSCmdlet.ShouldProcess('Download and install Chocolatey'))
        {
            Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))    
        }
        else
        {
            Throw 'DevCon (Windows Device Console) could not be installed because user declined Chocolatey installation.'
        }
    }    
    try
    {
        # This will download and install DevCon.exe
        # It will also be automatically placed into the path 
        If ($Force -or $PSCmdlet.ShouldProcess('Download and install DevCon (Windows Device Console) using Chocolatey'))
        {
            & choco install -r -y devcon.portable
        }
        else
        {
            Throw 'DevCon (Windows Device Console) was not installed because user declined.'
        }
    }
    catch
    {
        Throw 'An error occured installing DevCon (Windows Device Console) using Chocolatey.'
    }
    if ($ENV:PROCESSOR_ARCHITECTURE -like '*64')
    {
        Get-ChildItem "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"    
    }
    else
    {
        Get-ChildItem "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe"    
    }
}


<#
.SYNOPSIS
   Install the DevCon.Portable (Windows Device Console) pacakge using Chocolatey.
.DESCRIPTION
   Installs Chocolatey from the internet if it is not installed, then uses
   it to uninstall the DevCon.Portable (Windows Device Console) package.
   
   Chocolatey will remain installed after this function is called.
.PARAMETER Force
   Force the uninstall of the devcon.portable pacakge if it is installed, without confirming with the user.
.EXAMPLE
    Uninstall-Devcon
.OUTPUTS
   None.
.COMPONENT
   LoopbackAdapter
#>
function Uninstall-Devcon
{
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param
    (
        [Switch]
        $Force
    )
    # Check chocolatey is installed - if not install it
    $ChocolateyInstalled = Test-Path -Path (Join-Path -Path $ENV:ProgramData -ChildPath 'Chocolatey\Choco.exe')
    if (! $ChocolateyInstalled)
    {
        if ($Force -or $PSCmdlet.ShouldProcess('Download and install Chocolatey'))
        {
            Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))    
        }
        else
        {
            Throw 'DevCon (Windows Device Console) could not be uninstalled because user declined Chocolatey installation.'
        }
    }    
    try
    {
        # This will download and install DevCon.exe
        # It will also be automatically placed into the path 
        if ($Force -or $PSCmdlet.ShouldProcess('Uninstall DevCon (Windows Device Console) using Chocolatey'))
        {
            & choco uninstall -r -y devcon.portable
        }
        else
        {
            Throw 'DevCon (Windows Device Console) was not uninstalled because user declined.'    
        }
    }
    catch
    {
        Throw 'An error occured uninstalling DevCon (Windows Device Console) using Chocolatey.'
    }
}