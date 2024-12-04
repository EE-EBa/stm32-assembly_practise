#Project name
PROJECT		:= PRJ
TargetSeriesMCU :=stm32g4x#use for openocd command
#Define mcu architecture
MCU 		:= cortex-m4
DebugTool :=stlink#Use for openocd command
#define compile tool
CC_PREFIX   := arm-none-eabi-
CC 			:= $(CC_PREFIX)gcc
CXX 		:= $(CC_PREFIX)g++
CP 			:= $(CC_PREFIX)objcopy
GDB 		:= $(CC_PREFIX)gdb
SIZE 		:= $(CC_PREFIX)size
AS 			:= $(CC) -x assembler-with-cpp
HEX 		:= $(CP) -O ihex
BIN 		:= $(CP) -O binary -S

#Define optimization 
OPT 		+= -O0
OPT			+= -fsingle-precision-constant #this mean's that by default,all constant is single-float ,not double type
OPT 		+= -fno-common #Inhibiting  variables multiple definition
OPT 		+= -ffunction-sections -fdata-sections#each function is divided into individual section

#Use Semihosting Debug When Compiling with GCC
#and enable floating point support in printf. It is not enabled by default
SPECS		:= --specs=rdimon.specs -u _printf_float
#SPECS		:= --specs=nano.specs -u _printf_float
#SPECS = -specs=nosys.specs
#Define link script
LINK_SCRIPT	:= $(shell find . -name "*.ld")


################################################################################
#Define FLAGS
FLAGS_MCU	:= -mcpu=$(MCU)
FLAGS_AS 	:= $(SPECS) $(FLAGS_MCU) $(OPT) -c -g -gdwarf-2 -mthumb
FLAGS_C 	:= $(SPECS) $(FLAGS_MCU) $(OPT) -c -g -MD -MP -gdwarf-2 -mthumb \
				-fomit-frame-pointer -Wall -fverbose-asm 
#Optimization section
FLAGS_LD 	:= $(SPECS) $(FLAGS_MCU) $(OPT) -lm -g -gdwarf-2 -mthumb \
				 -Xlinker --gc-section -T$(LINK_SCRIPT) \
				-Wl,-Map=$(PROJECT).map,--cref,--no-warn-mismatch
#No optimization section
FLAGS_LD1 	:= $(SPECS) $(FLAGS_MCU) $(OPT) -lm -g -gdwarf-2 -mthumb \
				 -Xlinker -T$(LINK_SCRIPT) \
				-Wl,-Map=$(PROJECT).map,--cref,--no-warn-mismatch
#Define SRC , OBJ , DPT ,INC files
C_INC_FILES := $(shell find ./ -name "*.h" |xargs dirname)
C_INC_FILES := $(addprefix -I,$(C_INC_FILES))
C_SRC_FILES := $(shell find ./ -name "*.c")
C_ASM_FILES += $(shell find ./src/target/ST/STM32G431RBT6/Device/ST/STM32G4xx/Source/Templates/gcc/ -name "*431*.s")
#C_ASM_FILES += $(shell find ./  -name "*.s" -not -path "./src/target/ST/STM32G431RBT6/Device/ST/STM32G4xx/Source/Templates/*")
C_OBJ_FILES	+= $(patsubst %.c,%.o,$(C_SRC_FILES))
C_OBJ_FILES	+= $(patsubst %.s,%.o,$(C_ASM_FILES))
C_DPT_FILES := $(patsubst %.c,%.d,$(C_SRC_FILES))


#Define debug paramter
TYPE_LOAD	:= openocd_load
TYPE_BURN	:= openocd_swd_flash
TYPE_DEBUG	:= openocd_swd_debug
TYPE_ERASE	:= openocd_swd_erase

################################################################################
.PHONY:all burn debug erase clean test

all:$(C_OBJ_FILES) $(PROJECT).elf $(PROJECT).hex $(PROJECT).bin 
	$(SIZE) $(PROJECT).elf

%.o:%.c
	$(CC) $(C_INC_FILES) $(FLAGS_C) $< -o $@ 
%.o:%.s
	$(AS) $(FLAGS_AS) $< -o $@
%.elf:$(C_OBJ_FILES)
	$(CC) $(C_OBJ_FILES) $(FLAGS_LD) -o $@
%.hex:%.elf
	$(HEX) $< $@
%.bin:%.elf
	$(BIN) $< $@

################################################################################

load:$(TYPE_LOAD)
burn:$(TYPE_BURN)
debug:$(TYPE_DEBUG)
erase:$(TYPE_ERASE)

openocd_load:
	openocd -f /usr/share/openocd/scripts/interface/$(DebugTool).cfg \
	-f /usr/share/openocd/scripts/target/$(TargetSeriesMCU).cfg  -c "transport select hla_swd" \

openocd_swd_flash:$(PROJECT).bin
	$(GDB) \
	-ex 'target remote localhost:3333' \
	-ex 'monitor reset init' -ex 'monitor reset halt' \
	-ex 'monitor sleep 100' -ex 'monitor wait_halt 2' \
	-ex 'monitor flash write_image erase $(PROJECT).bin 0x08000000' \
	-ex 'monitor sleep 100' -ex 'monitor verify_image $(PROJECT).bin 0x08000000' \

openocd_swd_debug:$(PROJECT).bin
	$(GDB) \
	-ex 'target remote localhost:3333' \
	-ex 'monitor reset init' -ex 'monitor reset halt' \
	-ex 'monitor arm semihosting enable' \
	-ex 'load' \
	$(PROJECT).elf \



	
openocd_swd_erase:
	openocd -f /usr/share/openocd/scripts/interface/$(DebugTool).cfg \
	-f /usr/share/openocd/scripts/target/$(TargetSeriesMCU).cfg \
	-c "init" -c "reset halt" -c "sleep 100" -c "$(TargetSeriesMCU) mass_erase 0" \
	-c "sleep 100" -c "shutdown"



test:
#	@echo $(C_INC_FILES)
#	@echo $(C_OBJ_FILES)
#	@echo $(C_DPT_FILES)
	@echo $(C_ASM_FILES)

clean:
	-rm $(C_DPT_FILES)
	-rm $(C_OBJ_FILES)
	-rm $(PROJECT).elf
	-rm $(PROJECT).map
	-rm $(PROJECT).hex
	-rm $(PROJECT).bin





