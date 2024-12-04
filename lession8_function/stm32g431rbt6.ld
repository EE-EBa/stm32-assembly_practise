ENTRY(Start_)

MEMORY{

  FLASH : ORIGIN = 0X08000000 , LENGTH = 128K
  RAM   : ORIGIN = 0x20000000 , LENGTH = 32K
}


SECTIONS{

  .MyVectorTable :{
    . = ALIGN(4);
    KEEP(*(.VectorTable)) /* Adding kewword KEEP to avoid VectorTable SECTIONS is optimized.*/
    . = ALIGN(4);

} >FLASH


  .FinalText :{
    . = ALIGN(4);
    *(.text)
    . = ALIGN(4);
} >FLASH

  .stack (NOLOAD):{
    . = ALIGN(4);
    . = . + 0x400;
    . = ALIGN(4);
    _Stack_end = .;
    . = ALIGN(4);
} >RAM

  .FinalData  :{
    . = ALIGN(4);
    _DataStart = .;
    *(.data)
    . = ALIGN(4);
    _DataEnd = .;
} >RAM 

  _DataLoad = LOADADDR(.FinalData);


  .bss (NOLOAD) : {
   
  *(.bss)


}>RAM




}
