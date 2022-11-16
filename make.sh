#!/bin/bash
# This is a comment

FILE=build
if [ -d "$FILE" ]; then
    echo "$FILE exists."
else 
    mkdir build
fi

#riscv-nuclei-elf-as $1.S -o $1.o
#riscv-nuclei-elf-ld $1.o -o $1.elf
echo Compiling ...
#riscv-nuclei-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib $1.S GD32VF103x8.lds -o $1.elf
#riscv-nuclei-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib $1.S -o $1.elf
riscv64-unknown-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib -T GD32VF103x8.lds $1.S -o build/$1.elf
echo ELF to LST
riscv-nuclei-elf-objdump -S build/$1.elf > build/$1.lst
echo ELF to BIN
riscv-nuclei-elf-objcopy -O binary build/$1.elf build/$1.bin
echo ELF to LSS
riscv-nuclei-elf-objdump -D -S build/$1.elf > build/$1.lss
echo Flashing ...
#stm32flash /dev/ttyUSB0 -w main.bin
#stm32flash -v -g 0x08000000 /dev/ttyUSB0 -w $1.bin
stm32flash -v -g 0x0 /dev/ttyUSB0 -w build/$1.bin
echo Start ...

