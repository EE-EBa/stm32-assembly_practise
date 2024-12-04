

PROJECT	:=PRJ
PREFIX :=arm-none-eabi-

CC 	:=$(PREFIX)gcc
AS 	:=$(PREFIX)as
LD 	:=$(PREFIX)ld
GDB	:=$(PREFIX)gdb


#Define ASM files
ASM_FILES := $(shell find ./ -name "*.s")
OBJ_FILES := $(patsubst %.s , %.o , $(ASM_FILES))

#LDFLAGS	:=-Ttext=0x08000000 -Tdata=0x20000000
LDFLAGS 	:=-T stm32g431rbt6.ld
.PHONY:clean all

all:exe.elf  vectorTable.o prog.o startup.o #This is necessary ,regard all is final target rather than clean
	
%.o:%.s
	$(AS)	 -g $< -o  $@
exe.elf:vectorTable.o prog.o startup.o
	$(LD) $(LDFLAGS) $^ -o  $@

openocd_load:
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg  -f /usr/share/openocd/scripts/target/stm32g4x.cfg

openocd_swd_debug:
	$(GDB) \
	-ex 'target remote localhost:3333' \
	-ex 'monitor reset init' -ex 'monitor reset halt' \
	-ex 'load' \
	-ex 'set disassemble-next-line on ' \
	-ex 'layout r' \
	exe.elf \
	

clean:
	-rm -f *.o *.elf *.map



