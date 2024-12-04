

  .syntax unified
  .cpu cortex-m4
  .thumb

  .section .VectorTable, "a"
  .word   _Stack_end
  .global  Start_
  .space  0x1c8


.text
  Start_:

ldr r0 , =1000000
push {r0}
pop {r1}



b .
