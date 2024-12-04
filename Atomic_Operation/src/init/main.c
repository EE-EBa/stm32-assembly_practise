// #include "stm32g431xx.h"
#define RCC_AHB1ENR ((volatile unsigned int *)(0x40021000 + 0x4c))
#define GPIOA_BASE 0x48000000UL
#define GPIOA_MODER ((volatile unsigned int *)(GPIOA_BASE + 0x0))
#define GPIOA_BSRR ((volatile unsigned int *)(GPIOA_BASE + 0x18UL))
void delay(void) {
  for (volatile int i = 0; i < 100000; i++)
    ;
}
int main(void) {

  *RCC_AHB1ENR |= 0x1;

  delay();
  *GPIOA_MODER &= ~((0x3 << (2 * 2)) | (0x3 << (2 * 3)) | (0x3 << (2 * 6)));
  *GPIOA_MODER |= (0x1 << (2 * 2)) | (0x1 << (2 * 3)) | (0x1 << (2 * 6));

  for (;;) {
    delay();

    *GPIOA_BSRR = (0x1 << 2) | (0x1 << 3) | (0x1 << 6);
    //    GPIOA->BSRR  = (0x1 << 2)| (0x1 << 3) | (0x1 << 6);
    delay();
    *GPIOA_BSRR = ((0x1 << (2 + 16)) | (0x1 << (3 + 16)) | (0x1 << (6 + 16)));

    //    GPIOA->BSRR  = ((0x1 << (2 + 16)) | (0x1 << (3 + 16)) | (0x1 << (6 +
    //    16)));
  }
  return 0;
}
