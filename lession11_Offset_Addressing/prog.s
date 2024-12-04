.syntax unified
.cpu    cortex-m4
.thumb

.equ RCC_BASE, 0x40021000
.equ GPIOA_BASE, 0x48000000
.equ DELAY_LOOP_IT, 1000000
.equ RCC_AHBENR, 0x4C
.equ GPIOx_MODER, 0x00
.equ GPIOx_ODR, 0x14
.equ GPIOx_MODER_OUT, 0b01
.equ GPIOx_MODER_RESET_STATE, 0b11
.equ GPIOx_0, 0
.equ GPIOx_1, 1
.equ GPIOx_2, 2
.equ GPIOx_3, 3
.equ GPIOx_4, 4
.equ GPIOx_5, 5
.equ GPIOx_6, 6

.text

Start_:
	.type   Start_, %function
	.global Start_

	bl EnClkGpioA
	bl CnfgGpioAMod
	bl LED

LED:
	bl Blink
	b  LED

Blink:
	.type Blink, %function
	push  {lr}

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

	bl Delay

	pop {pc}

EnClkGpioA:
	.type EnClkGpioA, %function
	ldr   r0, =RCC_BASE
	ldr   r1, [r0, RCC_AHBENR ]
	orr   r1, r1, #1
	str   r1, [r0, RCC_AHBENR]
	bx    lr

CnfgGpioAMod:
	.type CnfgGpioAMod, %function

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

Delay:
	.type Delay, %function
	ldr   r0, =DELAY_LOOP_IT

DlyLoop:
	subs r0, #1
	bne  DlyLoop
	bx   lr

