<#
.SYNOPSIS
   Install a new Loopback Network Adapter.
.DESCRIPTION
   Uses Chocolatey to download the DevCon (Windows Device Console) package and 
   uses it to install a new Loopback Network Adapter with the name specified.
   The Loopback Adapter will need to be configured like any other adapter (e.g. configure IP and DNS)
.PARAMETER Name
   The name of the Loopback Adapter to create.
.PARAMETER Force
   Force the install of Chocolatey and the Devcon.portable package if not already installed, without confirming with the user.
.EXAMPLE
    $Adapter = New-LoopbackAdapter -Name 'MyNewLoopback'
   Creates a new Loopback Adapter called MyNewLoopback.
.OUTPUTS
   Returns the newly created Loopback Adapter.
.COMPONENT
   LoopbackAdapter
#>
function New-LoopbackAdapter
{
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [CmdLetBinding()]
    param
    (
        [Parameter(
            Mandatory=$true,
            Position=0)]
        [string]
        $Name,
        
        [switch]
        $Force
    )
    $null = $PSBoundParameters.Remove('Name')

    # Check for the existing Loopback Adapter
    $Adapter = Get-NetAdapter `
        -Name $Name `
        -ErrorAction SilentlyContinue

    # Is the loopback adapter installed?
    if ($Adapter)
    {
        Throw "A Network Adapter $Name is already installed."
    } # if

    # Make sure DevCon is installed.
    $DevConExe = (Install-Devcon @PSBoundParameters).Name

    # Get a list of existing Loopback adapters
    # This will be used to figure out which adapter was just added
    $ExistingAdapters = (Get-LoopbackAdapter).PnPDeviceID

    # Use Devcon.exe to install the Microsoft Loopback adapter
    # Requires local Admin privs.
    $null = & $DevConExe @('install',"$($ENV:SystemRoot)\inf\netloop.inf",'*MSLOOP')

    # Find the newly added Loopback Adapter
    $Adapter = Get-NetAdapter `
        | Where-Object {
            ($_.PnPDeviceID -notin $ExistingAdapters ) -and `
            ($_.DriverDescription -eq 'Microsoft KM-TEST Loopback Adapter')
        }
    if (-not $Adapter)
    {
        Throw "The new Loopback Adapter was not found."
    } # if

    # Rename the new Loopback adapter
    $Adapter | Rename-NetAdapter `
        -NewName $Name `
        -ErrorAction Stop

    # Set the metric to 254
    Set-NetIPInterface `
        -InterfaceAlias $Name `
        -InterfaceMetric 254 `
        -ErrorAction Stop

    # Wait till IP address binding has registered in the CIM subsystem.
    # if after 30 seconds it has not been registered then throw an exception.
    [Boolean] $AdapterBindingReady = $false
    [DateTime] $StartTime = Get-Date
    while (-not $AdapterBindingReady `
        -and (((Get-Date) - $StartTime).TotalSeconds) -lt 30)
    {
        try
        {
            $IPAddress = Get-CimInstance `
                -ClassName MSFT_NetIPAddress `
                -Namespace ROOT/StandardCimv2 `
                -Filter "((InterfaceAlias = '$Name') AND (AddressFamily = 2))" `
                -ErrorAction Stop
            if ($IPAddress)
            {
                $AdapterBindingReady = $true
            } # if
            Start-Sleep -Seconds 1
        }
        catch
        {
        }
    } # while

    if (-not $IPAddress)
    {
        Throw "The New Loopback Adapter was not found in the CIM subsystem."
    }

    # Pull the newly named adapter (to be safe)
    $Adapter = Get-NetAdapter `
        -Name $Name `
        -ErrorAction Stop

    Return $Adapter
} # function New-LoopbackAdapter


<#
.SYNOPSIS
   Returns a specified Loopback Network Adapter or all Loopback Adapters.
.DESCRIPTION
   This function will return either the Loopback Adapter specified in the $Name parameter
   or all Loopback Adapters. It will only return adapters that use the Microsoft KM-TEST Loopback Adapter
   driver.

   This function does not use Chocolatey or the DevCon (Device Console) application, so does not
   require administrator access.
.PARAMETER Name
   The name of the Loopback Adapter to return. If not specified will return all Loopback Adapters.
.EXAMPLE
    $Adapter = Get-LoopbackAdapter -Name 'MyNewLoopback'
   Returns the Loopback Adapter called MyNewLoopback. If this Loopback Adapter does not exist or does not use the
   Microsoft KM-TEST Loopback Adapter driver then an exception will be thrown.
.OUTPUTS
   Returns a specific Loopback Adapter or all Loopback adapters.
.COMPONENT
   LoopbackAdapter
