[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter/blob/dev/LICENSE)
[![Documentation](https://img.shields.io/badge/Docs-LoopbackAdapter-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter/wiki)
[![PowerShell Gallery](https://img.shields.io/badge/PowerShell%20Gallery-LoopbackAdapter-blue.svg)](https://www.powershellgallery.com/packages/LoopbackAdapter)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/loopbackadapter.svg)](https://www.powershellgallery.com/packages/LoopbackAdapter)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter)
[![Minimum Supported PowerShell Core Version](https://img.shields.io/badge/PSCore-6.0-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PS-7.0-blue.svg)](https://github.com/PlagueHO/LoopbackAdapter)

# LoopbackAdapter PowerShell Module

## Module Build Status

| Branch | Azure Pipelines                    | Automated Tests                    | Code Quality                       |
| ------ | -----------------------------------| ---------------------------------- | ---------------------------------- |
| main   | [![ap-image-main][]][ap-site-main] | [![ts-image-main][]][ts-site-main] | [![cq-image-main][]][cq-site-main] |

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

[ap-image-main]: https://dev.azure.com/dscottraynsford/GitHub/_apis/build/status/PlagueHO.LoopbackAdapter.main?branchName=main
[ap-site-main]: https://dev.azure.com/dscottraynsford/GitHub/_build?definitionId=12&_a=summary
[ts-image-main]: https://img.shields.io/azure-devops/tests/dscottraynsford/GitHub/12/main
[ts-site-main]: https://dev.azure.com/dscottraynsford/GitHub/_build/latest?definitionId=12&branchName=main
[cq-image-main]: https://app.codacy.com/project/badge/Grade/8d10f564ae98479dbb47bbb19363d4f1
[cq-site-main]: https://www.codacy.com/manual/PlagueHO/LoopbackAdapter?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=PlagueHO/LoopbackAdapter&amp;utm_campaign=Badge_Grade
