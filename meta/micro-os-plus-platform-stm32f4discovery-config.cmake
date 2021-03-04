#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus)
# Copyright (c) 2021 Liviu Ionescu
#
# This Source Code Form is subject to the terms of the MIT License.
# If a copy of the license was not distributed with this file, it can
# be obtained from https://opensource.org/licenses/MIT/.
#
# -----------------------------------------------------------------------------

# https://cmake.org/cmake/help/v3.18/
# https://cmake.org/cmake/help/v3.18/manual/cmake-packages.7.html#package-configuration-file

if(micro-os-plus-platform-stm32f4discovery-included)
  return()
endif()

set(micro-os-plus-platform-stm32f4discovery-included TRUE)

message(STATUS "Processing xPack ${PACKAGE_JSON_NAME}@${PACKAGE_JSON_VERSION}...")

# -----------------------------------------------------------------------------
# Preprocessor symbols.

# TODO: migrate them to CMake options.
set(xpack_platform_compile_definition "PLATFORM_STM32F4DISCOVERY")
set(xpack_device_compile_definition "STM32F407xx")

# -----------------------------------------------------------------------------

find_package(micro-os-plus-devices-stm32f4-extras)
find_package(micro-os-plus-architecture-cortexm)
find_package(micro-os-plus-startup)
find_package(micro-os-plus-diag-trace)

# -----------------------------------------------------------------------------

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_LIST_DIR} DIRECTORY)

  # ---------------------------------------------------------------------------

  if (NOT TARGET micro-os-plus-device-interface)

    add_library(micro-os-plus-device-interface INTERFACE EXCLUDE_FROM_ALL)

    # -------------------------------------------------------------------------

    set(source_files
      ${xpack_current_folder}/stm32cubemx/Core/Src/system_stm32f4xx.c
    )

    xpack_display_relative_paths("${source_files}" "${xpack_current_folder}")

    # Add the CubeMX device specific definitions.
    # Use the device specific definitions from the architecture (hack!).
    target_sources(
      micro-os-plus-device-interface
  
      INTERFACE
        ${source_files}
    )

    target_include_directories(
      micro-os-plus-device-interface
  
      INTERFACE
        ${xpack_current_folder}/device/include
  
        # For the CMSIS Core headers.
        ${xpack_current_folder}/stm32cubemx/Drivers/CMSIS/Include

        # For the CMSIS vendor files (stm32f4xx.h, system_stm32f4xx.h)
        ${xpack_current_folder}/stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include
    )

    message(STATUS "+ ${xpack_device_compile_definition}")

    target_compile_definitions(
      micro-os-plus-device-interface
  
      INTERFACE
        "${xpack_device_compile_definition}"
    )
  
    target_link_libraries(
      micro-os-plus-device-interface

      INTERFACE
        # Use the device specific definitions from the architecture (hack!).
        micro-os-plus::architecture-cortexm-device

        micro-os-plus::devices-stm32f4-extras
        micro-os-plus::startup-static
    )

    # -------------------------------------------------------------------------
    # Aliases.

    add_library(micro-os-plus::device ALIAS micro-os-plus-device-interface)
    message(STATUS "micro-os-plus::device")

  endif()

  # ===========================================================================

  if (NOT micro-os-plus-platform-stm32f4discovery-interface)

    add_library(micro-os-plus-platform-stm32f4discovery-interface INTERFACE EXCLUDE_FROM_ALL)

    # -------------------------------------------------------------------------

    xpack_glob_recurse_cxx(source_files "${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src")

    list(APPEND source_files
      ${xpack_current_folder}/stm32cubemx/Core/Src/gpio.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/main.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/stm32f4xx_hal_msp.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/stm32f4xx_it.c

      # system_stm32f4xx.c is not here but in the device library.

      # These are not in the device library because they include
      # stm32f4xx_hal_conf.h, which is part of the platform.
    )

    xpack_display_relative_paths("${source_files}" "${xpack_current_folder}")

    target_sources(
      micro-os-plus-platform-stm32f4discovery-interface
  
      INTERFACE
        ${source_files}
    )

    target_include_directories(
      micro-os-plus-platform-stm32f4discovery-interface
  
      INTERFACE
        # For the stm32f4xx_hal_conf.h, stm32f4xx_it.h, gpio.h, main.h
        ${xpack_current_folder}/stm32cubemx/Core/Inc

        # For the stm32f4xx_hal.h and stm32f4xx_hal_*.h
        ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc
    )

    message(STATUS "+ ${xpack_platform_compile_definition}")

    target_compile_definitions(
      micro-os-plus-platform-stm32f4discovery-interface
  
      INTERFACE
        "${xpack_platform_compile_definition}"
        USE_HAL_DRIVER
    )
  
    target_link_libraries(
      micro-os-plus-platform-stm32f4discovery-interface
      
      INTERFACE
        micro-os-plus::device
        micro-os-plus::diag-trace-static
    )

    # -------------------------------------------------------------------------
    # Aliases.

    add_library(micro-os-plus::platform-stm32f4discovery ALIAS micro-os-plus-platform-stm32f4discovery-interface)
    message(STATUS "micro-os-plus::platform-stm32f4discovery")

  endif()

# -----------------------------------------------------------------------------
