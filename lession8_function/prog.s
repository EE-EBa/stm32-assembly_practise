.syntax unified

.cpu cortex-m4
.thumb

.equ RCC_BASE, 0x40021000
.equ GPIOA_BASE, 0x48000000
.equ DELAY_LOOP_ITERATIONS, 1000000
.set RCC_AHBENR, RCC_BASE    + 0x4c
.set GPIOA_MODER, GPIOA_BASE  + 0x00
.set GPIOA_ODR, GPIOA_BASE  + 0x14

.text

Start_:
	.type   Start_, %function
	.global Start_            // define global variable, and this is program entry

	bl EnableClockGPIOA  // Call function to enbale GPIOA's peripheral clock
	bl ConfigureGPIOMode
	bl LED

LED:
	bl Blink
	b  LED

Blink:
	.type Blink, %function
	push  {lr}
	ldr   r2, =DELAY_LOOP_ITERATIONS // LED blinking time

	// Setting GPIOA2 LED turn off
	ldr r0, =GPIOA_ODR
	ldr r1, [r0]
	orr r1, r1, #(0x1 << 2)
	str r1, [r0]

	// Setting GPIOA3 LED turn off
	ldr r0, =GPIOA_ODR
	ldr r1, [r0]
	orr r1, r1, #(0x1 << 3)
	str r1, [r0]

	// Setting GPIOA6 LED turn off
	ldr r0, =GPIOA_ODR
	ldr r1, [r0]
	orr r1, r1, #(0x1 << 6)
	str r1, [r0]

	bl Delay

	// Setting GPIOA2 LED turn on
	ldr r0, =GPIOA_ODR
	ldr r1, [r0]
	bic r1, r1, #(0x1 << 2)
	str r1, [r0]

	// Setting GPIOA3 LED turn on
	ldr r0, =GPIOA_ODR
	ldr r1, [r0]
	bic r1, r1, #(0x1 << 3)
	str r1, [r0]

	// Setting GPIOA6 LED turn on
	ldr r0, =GPIOA_ODR
	ldr r1, [r0]
	bic r1, r1, #(0x1 << 6)
	str r1, [r0]
	bl  Delay

	pop {lr}
	bx  lr

EnableClockGPIOA:
	.type EnableClockGPIOA, %function
	ldr   r0, =RCC_AHBENR
	ldr   r1, [r0]
	orr   r1, r1, #0x1
	str   r1, [r0]
	bx    lr                          // Return to caller

ConfigureGPIOMode:
	.type ConfigureGPIOMode, %function

	// Setting gpioa2 mode
	ldr r0, =GPIOA_MODER
	ldr r1, [r0]
	bic r1, r1, #(0x3 << 4)
	orr r1, r1, #(0x1 << 4)
	str r1, [r0]

	// Setting gpioa3 mode
	ldr r0, =GPIOA_MODER
	ldr r1, [r0]
	bic r1, r1, #(0x3 << 6)
	orr r1, r1, #(0x1 << 6)
	str r1, [r0]

	// Setting gpioa6 mode
	ldr r0, =GPIOA_MODER
	ldr r1, [r0]
	bic r1, r1, #(0x3 << 12)
	orr r1, r1, #(0x1 << 12)
	str r1, [r0]
	bx  lr

Delay:
	.type Delay, %function
	mov   r3, r2

DelayLoop:
	subs r3, #1
	bne  DelayLoop
	bx   lr

	b .
