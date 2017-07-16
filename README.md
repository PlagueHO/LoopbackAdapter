# LoopbackAdapter

[![Build status](https://ci.appveyor.com/api/projects/status/qb67s7iw1jp7e32t/branch/master?svg=true)](https://ci.appveyor.com/project/PlagueHO/loopbackadapter/branch/master)

A PowerShell module for creating and removing Loopback Network Adapters on Windows
using Device Console (DevCon.exe).

## Description

This module is used for installing and uninstalling Microsoft Loopback Network Adapters.

It uses [Chocolatey](https://chocolatey.org/) to download an package called [devcon.portable](https://chocolatey.org/packages/devcon.portable/).
This package contains a 32-bit and 64-bit version of the Windows Device Console (devcon)
that can be used to install the Microsoft Loopback Network Adapter device. If
Chocolatey is not installed it will be downloaded from the internet and installed
automatically. The user will be asked to confirm these actions unless the -force
parameter is used.


## Requirements

Using this module requires:

1. **Local Admin** - this module should be run in an Administrative PowerShell
  session so that it can install/uninstall hardware devices.
1. **Internet Access* - this module will download Chocolatey from [https://chocolatey.org](https://chocolatey.org)
  and then use that to install the Devcon.portable package.

## Installation

| Installation if WMF5.0 is Installed:

```PowerShell
Install-Module -Name LoopbackAdapter -MinimumVersion 1.2.0.0
```

| Installation if WMF5.0 is Not Installed

Copy the included LoopbackAdapter.psd1 and LoopbackAdapter.psm1 files into a folder
called LoopbackAdapter in either one of these folders:

* ```$ENV:ProgramFiles\WindowsPowerShell\Modules```
* ```$ENV:UserProfile\Documents\WindowsPowerShell\Modules```

## Usage Example

Install two Loopback Adapters called LoopbackAdapter1 and LoopbackAdapter2:

```powershell
Import-Module -Name LoopbackAdapter
New-LoopbackAdapter -Name 'LoopbackAdapter1'
New-LoopbackAdapter -Name 'LoopbackAdapter2'
```

## Functions

### New-LoopbackAdapter

#### Synopsis

Install a new Loopback Network Adapter.

#### Description

Uses Chocolatey to download the DevCon (Windows Device Console) package and uses
it to install a new Loopback Network Adapter with the name specified.
The Loopback Adapter will need to be configured like any other adapter (e.g.
configure IP and DNS)

#### Parameter Name

The name of the Loopback Adapter to create.

#### Parameter Force

Force the install of Chocolatey and the Devcon.portable package if not already
installed, without confirming with the user.

#### Example

```powershell
$Adapter = New-LoopbackAdapter -Name 'MyNewLoopback'
```

Creates a new Loopback Adapter called MyNewLoopback.

#### Outputs

Returns the newly created Loopback Adapter.

#### Component

LoopbackAdapter

### Get-LoopbackAdapter

#### Synopsis

Returns a specified Loopback Network Adapter or all Loopback Adapters.

#### Description

This function will return either the Loopback Adapter specified in the $Name
parameter or all Loopback Adapters.
It will only return adapters that use the Microsoft KM-TEST Loopback Adapter driver.

This function does not use Chocolatey or the DevCon (Device Console) application,
so does not require administrator access.

#### Parameter Name

The name of the Loopback Adapter to return.
If not specified all Loopback Adapters will be returned.

#### Example

```powershell
$Adapter = Get-LoopbackAdapter -Name 'MyNewLoopback'
```

Returns the Loopback Adapter called MyNewLoopback. If this Loopback Adapter does
not exist or does not use the Microsoft KM-TEST Loopback Adapter driver then an
exception will be thrown.

#### Outputs

Returns a specific Loopback Adapter or all Loopback adapters.

#### Component

LoopbackAdapter

### Remove-LoopbackAdapter

#### Synopsis

Uninstall an existing Loopback Network Adapter.

#### Description

Uses Chocolatey to download the DevCon (Windows Device Console) package and
uses it to uninstall a new Loopback Network Adapter with the name specified.

#### Parameter Name

The name of the Loopback Adapter to create.

#### Parameter Force

Force the install of Chocolatey and the Devcon.portable package if not already
installed, without confirming with the user.

#### Example

```powershell
Remove-LoopbackAdapter -Name 'MyNewLoopback'
```

Removes an existing Loopback Adapter called MyNewLoopback.

#### Outputs

None

#### Component

LoopbackAdapter

## Versions

### 1.2.0.0

* Cleanup README.MD markdown.
* Improved detection of OS bits.

### 1.1.0.0

* New-LoopbackAdapter: Added delay to ensure New adapter is available to CIM.
                       Exception now causes function to stop correctly.

### 1.0.0.0

* Initial Release.

## Links

* **[GitHub Repo](https://github.com/PlagueHO/LoopbackAdapter)**: Raise any issues,
  requests or PRs here.
* **[My Blog](https://dscottraynsford.wordpress.com)**: See my PowerShell and
  Programming Blog.
