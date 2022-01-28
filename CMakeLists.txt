#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus)
# Copyright (c) 2021 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# -----------------------------------------------------------------------------

# This file is intended to be consumed by applications with:
#
# `add_subdirectory("xpacks/micro-os-plus-platform-stm32f4discovery")`
#
# The result is a static library that can be added to the linker with:
#
# `target_link_libraries(your-target PUBLIC micro-os-plus::platform-stm32f4discovery)`
#
# To avoid poluting this file with test related details, there is a separate
# CMake configuration in the `tests` folder.

# -----------------------------------------------------------------------------
## Preamble ##

# https://cmake.org/cmake/help/v3.20/
cmake_minimum_required(VERSION 3.20)

project(
  micro-os-plus-platform-stm32f4discovery
  DESCRIPTION "µOS++ STM32F4DISCOVERY board support"
)

# PRIVATE: build definitions, used internally
# INTERFACE: usage definitions, passed up to targets linking to it
# PUBLIC: both

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

add_library(micro-os-plus-device-static STATIC EXCLUDE_FROM_ALL)

# -----------------------------------------------------------------------------

# Add the CubeMX device specific definitions.
# Use the device specific definitions from the architecture (hack!).
target_sources(
  micro-os-plus-device-static

  PRIVATE
    "stm32cubemx/Core/Src/system_stm32f4xx.c"
)

message(VERBOSE "+ stm32cubemx/Core/Src/system_stm32f4xx.c")

target_include_directories(
  micro-os-plus-device-static

  PUBLIC
    # For the CMSIS Core headers.
    "stm32cubemx/Drivers/CMSIS/Include"

    # For the CMSIS vendor files (stm32f4xx.h, system_stm32f4xx.h)
    "stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include"
)

message(VERBOSE "+ stm32cubemx/Drivers/CMSIS/Include")
message(VERBOSE "+ stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include")

target_compile_definitions(
  micro-os-plus-device-static

  PUBLIC
    # ...
)

target_compile_options(
  micro-os-plus-device-static

  PRIVATE
    # To silence HAL warnings.
)

target_link_libraries(
  micro-os-plus-device-static

  PUBLIC
    # Use the device specific definitions from the architecture (hack!).
    micro-os-plus::architecture-cortexm-device

    micro-os-plus::devices-${xpack_device_name}-extras
    micro-os-plus::startup
)

# -----------------------------------------------------------------------------
# Aliases.

add_library(micro-os-plus::device ALIAS micro-os-plus-device-static)
message(VERBOSE "> micro-os-plus::device -> micro-os-plus-device-static")

# =============================================================================


add_library(micro-os-plus-platform-stm32f4discovery-interface STATIC EXCLUDE_FROM_ALL)

if(NOT PLATFORM_STM32F4DISCOVERY_WITHOUT_HAL)

  xpack_glob_recurse_cxx(source_files "${CMAKE_CURRENT_SOURCE_DIR}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src")

  list(APPEND source_files
    ${CMAKE_CURRENT_SOURCE_DIR}/stm32cubemx/Core/Src/gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/stm32cubemx/Core/Src/main.c
    ${CMAKE_CURRENT_SOURCE_DIR}/stm32cubemx/Core/Src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/stm32cubemx/Core/Src/stm32f4xx_it.c

    # system_stm32f4xx.c is not here but in the device library.

    # These are not in the device library because they include
    # stm32f4xx_hal_conf.h, which is part of the platform.
  )

  xpack_display_relative_paths("${source_files}" "${CMAKE_CURRENT_SOURCE_DIR}")

  target_sources(
    micro-os-plus-platform-stm32f4discovery-interface

    PRIVATE
      ${source_files}
  )

  target_include_directories(
    micro-os-plus-platform-stm32f4discovery-interface

    PUBLIC
      # For the stm32f4xx_hal_conf.h, stm32f4xx_it.h, gpio.h, main.h
      stm32cubemx/Core/Inc

      # For the stm32f4xx_hal.h and stm32f4xx_hal_*.h
      stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc
  )

  message(VERBOSE "+ stm32cubemx/Core/Inc")
  message(VERBOSE "+ stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc")

endif()

message(VERBOSE "+ ${xpack_platform_compile_definition}")

target_compile_definitions(
  micro-os-plus-platform-stm32f4discovery-interface

  PUBLIC
    "${xpack_platform_compile_definition}"
)

if(NOT PLATFORM_STM32F4DISCOVERY_WITHOUT_HAL)
  target_compile_definitions(
    micro-os-plus-platform-stm32f4discovery-interface

    PUBLIC
      USE_HAL_DRIVER
  )
endif()


target_compile_options(
  micro-os-plus-platform-stm32f4discovery-interface

  PRIVATE
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

  PUBLIC
    micro-os-plus::device
    micro-os-plus::diag-trace
)

# ---------------------------------------------------------------------------
# Aliases.

add_library(micro-os-plus::platform-stm32f4discovery ALIAS micro-os-plus-platform-stm32f4discovery-interface)
message(VERBOSE "> micro-os-plus::platform-stm32f4discovery -> micro-os-plus-platform-stm32f4discovery-interface")

# -----------------------------------------------------------------------------
