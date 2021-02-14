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

if(micro-os-plus-platform-stm32f4discovery-included)
  return()
endif()

set(micro-os-plus-platform-stm32f4discovery-included TRUE)

message(STATUS "Including micro-os-plus-platform-stm32f4discovery...")

# -----------------------------------------------------------------------------

# Preprocessor symbols.
set(xpack_platform_compile_definition "PLATFORM_STM32F4DISCOVERY")
message(STATUS "${xpack_platform_compile_definition}")

set(xpack_device_compile_definition "STM32F407xx")
message(STATUS "${xpack_device_compile_definition}")

# =============================================================================

function(target_sources_micro_os_plus_platform_stm32f4discovery target)

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_FUNCTION_LIST_DIR} DIRECTORY)

  target_sources(
    ${target}

    PUBLIC
      ${xpack_current_folder}/stm32cubemx/Core/Src/gpio.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/main.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/stm32f4xx_hal_msp.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/stm32f4xx_it.c
      ${xpack_current_folder}/stm32cubemx/Core/Src/system_stm32f4xx.c

      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c
    )

endfunction()


function(target_include_directories_micro_os_plus_platform_stm32f4discovery target)

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_FUNCTION_LIST_DIR} DIRECTORY)

  target_include_directories(
    ${target}

    PUBLIC
      ${xpack_current_folder}/stm32cubemx/Core/Inc
      ${xpack_current_folder}/stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc
  )

endfunction()


function(target_compile_definitions_micro_os_plus_platform_stm32f4discovery target)

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_FUNCTION_LIST_DIR} DIRECTORY)

  target_compile_definitions(
    ${target}

    PUBLIC
      USE_HAL_DRIVER
      "${xpack_platform_compile_definition}"
  )

endfunction()

# =============================================================================

function(target_sources_micro_os_plus_platform_stm32f4discovery_device target)

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_FUNCTION_LIST_DIR} DIRECTORY)

  target_sources(
    ${target}

    PUBLIC
      # ...
  )

endfunction()


function(target_include_directories_micro_os_plus_platform_stm32f4discovery_device target)

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_FUNCTION_LIST_DIR} DIRECTORY)

  target_include_directories(
    ${target}

    PUBLIC
      ${xpack_current_folder}/device/include

      ${xpack_current_folder}/stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include
      ${xpack_current_folder}/stm32cubemx/Drivers/CMSIS/Include
  )

endfunction()


function(target_compile_definitions_micro_os_plus_platform_stm32f4discovery_device target)

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_FUNCTION_LIST_DIR} DIRECTORY)

  target_compile_definitions(
    ${target}

    PUBLIC
      "${xpack_device_compile_definition}"
  )

endfunction()

# =============================================================================

function(add_libraries_micro_os_plus_platform_stm32f4discovery)

  # ---------------------------------------------------------------------------

  find_package(micro-os-plus-devices-stm32f4-extras)
  find_package(micro-os-plus-semihosting)

  # ---------------------------------------------------------------------------

  if(NOT TARGET micro-os-plus-device-objects)

    # Device definitions. Depend on devices-stm32f4-extras and the device
    # specific definitions stored in the architecture (hack!).
    add_library(micro-os-plus-device-objects OBJECT EXCLUDE_FROM_ALL)

    # Use the device specific definitions from the architecture (hack!).
    target_sources_micro_os_plus_architecture_cortexm_device(micro-os-plus-device-objects)
    target_include_directories_micro_os_plus_architecture_cortexm_device(micro-os-plus-device-objects)
    target_compile_definitions_micro_os_plus_architecture_cortexm_device(micro-os-plus-device-objects)

    # Add the CubeMX device specific definitions.
    target_sources_micro_os_plus_platform_stm32f4discovery_device(micro-os-plus-device-objects)
    target_include_directories_micro_os_plus_platform_stm32f4discovery_device(micro-os-plus-device-objects)
    target_compile_definitions_micro_os_plus_platform_stm32f4discovery_device(micro-os-plus-device-objects)

    add_library(micro-os-plus::device-objects ALIAS micro-os-plus-device-objects)
    add_library(micro-os-plus::device ALIAS micro-os-plus-device-objects)
    message(STATUS "micro-os-plus::device")

    target_link_libraries(
      micro-os-plus-device-objects

      PUBLIC
        micro-os-plus::common
        micro-os-plus::devices-stm32f4-extras
        micro-os-plus::semihosting
        micro-os-plus::startup
    )

  endif()

  # ---------------------------------------------------------------------------

