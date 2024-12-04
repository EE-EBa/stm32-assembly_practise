.syntax unified
.cpu    cortex-m4
.thumb
.include "define.inc"
.text

.type   Start_, %function
.global Start_
Start_:
    bl ClkCfg
    bl CpDataFronFlash2Ram
	bl CnfgGpioAMod

    LED:
	bl Blink
	b  LED

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
    orr r1 , r1 , #((0b1)  | (0b1 << 2)) //counter Enable , clksource = AHB
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

.type Blink, %function
Blink:
	push  {r4, r5, lr}
	ldr   r4, =BlinkTable
	ldr   r5, =BlinkTableEnd
    
    BlinkAct:
	// Setting GPIOA2 led turn off
	ldr r0, = GPIOA_BASE
	ldr r1, [r0, GPIOx_ODR]
	orr r1, r1, #(0x1 << GPIOx_2)
	str r1, [r0, GPIOx_ODR]

	// Setting GPIOA3 led turn off
	ldr r1, [r0, GPIOx_ODR]
	orr r1, r1, #(0x1 << GPIOx_3)
	str r1, [r0, GPIOx_ODR]

	// Setting GPIOA6 led turn off
	ldr r1, [r0, GPIOx_ODR]
	orr r1, r1, #(0x1 << GPIOx_6)
	str r1, [r0, GPIOx_ODR]

    ldrb r3 , [r4] , #1 
	bl Delay

	ldr r0, = GPIOA_BASE
	ldr r1, [r0, GPIOx_ODR]

	// Setting GPIOA2 led turn on
	ldr r1, [r0, GPIOx_ODR]
	bic r1, r1, #(0x1 << GPIOx_2)
	str r1, [r0, GPIOx_ODR]

	// Setting GPIOA3 led turn on
	ldr r1, [r0, GPIOx_ODR]
	bic r1, r1, #(0x1 << GPIOx_3)
	str r1, [r0, GPIOx_ODR]

	// Setting GPIOA6 led turn on
	ldr r1, [r0, GPIOx_ODR]
	bic r1, r1, #(0x1 << GPIOx_6)
	str r1, [r0, GPIOx_ODR]

    ldrb r3 , [r4]
	bl Delay

	cmp r4, r5
	blo BlinkAct

	pop { r4, r5, lr}

.type CnfgGpioAMod, %function
CnfgGpioAMod:
    push {lr}

	// Setting gpioa2 mode
	ldr r0, =GPIOA_BASE
	ldr r1, [r0, GPIOx_MODER]
	bic r1, r1, #(GPIOx_MODER_RESET_STATE << (2*GPIOx_2)) // There must be have a couple of bracket (2*GPIOx_2) ,Do not write 2*GPIOx_2
	orr r1, r1, #(GPIOx_MODER_OUT << (2*GPIOx_2))
	str r1, [r0, GPIOx_MODER]

	// Setting gpioa3 mode
	ldr r1, [r0, GPIOx_MODER]
	bic r1, r1, #(GPIOx_MODER_RESET_STATE << (2*GPIOx_3))
	orr r1, r1, #(GPIOx_MODER_OUT << (2*GPIOx_3))
	str r1, [r0, GPIOx_MODER]

	// Setting gpioa6 mode
	ldr r1, [r0, GPIOx_MODER]
	bic r1, r1, #(GPIOx_MODER_RESET_STATE << (2*GPIOx_6))
	orr r1, r1, #(GPIOx_MODER_OUT << (2*GPIOx_6))
	str r1, [r0, GPIOx_MODER]

	pop {pc}


//Paramters:
.type Delay, %function
Delay:
    ldr r0 ,= STK_CTRL
    ldr r1 , [r0]
    tst r1 , #(0b1 << 16) // 0x16000 /(156.25Khz) = 0.57s
	beq  Delay
    
    subs r3 , #1
    bhi Delay
	// Return value
	bx lr

.align 2
.section .data
.type  BlinkTable, %object
BlinkTable:
    .byte   1 , 1 , 1 , 1 , 1
    .byte   5 , 1 , 5 , 1 , 5
BlinkTableEnd:
.align 2

