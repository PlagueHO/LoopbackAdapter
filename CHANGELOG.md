# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## Changed

- Added pipeline support to `Remove-LoopbackAdapter`.

### Fixes

- Fixed GitVersion to prevent build failures.
- Convert build pipeline to use GitTools Azure DevOps extension tasks
  instead of deprecated GitVersion extension.
- Fix build problems preventing help from being compiled and added
  to the module.
- Fix the XML help file output path.
- Fix error generated from DevCon.exe still updating the registry.

## [1.3.0] - 2020-08-30

### Changed

- Change `psakefile.ps1` to detect Azure Pipelines correctly.
- Added PowerShell Gallery badge to `README.md`.
- Remove AppVeyor CI pipeline and updated to new Continuous Delivery
  pattern using Azure DevOps - fixes [Issue #16](https://github.com/PlagueHO/LoopbackAdapter/issues/16).
- Renamed `master` branch to `main`.
- Moved source files into `Private` and `Public` folders in `source`.

## [1.2.1.14] - 2019-06-09

- Using FullName to prevent issues with the path environment variable.
- Improved repository structure.
- Added unit tests and integration tests.
- Added CI process for AppVeyor and Azure Pipelines.

## [1.2.0.42] - 2017-07-16

- Cleanup README.MD markdown.
- Improved detection of OS bits.

## [1.1.0.30] - 2016-04-04

- New-LoopbackAdapter:
  - Added delay to ensure New adapter is available to CIM.
  - Exception now causes function to stop correctly.

## [1.0.0.0] - 2016-01-01

- Initial Release.
