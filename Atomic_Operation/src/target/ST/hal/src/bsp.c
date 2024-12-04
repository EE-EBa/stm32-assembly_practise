#include "bsp.h"

static uint32_t volatile l_tickCtr = 0;
static uint32_t l_ledFlg = 0;
void bsp_init(void) {
  SystemCoreClockUpdate();

  SysTick_Config(SystemCoreClock / 100U);
}

void SysTick_Handler(void) { ++l_tickCtr; }

uint32_t bsp_tickCtr(void) {
  uint32_t tickCtr;
  __disable_irq();
  tickCtr = l_tickCtr;
  __enable_irq();
  return tickCtr;
}

void bsp_delay(uint32_t ticks) {
  uint32_t InitTick = bsp_tickCtr();
  while ((bsp_tickCtr() - InitTick) < ticks) {
  }
}

void bsp_ledOn(void) { l_ledFlg = 1; }

void bsp_ledOff(void) { l_ledFlg = 0; }
