# Compiladores e ferramentas
CC=avr-gcc
CXX=avr-g++
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
AVRDUDE=avrdude
SIZE=avr-size

# MCU alvo
MCU=atmega328p

# Configuração do avrdude (para Arduino Uno via serial bootloader)
PROGRAMMER=arduino
PORT=COM7
BAUD=115200

# Flags de compilação
CFLAGS=-mmcu=$(MCU) -Wall -Os -DF_CPU=16000000UL
CXXFLAGS=$(CFLAGS) -fno-exceptions -fno-rtti

# Nome do programa
TARGET=main

# Lista todos os arquivos .c e .cpp do diretório
SRC_C=$(wildcard *.c)
SRC_CPP=$(wildcard *.cpp)
SRC=$(SRC_C) $(SRC_CPP)

# Transforma todos os .c e .cpp em .o
OBJ=$(SRC_C:.c=.o) $(SRC_CPP:.cpp=.o)

# Local da libc (descoberto automaticamente)
LIBC=$(shell avr-gcc -print-file-name=libc.a)

# Regra padrão
all: $(TARGET).hex size flash

# Compila arquivos .c
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Compila arquivos .cpp
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Linka todos os objetos com a libc e gera o mapa
$(TARGET).elf: $(OBJ)
	$(CXX) $(CXXFLAGS) -Wl,-Map,$(TARGET).map -o $@ $^ -Wl,-u,vfprintf -lprintf_flt -lm

# Gera o arquivo .hex e o dump .lst
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@
	$(OBJDUMP) -d $< > $(TARGET).lst

# Mostra o tamanho do binário
size: $(TARGET).elf
	$(SIZE) $<

# Gera dump manualmente, se necessário
dump: $(TARGET).elf
	$(OBJDUMP) -d $< > $(TARGET).lst

# Grava o programa no microcontrolador
flash: $(TARGET).hex
	$(AVRDUDE) -c $(PROGRAMMER) -p $(MCU) -P $(PORT) -b $(BAUD) -U flash:w:$<

# Limpeza silenciosa
clean:
	@rm -f *.o *.elf *.hex *.lst *.map >nul 2>&1
