.syntax unified
.cpu cortex-m4
.thumb

.include "define.inc"
.text

.type   Start_, %function
.global Start_
Start_:
    bl ClkCfg
    bl CpDataFronFlash2Ram
    bl MyMain


.type ClkCfg, %function
ClkCfg:
//System clock
    ldr     r0 , = RCC_BASE
    ldr     r1 , [r0]
    orr     r1 , r1 , #(1 << 16)  // Enable HSE ON
    str     r1 , [r0]

    //Check HSE ready flag
    WaitHSERdy:
    ldr     r1 , [r0] //Read RCC_CR
    tst     r1 , #(1 << 17)
    beq     WaitHSERdy

    //PLL clk Configuration
    ldr     r1 , [r0 , RCC_PLLCFGR]     //PLL clock = HSE clock * PLLN /(PLLM*PLLR) = 16Mhz*10/(1*2) = 80Mhz
    bic     r1 , r1 , #0b11
    orr     r1 , r1 , #0b11             //Set PLL source as HSE clock
    bic     r1 , r1 , #(0b1111 << 4)    //PLLM = 1
    orr     r1 , r1 , #(10 << 8)        //PLLN = 10
    orr     r1 , r1 , #(0b1 << 24)      // Enable PLLR
    bic     r1 , r1 , #(0b11<< 25)      // PLLR = 2
    str     r1 , [r0 , RCC_PLLCFGR]

    //Enable  PLL ON
    ldr     r1 , [r0]
    orr     r1 , r1 , #(0b1 << 24)
    str     r1 , [r0]
    //Check PLL ready flg 
    WaitPLLRdy:
    ldr     r1 , [r0]
    tst     r1 , #(0b1 << 25)
    beq     WaitPLLRdy

// AHB(advanced high-performance bus) clock
    //HPRE[3:0]:AHB clock = syste clock/512=80MHz/512 = 156.25Khz
    ldr     r1 , [r0 , RCC_CFGR]
    bic     r1 , r1 , #(0b1111 << 4)
    orr     r1 , r1 , #(0b1111 << 4)
    //Set PLL as system clock 
    bic     r1 , r1 , #(0b11)
    orr     r1 , r1 , #0b11
    str     r1 , [r0 , RCC_CFGR]

    //Check system clock switch status
    WaitSWSRdy:
    ldr     r1 , [r0 , RCC_CFGR]
    lsr     r1 , r1 , #2
    and     r1 , r1 , #0b11
    cmp     r1 , #0b11
    bne     WaitSWSRdy

//Configure SysTick timer
    //STK_LOAD
    ldr r0 ,= STK_CTRL
    ldr r1 , [r0 , STK_LOAD]
    bic r1 , r1 , #(0xffffff) //clear bits
    orr r1 , r1 , #(0x16000) //0x16000 / (156.25Khz) = 0.57s
    str r1 , [r0 , STK_LOAD]

    //STK_VAL
    ldr r1 , [r0 , STK_VAL]
    bic r1 , r1 , #(0xffffff)
    str r1 , [r0 , STK_VAL]

    //STK_CTRL
    ldr r1 , [r0]
    orr r1 , r1 , #((0b1)  | (0b1 << 1) | (0b1 << 2)) //counter Enable ,  enable tickint ,clksource = AHB
    str r1 , [r0]


   //Gpioa clk
	ldr     r0 , = RCC_BASE
	ldr     r1 , [r0, RCC_AHBENR ]
	orr     r1 , r1, #1
	str     r1 , [r0, RCC_AHBENR]
	bx      lr
.type CpDataFronFlash2Ram , %function
CpDataFronFlash2Ram:
    ldr r0 , = _DataStart
    ldr r1 , = _DataEnd
    ldr r2 , = _DataLoad
    b   2f
    1:
    ldr r3 , [r2] , #4
    str r3 , [r0] , #4
    2:
    cmp r0 , r1
    blo 1b
    bx  lr


