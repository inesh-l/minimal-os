/* CONSTANTS */
.set MULTIBOOT_PAGE_ALIGN, 0x1   # Align boot modules on i386 boundaries (4KB)
.set MULTIBOOT_MEMORY_INFO, 0x2  # Pass memory info to OS
.set MULTIBOOT_FLAGS, MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO
.set MULTIBOOT_MAGIC_NUMBER, 0X1BADB002
.set MULTIBOOT_CHECKSUM, -(MULTIBOOT_MAGIC_NUMBER + MULTIBOOT_FLAGS)

/* MULTIBOOT HEADER */
.section .multiboot
.align 4
.long MULTIBOOT_MAGIC_NUMBER
.long MULTIBOOT_FLAGS
.long MULTIBOOT_CHECKSUM

/* STACK INITIALIZATION */
.section .bss
.align 16   # x86 standard stack alignment
stack_bottom:
.skip 16384 # 16 KiB
stack_top:  

/* KERNEL ENTRY */
.section .text
.global _start
.type _start, @function
_start: 
    # Initialize stack pointers
    mov $stack_top, %esp
    
    # Call kernel_entry()
    call kernel_entry

    cli
hang:  
    hlt
    jmp hang
.size _start, . - _start
