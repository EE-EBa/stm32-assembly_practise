.syntax unified

.cpu cortex-m4
.thumb

.text

Start_:
	.type   Start_, %function
	.global Start_
	ldr     r0, =#6
	ldr     r1, =#18

gcd:
	cmp   r0, r1
	ite   gt
	subgt r0, r0, r1
	suble r1, r1, r0
	bne   gcd

	b .
