.equ RCC_BASE                , 0x40021000
.equ RCC_PLLCFGR             , 0x0c
.equ RCC_CFGR                , 0x08
.equ GPIOA_BASE              , 0x48000000
.equ DELAY_LOOP_IT           , 1000000
.equ RCC_AHBENR              , 0x4C
.equ GPIOx_MODER             , 0x00
.equ GPIOx_ODR               , 0x14
.equ GPIOx_BSRR              , 0x18
.equ GPIOx_MODER_OUT         , 0b01
.equ GPIOx_MODER_RESET_STATE , 0b11
.equ GPIOx_0                 , 0
.equ GPIOx_1                 , 1
.equ GPIOx_2                 , 2
.equ GPIOx_3                 , 3
.equ GPIOx_4                 , 4
.equ GPIOx_5                 , 5
.equ GPIOx_6                 , 6
//SysTick timer
.equ STK_CTRL                , 0xe000e010
.equ STK_LOAD                , 0x4
.equ STK_VAL                 , 0x8
.equ STK_CALIB               , 0xc


