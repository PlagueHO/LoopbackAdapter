function Get-LoopbackAdapter
{
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [CmdLetBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Name
    )

    # Check for the existing Loopback Adapter
    if ($Name)
    {
        $adapter = Get-NetAdapter `
            -Name $Name `
            -ErrorAction Stop

        if ($adapter.DriverDescription -ne 'Microsoft KM-TEST Loopback Adapter')
        {
            Throw ($LocalizedData.NetworkAdapterExistsWrongTypeError -f $Name)
        } # if

        return $adapter
    }
    else
    {
        Get-NetAdapter | Where-Object -Property DriverDescription -eq 'Microsoft KM-TEST Loopback Adapter'
    } # if
}
