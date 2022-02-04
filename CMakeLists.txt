#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus)
# Copyright (c) 2021 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# If a copy of the license was not distributed with this file, it can
# be obtained from https://opensource.org/licenses/MIT/.
#
# -----------------------------------------------------------------------------

# This file is intended to be consumed by applications with:
#
# `add_subdirectory("xpacks/micro-os-plus-platform-stm32f4discovery")`
#
# The result is a static library that can be added to the linker with:
#
# `target_link_libraries(your-target PUBLIC micro-os-plus::platform-stm32f4discovery)`

# -----------------------------------------------------------------------------
## Preamble ##

# https://cmake.org/cmake/help/v3.20/
cmake_minimum_required(VERSION 3.20)

project(
  micro-os-plus-platform-stm32f4discovery
  DESCRIPTION "µOS++ STM32F4DISCOVERY board support"
)

if(COMMAND xpack_get_package_name_and_version)
  xpack_get_package_name_and_version("${CMAKE_CURRENT_SOURCE_DIR}/package.json")
  message(VERBOSE "Processing xPack ${PACKAGE_JSON_NAME}@${PACKAGE_JSON_VERSION}...")
endif()

# -----------------------------------------------------------------------------
# Preprocessor symbols.

set(xpack_platform_compile_definition "PLATFORM_STM32F4DISCOVERY")
set(xpack_device_compile_definition "STM32F407xx")
string(TOLOWER ${xpack_device_compile_definition} xpack_device_name)

# -----------------------------------------------------------------------------
## The project library definitions ##

# https://cmake.org/cmake/help/v3.20/command/add_library.html?highlight=interface#normal-libraries
# PRIVATE: build definitions, used internally
# INTERFACE: usage definitions, passed up to targets linking to it
# PUBLIC: both

add_library(micro-os-plus-device-interface INTERFACE EXCLUDE_FROM_ALL)

# -----------------------------------------------------------------------------
# Target settings.

# Add the CubeMX device specific definitions.

target_include_directories(
  micro-os-plus-device-interface

  INTERFACE
    # For the CMSIS Core headers.
    "stm32cubemx/Drivers/CMSIS/Include"

    # For the CMSIS vendor files (stm32f4xx.h, system_stm32f4xx.h)
    "stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include"
)

target_sources(
  micro-os-plus-device-interface

  INTERFACE
    "stm32cubemx/Core/Src/system_stm32f4xx.c"
)

target_compile_definitions(
  micro-os-plus-device-interface

  INTERFACE
    # Already defined in the micro-os-plus-device-stm32f4-extras.
    # ${xpack_device_compile_definition}
    # ... add preprocessor macro definitions.
)

target_compile_options(
  micro-os-plus-device-interface

  INTERFACE
    # ... perhaps ignore some warnings.
)

target_link_libraries(
  micro-os-plus-device-interface

  INTERFACE
    micro-os-plus::device-cortexm

    micro-os-plus::devices-${xpack_device_name}-extras
    micro-os-plus::startup
)

if (COMMAND xpack_display_target_lists)
  xpack_display_target_lists(micro-os-plus-device-interface)
endif()

# -----------------------------------------------------------------------------
# Aliases.

# https://cmake.org/cmake/help/v3.20/command/add_library.html#alias-libraries
add_library(micro-os-plus::device ALIAS micro-os-plus-device-interface)
message(VERBOSE "> micro-os-plus::device -> micro-os-plus-device-interface")

# =============================================================================

add_library(micro-os-plus-platform-stm32f4discovery-interface INTERFACE EXCLUDE_FROM_ALL)

  if(NOT PLATFORM_STM32F4DISCOVERY_WITHOUT_HAL)

  target_include_directories(
    micro-os-plus-platform-stm32f4discovery-interface

    INTERFACE
      # For the stm32f4xx_hal_conf.h, stm32f4xx_it.h, gpio.h, main.h
      "stm32cubemx/Core/Inc"

      # For the stm32f4xx_hal.h and stm32f4xx_hal_*.h
      "stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc"
  )

  target_sources(
    micro-os-plus-platform-stm32f4discovery-interface

    INTERFACE
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c
    stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c

    # system_stm32f4xx.c is not here but in the device library.

    # These are not in the device library because they include
    # stm32f4xx_hal_conf.h, which is part of the platform.
    stm32cubemx/Core/Src/gpio.c
    stm32cubemx/Core/Src/main.c
    stm32cubemx/Core/Src/stm32f4xx_hal_msp.c
    stm32cubemx/Core/Src/stm32f4xx_it.c
  )

  endif()

target_compile_definitions(
  micro-os-plus-platform-stm32f4discovery-interface

  INTERFACE
    "${xpack_platform_compile_definition}"
)

if(NOT PLATFORM_STM32F4DISCOVERY_WITHOUT_HAL)

  target_compile_definitions(
    micro-os-plus-platform-stm32f4discovery-interface

    INTERFACE
      USE_HAL_DRIVER
  )

endif()

target_compile_options(
  micro-os-plus-platform-stm32f4discovery-interface

  INTERFACE
    # To silence HAL warnings.
    -Wno-padded
    -Wno-switch-enum
    -Wno-conversion
    -Wno-redundant-decls
    -Wno-switch-default
    -Wno-unused-parameter

    $<$<COMPILE_LANG_AND_ID:C,GNU>:-Wno-bad-function-cast>
)

target_link_libraries(
  micro-os-plus-platform-stm32f4discovery-interface

  INTERFACE
    micro-os-plus::device
    micro-os-plus::diag-trace
)

if (COMMAND xpack_display_target_lists)
  xpack_display_target_lists(micro-os-plus-platform-stm32f4discovery-interface)
endif()

# -----------------------------------------------------------------------------
# Aliases.

# https://cmake.org/cmake/help/v3.20/command/add_library.html#alias-libraries
add_library(micro-os-plus::platform-stm32f4discovery ALIAS micro-os-plus-platform-stm32f4discovery-interface)
message(VERBOSE "> micro-os-plus::platform-stm32f4discovery -> micro-os-plus-platform-stm32f4discovery-interface")

# -----------------------------------------------------------------------------
