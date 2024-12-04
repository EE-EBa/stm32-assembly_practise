

PROJECT	:=PRJ
PREFIX :=arm-none-eabi-

CC 	:=$(PREFIX)gcc
AS 	:=$(PREFIX)as
LD 	:=$(PREFIX)ld
GDB	:=$(PREFIX)gdb


#Define ASM files
ASM_FILES := $(shell find ./ -name "*.s")
OBJ_FILES := $(patsubst %.s , %.o , $(ASM_FILES))

LDFLAGS	:=-Ttext=0x08000000

.PHONY:clean all

all:prog.elf prog.o #This is necessary ,regard all is final target rather than clean
	
%.o:%.s
	$(AS)	 -g $< -o  $@
%.elf:%.o
	$(LD) $(LDFLAGS) $< -o  $@

openocd_load:
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg  -f /usr/share/openocd/scripts/target/stm32g4x.cfg

openocd_swd_debug:
	$(GDB) \
	-ex 'target remote localhost:3333' \
	-ex 'monitor reset init' -ex 'monitor reset halt' \
	-ex 'load' \
	-ex 'b prog.s:TURN_OFF_LED' \
	-ex 'b prog.s:TURN_ON_LED' \
	-ex 'set disassemble-next-line on ' \
	-ex 'layout r' \
	prog.elf \
	

clean:
	-rm -f *.o *.elf *.map



