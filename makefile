ASM=nasm
GCC_NATIVE=tools/i386-cross-compiler/bin/i386-elf-gcc
LD_NATIVE=tools/i386-cross-compiler/bin/i386-elf-ld

BOOT_DIR=src/boot
BASE_DIR=src/base

BUILD_DIR=build

$(BUILD_DIR)/os.img: $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/boot.bin
	cat $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/os.img
	truncate -s 1440k $(BUILD_DIR)/os.img;


$(BUILD_DIR)/kernel.bin: $(BASE_DIR)/kernel_entry.asm $(BASE_DIR)/kernel.c build_folder
	$(ASM) $(BASE_DIR)/kernel_entry.asm -f elf -o $(BUILD_DIR)/kernel_entry.o
	$(GCC_NATIVE) -ffreestanding -m32 -g -c $(BASE_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o
	$(LD_NATIVE) -Ttext 0x1000 $(BUILD_DIR)/kernel.o --oformat binary -o $(BUILD_DIR)/kernel.bin 

$(BUILD_DIR)/boot.bin: $(BOOT_DIR)/boot.asm build_folder
	$(ASM) $(BOOT_DIR)/boot.asm -f bin -o $(BUILD_DIR)/boot.bin

build_folder:
	mkdir -p build

# TOOLS:
cross-compiler:
	sh tools/setup-cross-compiler-arch.sh


clean:
	rm -rf $(BUILD_DIR)