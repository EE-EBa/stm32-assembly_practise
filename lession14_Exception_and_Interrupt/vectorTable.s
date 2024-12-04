
.syntax unified
.cpu  cortex-m4
.thumb

.macro defisr name
  .global     \name
  .weak       \name
  .thumb_set  \name , Default_Handler
  .word       \name
.endm

.global   VectorTable
.section  .VectorTable, "a"
.type     VectorTable , %object
VectorTable:
    .word _Stack_end 
	defisr	Start_
	defisr	NMI_Handler
	defisr	HardFault_Handler
	defisr	MemManage_Handler
	defisr	BusFault_Handler
	defisr	UsageFault_Handler
	.word   0
	.word   0
	.word   0
	.word   0
	defisr	SVC_Handler
	defisr	DebugMon_Handler
	.word 	0
	defisr	PendSV_Handler
	defisr	SysTick_Handler
	defisr	WWDG_IRQHandler
	defisr	PVD_PVM_IRQHandler
	defisr	RTC_TAMP_LSECSS_IRQHandler
	defisr	RTC_WKUP_IRQHandler
	defisr	FLASH_IRQHandler
	defisr	RCC_IRQHandler
	defisr	EXTI0_IRQHandler
	defisr	EXTI1_IRQHandler
	defisr	EXTI2_IRQHandler
	defisr	EXTI3_IRQHandler
	defisr	EXTI4_IRQHandler
	defisr	DMA1_Channel1_IRQHandler
	defisr	DMA1_Channel2_IRQHandler
	defisr	DMA1_Channel3_IRQHandler
	defisr	DMA1_Channel4_IRQHandler
	defisr	DMA1_Channel5_IRQHandler
	defisr	DMA1_Channel6_IRQHandler
	.word 	0
	defisr	ADC1_2_IRQHandler
	defisr	USB_HP_IRQHandler
	defisr	USB_LP_IRQHandler
	defisr	FDCAN1_IT0_IRQHandler
	defisr	FDCAN1_IT1_IRQHandler
	defisr	EXTI9_5_IRQHandler
	defisr	TIM1_BRK_TIM15_IRQHandler
	defisr	TIM1_UP_TIM16_IRQHandler
	defisr	TIM1_TRG_COM_TIM17_IRQHandler
	defisr	TIM1_CC_IRQHandler
	defisr	TIM2_IRQHandler
	defisr	TIM3_IRQHandler
	defisr	TIM4_IRQHandler
	defisr	I2C1_EV_IRQHandler
	defisr	I2C1_ER_IRQHandler
	defisr	I2C2_EV_IRQHandler
	defisr	I2C2_ER_IRQHandler
	defisr	SPI1_IRQHandler
	defisr	SPI2_IRQHandler
	defisr	USART1_IRQHandler
	defisr	USART2_IRQHandler
	defisr	USART3_IRQHandler
	defisr	EXTI15_10_IRQHandler
	defisr	RTC_Alarm_IRQHandler
	defisr	USBWakeUp_IRQHandler
	defisr	TIM8_BRK_IRQHandler
	defisr	TIM8_UP_IRQHandler
	defisr	TIM8_TRG_COM_IRQHandler
	defisr	TIM8_CC_IRQHandler
	.word		0
	.word		0
	defisr	LPTIM1_IRQHandler
	.word		0
	defisr	SPI3_IRQHandler
	defisr	UART4_IRQHandler
	.word		0
	defisr	TIM6_DAC_IRQHandler
	defisr	TIM7_IRQHandler
	defisr	DMA2_Channel1_IRQHandler
	defisr	DMA2_Channel2_IRQHandler
	defisr	DMA2_Channel3_IRQHandler
	defisr	DMA2_Channel4_IRQHandler
	defisr	DMA2_Channel5_IRQHandler
	.word		0
	.word		0
	defisr	UCPD1_IRQHandler
	defisr	COMP1_2_3_IRQHandler
	defisr	COMP4_IRQHandler
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	defisr	CRS_IRQHandler
	defisr	SAI1_IRQHandler
	.word		0
	.word		0
	.word		0
	.word		0
	defisr	FPU_IRQHandler
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	.word		0
	defisr	RNG_IRQHandler
	defisr	LPUART1_IRQHandler
	defisr	I2C3_EV_IRQHandler
	defisr	I2C3_ER_IRQHandler
	defisr	DMAMUX_OVR_IRQHandler
	.word		0
	.word		0
	defisr	DMA2_Channel6_IRQHandler
	.word		0
	.word		0
	defisr	CORDIC_IRQHandler
	defisr	FMAC_IRQHandler

.text
  .type Default_Handler , %function
  .global Default_Handler
  Default_Handler:
  bkpt    
  b.n  Default_Handler
  
