CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

PROJECT_NAME = template

PROJECT_SRC = src
STM_SRC = Drivers/STM32F4xx_HAL_Driver/Src/

vpath %.c $(PROJECT_SRC)
vpath %.c $(STM_SRC)

SRCS = main.c

SRCS += Device/startup_stm32f401xe.s

SRCS += stm32f4xx_hal_msp.c
SRCS += stm32f4xx_it.c
SRCS += system_stm32f4xx.c

EXT_SRCS = stm32f4xx_hal.c
EXT_SRCS += stm32f4xx_hal_rcc.c
EXT_SRCS += stm32f4xx_hal_gpio.c
EXT_SRCS += stm32f4xx_hal_cortex.c

EXT_OBJ = $(EXT_SRCS:.c=.o)

INC_DIRS  = inc
INC_DIRS += Drivers/STM32F4xx_HAL_Driver/Inc/
INC_DIRS += Drivers/CMSIS/Device/ST/STM32F4xx/Include/
INC_DIRS += Drivers/CMSIS/Include/

INCLUDE = $(addprefix -I,$(INC_DIRS))

DEFS = -DSTM32F401xE

CFLAGS  = -ggdb -O0
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork -Wl,--gc-sections

WFLAGS += -Wall -Wextra -Warray-bounds

LFLAGS = -TDevice/gcc.ld

.PHONY: all
all: $(PROJECT_NAME)

.PHONY: $(PROJECT_NAME)
$(PROJECT_NAME): $(PROJECT_NAME).elf

$(PROJECT_NAME).elf: $(SRCS) $(EXT_OBJ)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(WFLAGS) $(LFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJECT_NAME).elf   $(PROJECT_NAME).hex
	$(OBJCOPY) -O binary $(PROJECT_NAME).elf $(PROJECT_NAME).bin

%.o: %.c
	$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^

clean:
	rm -f *.o $(PROJECT_NAME).elf $(PROJECT_NAME).hex $(PROJECT_NAME).bin
