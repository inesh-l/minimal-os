ASM=~/opt/i686-cross-compiler/bin/i686-elf-as
GCC=~/opt/i686-cross-compiler/bin/i686-elf-gcc
LD=~/opt/i686-cross-compiler/bin/i386-elf-ld

KERNEL_DIR=src/kernel
GRUB_DIR=src/grub

BUILD_DIR=build

all: os.iso

os.iso: $(BUILD_DIR)/os.bin $(GRUB_DIR)/grub.cfg 
	mkdir isodir/boot/grub -p
	cp $(GRUB_DIR)/grub.cfg isodir/boot/grub/grub.cfg
	cp $(BUILD_DIR)/os.bin isodir/boot/os.bin
	grub-mkrescue -o os.iso isodir

$(BUILD_DIR)/os.bin: $(KERNEL_DIR)/kernel.c $(KERNEL_DIR)/boot.s $(KERNEL_DIR)/linker.ld build_folder
	$(ASM) $(KERNEL_DIR)/boot.s -o $(BUILD_DIR)/boot.o
	$(GCC) -c $(KERNEL_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	$(GCC) -T $(KERNEL_DIR)/linker.ld -o $(BUILD_DIR)/os.bin -ffreestanding -O2 -nostdlib $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o -lgcc

build_folder:
	mkdir -p build

clean:
	rm -rf $(BUILD_DIR) os.iso
