# -----------------------------------------------------------------------------
#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus/)
# Copyright (c) 2022 Liviu Ionescu
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
# `subdir('xpacks/@micro-os-plus/platform-stm32f4discovery')`
#
# The result is a dependency that can be added to the linker with:
#
# `dependencies: [micro_os_plus_platform_stm32f4discovery_dependency],`

# Note: the meson configuration is provided only as a proof of concept,
# for production it might need some refinements.

# -----------------------------------------------------------------------------
# Preprocessor symbols.

xpack_platform_compile_definition = 'PLATFORM_STM32F4DISCOVERY'
xpack_device_compile_definition = 'STM32F407xx'
xpack_device_name = xpack_device_compile_definition.to_lower()

# -----------------------------------------------------------------------------

message('Processing xPack @micro-os-plus/platform-stm32f4discovery...')

# https://mesonbuild.com/Reference-manual_functions.html#declare_dependency
micro_os_plus_device_dependency = declare_dependency(
  include_directories: include_directories(
    # For the CMSIS Core headers.
    'stm32cubemx/Drivers/CMSIS/Include',

    # For the CMSIS vendor files (stm32f4xx.h, system_stm32f4xx.h)
    'stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include'
  ),
  sources: files(
    'stm32cubemx/Core/Src/system_stm32f4xx.c',
  ),
  compile_args: [
    # Already defined in the micro_os_plus-device-stm32f4-extras.
    # '-D'+xpack_device_compile_definition,
  ],
  dependencies: [
    micro_os_plus_devices_cortexm_dependency,

    get_variable('micro_os_plus_devices_'+xpack_device_name+'_extras_dependency'),
    micro_os_plus_startup_dependency
  ]
)

message('+ -I stm32cubemx/Drivers/CMSIS/Include')
message('+ -I stm32cubemx/Drivers/CMSIS/Device/ST/STM32F4xx/Include')
message('+ stm32cubemx/Core/Src/system_stm32f4xx.c')
message('> micro_os_plus_device_dependency')

# =============================================================================

# https://mesonbuild.com/Reference-manual_functions.html#declare_dependency
micro_os_plus_platform_stm32f4discovery_dependency = declare_dependency(
  include_directories: include_directories(
    # For the stm32f4xx_hal_conf.h, stm32f4xx_it.h, gpio.h, main.h
    'stm32cubemx/Core/Inc',

    # For the stm32f4xx_hal.h and stm32f4xx_hal_*.h
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc'
  ),
  sources: files(
    # Must be updated when CubeMX code is generated again.
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c',
    'stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c',

    # These are not in the device library because they include
    # stm32f4xx_hal_conf.h, which is part of the platform.
    'stm32cubemx/Core/Src/gpio.c',
    'stm32cubemx/Core/Src/main.c',
    'stm32cubemx/Core/Src/stm32f4xx_hal_msp.c',
    'stm32cubemx/Core/Src/stm32f4xx_it.c'

    # system_stm32f4xx.c is not here but in the device library.
  ),
  compile_args: [
    '-D'+xpack_platform_compile_definition,
    '-DUSE_HAL_DRIVER',
    # To silence HAL warnings.
    '-Wno-padded',
    '-Wno-switch-enum',
    '-Wno-conversion',
    '-Wno-redundant-decls',
    '-Wno-switch-default',
    '-Wno-unused-parameter',
    # $<$<COMPILE_LANG_AND_ID:C,GNU>:-Wno-bad-function-cast>
  ],
  dependencies: [
    micro_os_plus_device_dependency,
    micro_os_plus_diag_trace_dependency,
  ]
)

message('+ -I stm32cubemx/Core/Inc')
message('+ -I stm32cubemx/Drivers/STM32F4xx_HAL_Driver/Inc')
message('+ -D '+xpack_platform_compile_definition)
message('+ -D USE_HAL_DRIVER')
message('+ stm32cubemx/Core/Src/gpio.c')
message('+ stm32cubemx/Core/Src/main.c')
message('+ stm32cubemx/Core/Src/stm32f4xx_hal_msp.c')
message('+ stm32cubemx/Core/Src/stm32f4xx_it.c')

message('> micro_os_plus_platform_stm32f4discovery_dependency')

# -----------------------------------------------------------------------------
