# STM32CubeMX content

Although not critical, for a better error reporting, some small changes
were performed to the `stm32cubemx/Core/Src/main.c` file.

Being braced by the special comments, these changes survive regenerations
with CubeMX.

## Include trace header

```c
/* USER CODE BEGIN Includes */

#if defined(MICRO_OS_PLUS_INCLUDE_MICRO_OS_PLUS_DIAG_TRACE)
#include <micro-os-plus/diag/trace.h>
#endif

/* USER CODE END Includes */
```

## Implement Error_Handler()

```c
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */

#if defined(MICRO_OS_PLUS_INCLUDE_MICRO_OS_PLUS_DIAG_TRACE)
  trace_printf("Error_Handler()\r\n");
#endif

  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
```

## Implement assert_failed()

```c
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

#if defined(MICRO_OS_PLUS_INCLUDE_MICRO_OS_PLUS_DIAG_TRACE)
  trace_printf("Wrong parameters value: file %s on line %d\r\n", file, line);
#endif

    while(1) {}

  /* USER CODE END 6 */
```

