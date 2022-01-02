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

# https://cmake.org/cmake/help/v3.19/
# https://cmake.org/cmake/help/v3.19/manual/cmake-packages.7.html#package-configuration-file
cmake_minimum_required(VERSION 3.19)

# Use targets as include markers (variables are not scope independent).
if(TARGET micro-os-plus-platform-stm32f4discovery-included)
  return()
else()
  add_custom_target(micro-os-plus-platform-stm32f4discovery-included)
endif()

if(NOT TARGET micro-os-plus-build-helper-included)
  message(FATAL_ERROR "Include the mandatory build-helper (xpacks/micro-os-plus-build-helper/cmake/xpack-helper.cmake)")
endif()

message(STATUS "Processing xPack ${PACKAGE_JSON_NAME}@${PACKAGE_JSON_VERSION}...")

# -----------------------------------------------------------------------------
# Preprocessor symbols.

# TODO: migrate them to CMake options.
set(xpack_platform_compile_definition "PLATFORM_STM32F4DISCOVERY")
set(xpack_device_compile_definition "STM32F407xx")

# -----------------------------------------------------------------------------

find_package(micro-os-plus-devices-stm32f4-extras)
message(STATUS "Baburiba 2")
find_package(micro-os-plus-architecture-cortexm)
find_package(micro-os-plus-startup)
find_package(micro-os-plus-diag-trace)

# -----------------------------------------------------------------------------

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_LIST_DIR} DIRECTORY)

  # ---------------------------------------------------------------------------

  if (NOT TARGET micro-os-plus-device-static)

    add_library(micro-os-plus-device-static STATIC EXCLUDE_FROM_ALL)

    # -------------------------------------------------------------------------

    set(source_files
      ${xpack_current_folder}/stm32cubemx/Core/Src/system_stm32f4xx.c
    )

    xpack_display_relative_paths("${source_files}" "${xpack_current_folder}")

    # Add the CubeMX device specific definitions.
    # Use the device specific definitions from the architecture (hack!).
    target_sources(
      micro-os-plus-device-static

      PRIVATE
        ${source_files}
    )

    target_include_directories(
      micro-os-plus-device-static

      PUBLIC
        # For the CMSIS Core headers.
        ${xpack_current_folder}/stm32cubemx/Drivers/CMSIS/Include

        # For the CMSIS vendor files (stm32f4xx.h, system_stm32f4xx.h)
        ${xpack_current_folder}/stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include
    )

    message(STATUS "+ ${xpack_device_compile_definition}")

    target_compile_definitions(
      micro-os-plus-device-static

      PUBLIC
        "${xpack_device_compile_definition}"
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

        micro-os-plus::devices-stm32f4-extras
        micro-os-plus::startup
    )

    # -------------------------------------------------------------------------
    # Aliases.

    add_library(micro-os-plus::device ALIAS micro-os-plus-device-static)
    message(STATUS "=> micro-os-plus::device")

  endif()

  # ===========================================================================

  if (NOT micro-os-plus-platform-stm32f4discovery-interface)

    add_library(micro-os-plus-platform-stm32f4discovery-interface STATIC EXCLUDE_FROM_ALL)

    # -------------------------------------------------------------------------

    if(NOT PLATFORM_STM32F4DISCOVERY_WITHOUT_HAL)

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

      PRIVATE
        ${source_files}
    )

    target_include_directories(
      micro-os-plus-platform-stm32f4discovery-interface

      PUBLIC
        # For the stm32f4xx_hal_conf.h, stm32f4xx_it.h, gpio.h, main.h
        ${xpack_current_folder}/stm32cubemx/Core/Inc

        # For the stm32f4xx_hal.h and stm32f4xx_hal_*.h
        ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc
    )
    endif()

    message(STATUS "+ ${xpack_platform_compile_definition}")

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

    # -------------------------------------------------------------------------
    # Aliases.

    add_library(micro-os-plus::platform-stm32f4discovery ALIAS micro-os-plus-platform-stm32f4discovery-interface)
    message(STATUS "=> micro-os-plus::platform-stm32f4discovery")

  endif()

# -----------------------------------------------------------------------------
