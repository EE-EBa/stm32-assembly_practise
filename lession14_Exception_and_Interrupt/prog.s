.syntax unified
.cpu    cortex-m4
.thumb
.include "define.inc"

.macro LEDOnOff value , GpioNum 
    ldr r0 , = GPIOA_BASE
    ldr r1 , [r0 , GPIOx_BSRR]
    ldr r2 , = (((!\value) << ((\GpioNum) + 16)) | (\value << (\GpioNum)))
    str r2 , [r0 , GPIOx_BSRR]
.endm

.global MyMain
.type MyMain , %function
MyMain:
    bl CnfgGpioAMod
    //init BlinkStep
    ldr r0 , = Variables
    ldr r1 , = 0
    str r1 , [r0 , #(BlinkStep - Variables)]
    //init TimerEvents
    ldr r1 , = BlinkTable
    str r1 , [r0 , #(TimerEvents - Variables)]

    SleepLoop:
    wfi //wait for interrupt, make cpu sleep
    b SleepLoop




.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
    push {lr}
    ldr  r0  , = STK_CTRL
    ldr  r1  , [r0]
    tst  r1  , #(0b1 << 16)
    beq  Return
    
    bl   Blink

    Return:
    pop {lr}
    bx lr
.type Blink, %function
Blink:
	push  {r4, r5, lr}
	ldr   r4, =BlinkTable
	ldr   r5, =BlinkTableEnd
    
    BlinkAct:
	// Setting GPIOA2 led turn off
    LEDOnOff 1 , GPIOx_2 //Green

	// Setting GPIOA3 led turn off
    LEDOnOff 1 , GPIOx_3 //blue
	// Setting GPIOA6 led turn off
    LEDOnOff 1 , GPIOx_6 //red

    ldrb r3 , [r4] , #1 
	bl Delay

	ldr r0, = GPIOA_BASE
	ldr r1, [r0, GPIOx_ODR]

	// Setting GPIOA2 led turn on
    LEDOnOff 0 , GPIOx_2 //Green

	// Setting GPIOA3 led turn on
    LEDOnOff 0 , GPIOx_3 //blue
	// Setting GPIOA6 led turn on
    LEDOnOff 0 , GPIOx_6 //red

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

Variables:
    BlinkStep:
    .space 1
    TimerEvents:
    .space 1

