    .syntax unified          @ 使用 Cortex-M 的统一语法
    .cpu cortex-m4           @ 指定目标处理器是 Cortex-M4
    .thumb                   @ 使用 Thumb 指令集

    .global My_Main     @ 定义复位处理函数为入口点

    .section .text            @ 定义代码段


My_Main:
  MOV R0 , #30
  MOV R7 , #1
  SWI 0
