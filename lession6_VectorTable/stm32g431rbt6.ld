ENTRY(Start_)

MEMORY{

  FLASH : ORIGIN = 0X08000000 , LENGTH = 128K
  RAM   : ORIGIN = 0x20000000 , LENGTH = 32K
}


SECTIONS{
    .VectorTable :{
    *(.VectorTable)
} >FLASH


  .FinalText :{
    *(.text)
} >FLASH
  .FinalData (NOLOAD) :{
    . = . + 0x400;
    _Stack_end = .;
    *(.data)
} >RAM


}
