ENTRY(My_Main)

MEMORY
{
  FLASH(rx) : ORIGIN = 0X08000000 , LENGTH =128K
  RAM(rwx)  : ORIGIN = 0X20000000 , LENGTH = 36K
}


SECTIONS
{
  .text :{
    *(.isr_vector)
    *(.text)
    *(.rodata)
    . = ALIGN(4);
    _etext = .;
}>FLASH

  .data :{
    _sdata = .;
    *(.data)
    . = ALIGN(4);
    _edata = .;
}>RAM AT>FLASH

  .bss :{
    _sbss = .;
    *(.bss)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
}>RAM

}
