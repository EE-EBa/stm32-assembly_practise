#ifndef BSP_H
#define BSP_H
#define USE_FULL_LL_DRIVER
#include "stm32g431xx.h"
#include "stm32g4xx_ll_gpio.h"
#include <stdint.h>
#define XXX LL_GPIO_MODE_INPUT
// #define F(X) ((X) - 1)
// uint32_t y = 0;
// uint32_t result = F(9);
void bsp_init(void);
void bsp_delay(uint32_t ticks);
void bsp_ledOn(void);
void bsp_ledOff(void);
#endif // !BSP
