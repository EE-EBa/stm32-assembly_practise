  .syntax unified
  .cpu  cortex-m4
  .thumb

  .word 0x20000400
  .word 0x080000ed
  .space 0x1c4


  .equ  RCC_BASE        , 0x40021000
  .equ  GPIOA_BASE      , 0x48000000
  .set  RCC_AHBENR      , RCC_BASE    + 0x4c
  .set  GPIOA_MODER     , GPIOA_BASE  + 0x00
  .set  GPIOA_ODR       , GPIOA_BASE  + 0x14

  @Enable gpioa clock
  ldr r0 , =RCC_AHBENR
  ldr r1 , [r0]
  orr r1 , r1 ,#0x1
  str r1 , [r0]

  @Setting gpioa2 mode
  ldr r0 , =GPIOA_MODER
  ldr r1 , [r0]
  bic r1 , r1 , #(0x3 << 4)
  orr r1 , r1 , #(0x1 << 4)
  str r1 , [r0]

  @Setting gpioa3 mode
  ldr r0 , =GPIOA_MODER
  ldr r1 , [r0]
  bic r1 , r1 , #(0x3 << 6)
  orr r1 , r1 , #(0x1 << 6)
  str r1 , [r0]

  @Setting gpioa6 mode
  ldr r0 , =GPIOA_MODER
  ldr r1 , [r0]
  bic r1 , r1 , #(0x3 << 12)
  orr r1 , r1 , #(0x1 << 12)
  str r1 , [r0]


TURN_OFF_LED:                   @This is a label , not a function name to use for instrunctons jumping 
  @Setting GPIOA2 LED turn off
  ldr r0 , =GPIOA_ODR
  ldr r1 , [r0]
  orr r1 , r1 , #(0x1 << 2)
  str r1 , [r0]

  @Setting GPIOA3 LED turn off
  ldr r0 , =GPIOA_ODR
  ldr r1 , [r0]
  orr r1 , r1 , #(0x1 << 3)
  str r1 , [r0]

  @Setting GPIOA6 LED turn off
  ldr r0 , =GPIOA_ODR
  ldr r1 , [r0]
  orr r1 , r1 , #(0x1 << 6)
  str r1 , [r0]


TURN_ON_LED:
  @Setting GPIOA2 LED turn on
  ldr r0 , =GPIOA_ODR
  ldr r1 , [r0]
  bic r1 , r1 , #(0x1 << 2)
  str r1 , [r0]


  @Setting GPIOA3 LED turn on
  ldr r0 , =GPIOA_ODR
  ldr r1 , [r0]
  bic r1 , r1 , #(0x1 << 3)
  str r1 , [r0]

  @Setting GPIOA6 LED turn on
  ldr r0 , =GPIOA_ODR
  ldr r1 , [r0]
  bic r1 , r1 , #(0x1 << 6)
  str r1 , [r0]





  b 0x08000100