if(true)
  if (NOT TARGET micro-os-plus-device-static)

    add_library(micro-os-plus-device-static STATIC EXCLUDE_FROM_ALL)

    # Use the device specific definitions from the architecture (hack!).
    target_sources_micro_os_plus_architecture_cortexm_device(micro-os-plus-device-static)
    target_include_directories_micro_os_plus_architecture_cortexm_device(micro-os-plus-device-static)
    target_compile_definitions_micro_os_plus_architecture_cortexm_device(micro-os-plus-device-static)

    # Add the CubeMX device specific definitions.
    target_sources_micro_os_plus_platform_stm32f4discovery_device(micro-os-plus-device-static)
    target_include_directories_micro_os_plus_platform_stm32f4discovery_device(micro-os-plus-device-static)
    target_compile_definitions_micro_os_plus_platform_stm32f4discovery_device(micro-os-plus-device-static)

    add_library(micro-os-plus::device-static ALIAS micro-os-plus-device-static)

    target_link_libraries(
      micro-os-plus-device-static

      PUBLIC
        micro-os-plus::common
        micro-os-plus::devices-stm32f4-extras-static
        micro-os-plus::semihosting-static
        micro-os-plus::startup-static
    )

  endif()
endif()

  # ===========================================================================

  find_package(micro-os-plus-diag-trace)

  # ---------------------------------------------------------------------------

  if (NOT TARGET micro-os-plus-platform-stm32f4discovery-objects)

    add_library(micro-os-plus-platform-stm32f4discovery-objects OBJECT EXCLUDE_FROM_ALL)

    target_sources_micro_os_plus_platform_stm32f4discovery(micro-os-plus-platform-stm32f4discovery-objects)
    target_include_directories_micro_os_plus_platform_stm32f4discovery(micro-os-plus-platform-stm32f4discovery-objects)
    target_compile_definitions_micro_os_plus_platform_stm32f4discovery(micro-os-plus-platform-stm32f4discovery-objects)

    add_library(micro-os-plus::platform-stm32f4discovery ALIAS micro-os-plus-platform-stm32f4discovery-objects)
    message(STATUS "micro-os-plus::platform-stm32f4discovery")

    target_link_libraries(
      micro-os-plus-platform-stm32f4discovery-objects

      PUBLIC
        micro-os-plus::device
        micro-os-plus::diag-trace
    )

  endif()

  # ---------------------------------------------------------------------------

if(true)
  if (NOT micro-os-plus-platform-stm32f4discovery-static)

    add_library(micro-os-plus-platform-stm32f4discovery-static STATIC EXCLUDE_FROM_ALL)

    target_sources_micro_os_plus_platform_stm32f4discovery(micro-os-plus-platform-stm32f4discovery-static)
    target_include_directories_micro_os_plus_platform_stm32f4discovery(micro-os-plus-platform-stm32f4discovery-static)
    target_compile_definitions_micro_os_plus_platform_stm32f4discovery(micro-os-plus-platform-stm32f4discovery-static)

    add_library(micro-os-plus::platform-stm32f4discovery-static ALIAS micro-os-plus-platform-stm32f4discovery-static)

    target_link_libraries(
      micro-os-plus-platform-stm32f4discovery-static
      
      PUBLIC
        micro-os-plus::device-static
        micro-os-plus::diag-trace-static
    )

  endif()
endif()
  # ---------------------------------------------------------------------------

endfunction()

# -----------------------------------------------------------------------------