#>
function Get-LoopbackAdapter
{
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [CmdLetBinding()]
    param
    (
        [Parameter(
            Position=0)]
        [string]
        $Name
    )
    # Check for the existing Loopback Adapter
    if ($Name)
    {
        $Adapter = Get-NetAdapter `
            -Name $Name `
            -ErrorAction Stop
        if ($Adapter.DriverDescription -ne 'Microsoft KM-TEST Loopback Adapter')
        {
            Throw "The Network Adapter $Name exists but it is not a Microsoft KM-TEST Loopback Adapter."
        } # if
        return $Adapter
    }
    else
    {
        Get-NetAdapter | Where-Object -Property DriverDescription -eq 'Microsoft KM-TEST Loopback Adapter'
    } # if
} # function Get-LoopbackAdapter


<#
.SYNOPSIS
   Uninstall an existing Loopback Network Adapter.
.DESCRIPTION
   Uses Chocolatey to download the DevCon (Windows Device Console) package and 
   uses it to uninstall a new Loopback Network Adapter with the name specified.
.PARAMETER Name
   The name of the Loopback Adapter to uninstall.
.PARAMETER Force
   Force the install of Chocolatey and the Devcon.portable package if not already installed, without confirming with the user.
.EXAMPLE
    Remove-LoopbackAdapter -Name 'MyNewLoopback'
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
        [Parameter(
            Mandatory=$true,
            Position=0)]
        [string]
        $Name,
        
        [switch]
        $Force
    )
    $null = $PSBoundParameters.Remove('Name')

    # Check for the existing Loopback Adapter
    $Adapter = Get-NetAdapter `
        -Name $Name `
        -ErrorAction SilentlyContinue

    # Is the loopback adapter installed?
    if (! $Adapter)
    {
        # Adapter doesn't exist
        Throw "Loopback Adapter $Name is not found."
    }

    # Is the adapter Loopback adapter?
    if ($Adapter.DriverDescription -ne 'Microsoft KM-TEST Loopback Adapter')
    {
        # Not a loopback adapter - don't uninstall this!
        Throw "Network Adapter $Name is not a Microsoft KM-TEST Loopback Adapter."
    } # if

    # Make sure DevCon is installed.
    $DevConExe = (Install-Devcon @PSBoundParameters).Name

    # Use Devcon.exe to remove the Microsoft Loopback adapter using the PnPDeviceID.
    # Requires local Admin privs.
    $null = & $DevConExe @('remove',"@$($Adapter.PnPDeviceID)")
} # function Remove-LoopbackAdapter


# Support functions - not exposed

<#
.SYNOPSIS
   Install the DevCon.Portable (Windows Device Console) package using Chocolatey.
.DESCRIPTION
   Installs Chocolatey from the internet if it is not installed, then uses
   it to download the DevCon.Portable (Windows Device Console) package.
   The devcon.portable Chocolatey package can be found here and installed manually
   if no internet connection is available:
   https://chocolatey.org/packages/devcon.portable/
   
   Chocolatey will remain installed after this function is called.   
.PARAMETER Force
   Force the install of Chocolatey and the Devcon.portable package if not already installed, without confirming with the user.
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
    Install-Chocolatey @PSBoundParameters

    # Check DevCon installed - if not, install it.
    $DevConInstalled = ((Test-Path -Path "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe") `
        -and (Test-Path -Path "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"))
    if (! $DevConInstalled)
    {
        try
        {
            # This will download and install DevCon.exe
            # It will also be automatically placed into the path 
            If ($Force -or $PSCmdlet.ShouldProcess('Download and install DevCon (Windows Device Console) using Chocolatey'))
            {
                $null = & choco install -r -y devcon.portable
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
    }
    if ([Environment]::Is64BitOperatingSystem -eq $True)
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
   Install the DevCon.Portable (Windows Device Console) package using Chocolatey.
.DESCRIPTION
   Installs Chocolatey from the internet if it is not installed, then uses
   it to uninstall the DevCon.Portable (Windows Device Console) package.
   
   Chocolatey will remain installed after this function is called.
.PARAMETER Force
   Force the uninstall of the devcon.portable package if it is installed, without confirming with the user.
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
    Install-Chocolatey @PSBoundParameters
    
    try
    {
        # This will download and install DevCon.exe
        # It will also be automatically placed into the path 
        if ($Force -or $PSCmdlet.ShouldProcess('Uninstall DevCon (Windows Device Console) using Chocolatey'))
        {
            $null = & choco uninstall -r -y devcon.portable
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


<#
.SYNOPSIS
   Install Chocolatey.
.DESCRIPTION
   Installs Chocolatey from the internet if it is not installed.d.   
.PARAMETER Force
   Force the install of Chocolatey, without confirming with the user.
.EXAMPLE
    Install-Chocolatey
.OUTPUTS
   None
.COMPONENT
   LoopbackAdapter
#>
function Install-Chocolatey
{
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param
    (
        [Switch]
        $Force
    )
    # Check chocolatey is installed - if not, install it
    $ChocolateyInstalled = Test-Path -Path (Join-Path -Path $ENV:ProgramData -ChildPath 'Chocolatey\Choco.exe')
    if (! $ChocolateyInstalled)
    {
        If ($Force -or $PSCmdlet.ShouldProcess('Download and install Chocolatey'))
        {
            $null = Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))    
        }
        else
        {
            Throw 'Chocolatey could not be installed because user declined installation.'
        }
    }
}
