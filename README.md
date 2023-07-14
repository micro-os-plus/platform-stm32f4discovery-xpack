[![GitHub package.json version](https://img.shields.io/github/package-json/v/micro-os-plus/platform-stm32f4discovery-xpack)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/blob/xpack/package.json)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/micro-os-plus/platform-stm32f4discovery-xpack)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/tags/)
[![npm (scoped)](https://img.shields.io/npm/v/@micro-os-plus/platform-stm32f4discovery.svg?color=blue)](https://www.npmjs.com/package/@micro-os-plus/platform-stm32f4discovery/)
[![license](https://img.shields.io/github/license/micro-os-plus/platform-stm32f4discovery-xpack)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/blob/xpack/LICENSE)
[![CI on Push](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/actions/workflows/ci.yml/badge.svg)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/actions/workflows/ci.yml)

# A source library xPack with the µOS++ STM32F4DISCOVERY board support files

The [STM32F4DISCOVERY](https://www.st.com/en/evaluation-tools/stm32f4discovery.html)
board is a development board from ST MIcroelectronics with
the STM32F407VG MCU.

This project provides the initialization code generated by CubeMX.

It is intended to be included in unit tests, which generally do not
need peripherals.

## Maintainer info

This page is addressed to developers who plan to include this source
library into their own projects.

For maintainer info, please see the
[README-MAINTAINER](README-MAINTAINER.md) file.

## Install

As a source library xPack, the easiest way to add it to a project is via
**xpm**, but it can also be used as any Git project, for example as a submodule.

### Prerequisites

A recent [xpm](https://xpack.github.io/xpm/),
which is a portable [Node.js](https://nodejs.org/) command line application.

It is recommended to update to the latest version with:

```sh
npm install --global xpm@latest
```

For details please follow the instructions in the
[xPack install](https://xpack.github.io/install/) page.

### xpm

Note: the package will be available from npmjs.com at a later date.

For now, it can be installed from GitHub:

```sh
cd my-project
xpm init # Unless a package.json is already present

xpm install github:micro-os-plus/platform-stm32f4discovery-xpack
```

When ready, this package will be available as
[`@micro-os-plus/platform-stm32f4discovery`](https://www.npmjs.com/package/@micro-os-plus/platform-stm32f4discovery)
from the `npmjs.com` registry:

```sh
cd my-project
xpm init # Unless a package.json is already present

xpm install @micro-os-plus/platform-stm32f4discovery@latest

ls -l xpacks/@micro-os-plus/platform-stm32f4discovery
```

### Git submodule

If, for any reason, **xpm** is not available, the next recommended
solution is to link it as a Git submodule below an `xpacks` folder.

```sh
cd my-project
git init # Unless already a Git project
mkdir -p xpacks

git submodule add https://github.com/micro-os-plus/platform-stm32f4discovery-xpack.git \
  xpacks/@micro-os-plus/platform-stm32f4discovery
```

## Branches

Apart from the unused `master` branch, there are two active branches:

- `xpack`, with the latest stable version (default)
- `xpack-develop`, with the current development version

All development is done in the `xpack-develop` branch, and contributions via
Pull Requests should be directed to this branch.

When new releases are published, the `xpack-develop` branch is merged
into `xpack`.

## Developer info

This project can be used as-is for simple tests or blinky projects.

It can also be copied into
the user project, the configuration updated, and content regenerated,
at any time.

### Status

The STM32F4DISCOVERY core support is fully functional.

### Limitations

Currently only the GPIO drivers are enabled.

### Build & integration info

To integrate this package into user projects, consider the following details:

#### Include folders

The following folders should be passed to the compiler during the build:

- `stm32cubemx/Core/Inc`
- `stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include`
- `stm32cubemx/Drivers/CMSIS/Include`
- `stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc`

The header file to be included in user project is:

```c
#include <stm32f4xx.h>
```

#### Source files

The source files to be added to the build are:

- `stm32cubemx/Core/Src`
- `stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src`

#### Preprocessor definitions

- `MICRO_OS_PLUS_INCLUDE_MICRO_OS_PLUS_DIAG_TRACE` to enable the `trace_printf()`
  calls in `Error_Handler()` and `assert_failed()`.

#### Compiler options

- `-std=c++20` or higher for C++ sources
- `-std=c11` for C sources

#### Interrupt handlers

The CubeMX configuration explicitly disabled the generation of the
interrupt handlers, such that the more elaborated handlers available
with µOS++ be used.

For a correct integration with the rest of the HAL,
the `SysTick_Handler` should also call some HAL specific functions.

TBD

#### C++ Namespaces

- none

#### C++ Classes

- none

### Examples

TBD

### Known problems

- none

### Tests

TBD

## Change log - incompatible changes

According to [semver](https://semver.org) rules:

> Major version X (X.y.z | X > 0) MUST be incremented if any
backwards incompatible changes are introduced to the public API.

The incompatible changes, in reverse chronological order,
are:

- TBD

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT/),
with all rights reserved to
[Liviu Ionescu](https://github.com/ilg-ul).

The HAL code generated by CubeMX is distributed under the BSD-3-Clause license.
