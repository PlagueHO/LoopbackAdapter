[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter/blob/dev/LICENSE)
[![Documentation - LoopbackAdapter](https://img.shields.io/badge/Documentation-LoopbackAdapter-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter/wiki)
[![PowerShell Gallery - LoopbackAdapter](https://img.shields.io/badge/PowerShell%20Gallery-LoopbackAdapter-blue.svg)](https://www.powershellgallery.com/packages/LoopbackAdapter)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter)
[![Minimum Supported PowerShell Core Version](https://img.shields.io/badge/PowerShell_Core-6.0-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/1ee50b5eb15b47c188b3bdf7a5f8ee1d)](https://www.codacy.com/app/PlagueHO/LoopbackAdapter?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=PlagueHO/CosmosDB&amp;utm_campaign=Badge_Grade)

# LoopbackAdapter PowerShell Module

## Module Build Status

| Branch | AzurePipelines CI                      | AppVeyor CI                            | Code Coverage                          |
| ------ | -------------------------------------- | -------------------------------------- | -------------------------------------- |
| dev    | [![ap-image-dev][]][ap-site-dev]       | [![av-image-dev][]][av-site-dev]       | [![cc-image-dev][]][cc-site-dev]       |
| master | [![ap-image-master][]][ap-site-master] | [![av-image-master][]][av-site-master] | [![cc-image-master][]][cc-site-master] |

## Table of Contents

- [Introduction](#introduction)
- [Description](#description)
- [Requirements](#requirements)
- [Installation](#installation)
- [Compatibility and Testing](#compatibility-and-testing)
- [Contributing](#contributing)
- [Cmdlets](#cmdlets)
- [Change Log](#change-log)
- [Links](#links)

## Introduction

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

To install the module from PowerShell Gallery, use the PowerShell Cmdlet:

```powershell
Install-Module -Name LoopbackAdapter
```

## Compatibility and Testing

This PowerShell module is automatically tested and validated to run
on the following systems:

- Windows Server (using Windows PowerShell 5.1):
  - Windows Server 2012 R2: Using [AppVeyor CI](https://ci.appveyor.com/project/PlagueHO/LoopbackAdapter).
  - Windows Server 2016: Using [AppVeyor CI](https://ci.appveyor.com/project/PlagueHO/LoopbackAdapter).
  - Windows Server 2016: Using [Azure Pipelines](https://dev.azure.com/dscottraynsford/GitHub/_build?definitionId=4).

This module should function correctly on other systems and configurations
but is not automatically tested with them in every change.

## Contributing

If you wish to contribute to this project, please read the [Contributing.md](/.github/CONTRIBUTING.md)
document first. We would be very grateful of any contributions.

## Cmdlets

A list of Cmdlets in the _LoopbackAdapter PowerShell module_ can be found by running
the following PowerShell commands:

```PowerShell
Import-Module -Name LoopbackAdapter
Get-Command -Module LoopbackAdapter
```

Help on individual Cmdlets can be found in the built-in Cmdlet help:

```PowerShell
Get-Help -Name Get-LoopbackAdapter
```

The details of the cmdlets contained in this module can also be
found in the [wiki](https://github.com/PlagueHO/LoopbackAdapter/wiki).

## Change Log

For a list of changes to versions, see the [CHANGELOG.md](CHANGELOG.md) file.

## Links

- [GitHub Repository](https://github.com/PlagueHO/LoopbackAdapter/)
- [Blog](https://dscottraynsford.wordpress.com/)

[ap-image-dev]: https://dscottraynsford.visualstudio.com/GitHub/_apis/build/status/PlagueHO.LoopbackAdapter?branchName=dev
[ap-site-dev]: https://dscottraynsford.visualstudio.com/GitHub/_build/latest?definitionId=12&branchName=dev
[av-image-dev]: https://ci.appveyor.com/api/projects/status/qb67s7iw1jp7e32t/branch/dev?svg=true
[av-site-dev]: https://ci.appveyor.com/project/PlagueHO/loopbackadapter/branch/dev
[cc-image-dev]: https://codecov.io/gh/PlagueHO/LoopbackAdapter/branch/dev/graph/badge.svg
[cc-site-dev]: https://codecov.io/gh/PlagueHO/LoopbackAdapter/branch/dev

[ap-image-master]: https://dscottraynsford.visualstudio.com/GitHub/_apis/build/status/PlagueHO.LoopbackAdapter?branchName=master
[ap-site-master]: https://dscottraynsford.visualstudio.com/GitHub/_build/latest?definitionId=12&branchName=master
[av-image-master]: https://ci.appveyor.com/api/projects/status/qb67s7iw1jp7e32t/branch/master?svg=true
[av-site-master]: https://ci.appveyor.com/project/PlagueHO/loopbackadapter/branch/master
[cc-image-master]: https://codecov.io/gh/PlagueHO/LoopbackAdapter/branch/master/graph/badge.svg
[cc-site-master]: https://codecov.io/gh/PlagueHO/LoopbackAdapter/branch/master
