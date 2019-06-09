# culture="en-US"
ConvertFrom-StringData -StringData @'
    NetworkAdapterExistsWrongTypeError = The Network Adapter '{0}' exists but it is not a Microsoft KM-TEST Loopback Adapter.
    DownloadAndInstallChocolateyShould = Download and install Chocolatey
    ChocolateyNotInstalledError = Chocolatey could not be installed because user declined installation.
    ChocolateyInstallationError = An error occurred installing Chocolatey: {0}
    DownloadAndInstallDevConShould = Download and install DevCon (Windows Device Console) using Chocolatey
    DevConNotInstalledError = DevCon (Windows Device Console) was not installed because user declined.
    DevConInstallationError = An error occured installing DevCon (Windows Device Console) using Chocolatey: {0}
    NetworkAdapterExistsError = A Network Adapter '{0}' is already installed.
    NewNetworkAdapterNotFoundError = The new Loopback Adapter '{0}' was not found.
    NewNetworkAdapterNotFoundInCIMError = The New Loopback Adapter was not found in the CIM subsystem.
    GetIPAddressWarning = An error occurred getting the IP Address for the new Loopback Adapter: {0}
    LoopbackAdapterNotFound = Loopback Adapter '{0}' is not found.
    NetworkAdapterWrongTypeError = Network Adapter '{0}' is not a Microsoft KM-TEST Loopback Adapter.
    UninstallDevConShould = Uninstall DevCon (Windows Device Console) using Chocolatey
    DevConNotUninstalledError = DevCon (Windows Device Console) was not uninstalled because user declined.
    DevConNotUninstallationError = An error occured uninstalling DevCon (Windows Device Console) using Chocolatey: {0}
    InstallingChocolateyMessage = Installing Chocolatey.
    ChocolateyInstalledMessage = Chocolatey is already installed. Installation skipped.
    InstallDevconMessage = Installing Devcon.
    CreatingLoopbackAdapterMessage = Creating Loopback Adapter '{0}'.
    SettingNameOfNewLoopbackAdapterMessage = Setting the name of the new Loopback Adapter to '{0}'.
    SettingMetricOfNewLoopbackAdapterMessage = Setting the metric of the new Loopback Adapter '{0}' to 254.
    WaitingForIPAddressMessage = Waiting for IP address to be assigned to new Loopback Adapter '{0}'.
    RemovingLoopbackAdapterMessage = Removing Loopback Adapter '{0}'.
'@
