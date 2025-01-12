BUILD_DIR = build
ENTRY_POINT = 0xc0001500
target_floppy = disk.img
AS = nasm
CC = gcc
LD = ld
LIB = -I include
ASFLAGS = -f elf
ASIB = -I include/
CFLAGS = -Wall -m32 -fno-stack-protector $(LIB) -c -fno-builtin -W -Wstrict-prototypes -Wmissing-prototypes -w
LDFLAGS = -m elf_i386 -Ttext $(ENTRY_POINT) -e main -Map $(BUILD_DIR)/kernel.map
OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/entry.o $(BUILD_DIR)/printk.o $(BUILD_DIR)/string.o \
	$(BUILD_DIR)/vga_basic.o $(BUILD_DIR)/port.o $(BUILD_DIR)/timer.o $(BUILD_DIR)/debug.o \
	$(BUILD_DIR)/init.o $(BUILD_DIR)/interrupt.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/bitmap.o \
	$(BUILD_DIR)/memory.o $(BUILD_DIR)/thread.o $(BUILD_DIR)/list.o $(BUILD_DIR)/switch.o \
	$(BUILD_DIR)/print.o $(BUILD_DIR)/sync.o $(BUILD_DIR)/console.o $(BUILD_DIR)/keyboard.o \
	$(BUILD_DIR)/ioqueue.o

# C代码编译
$(BUILD_DIR)/entry.o: boot/entry.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/port.o: libs/port.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/printk.o: libs/printk.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/string.o: libs/string.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/vga_basic.o: libs/vga_basic.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/main.o: kernel/main.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/init.o: kernel/init.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/interrupt.o: kernel/interrupt.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/timer.o: device/timer.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/debug.o: kernel/debug.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/bitmap.o: kernel/bitmap.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/memory.o: kernel/memory.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/thread.o: kernel/thread/thread.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/list.o: include/kernel/list.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/sync.o: kernel/thread/sync.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/console.o: device/console.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/keyboard.o: device/keyboard.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/ioqueue.o: device/ioqueue.c
	$(CC) $(CFLAGS) $< -o $@

# 编译loader和mbr
$(BUILD_DIR)/mbr.bin: mbr/mbr.S
	$(AS) $(ASIB) $< -o $@

$(BUILD_DIR)/loader.bin: mbr/loader.S
	$(AS) $(ASIB) $< -o $@

# 编译汇编

$(BUILD_DIR)/kernel.o: kernel/kernel.S 
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/switch.o: kernel/switch.S
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/print.o: kernel/print.S
	$(AS) $(ASFLAGS) $< -o $@

# $(BUILD_DIR)/print.o: lib/kernel/print.asm
# 	$(AS) $(ASFLAGS) $< -o $@

# 链接
$(BUILD_DIR)/kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

.PHONY: mk_dir hd clean all ab mkbochs

mk_dir:
	if [ ! -d $(BUILD_DIR) ]; then mkdir $(BUILD_DIR); fi
	qemu-img create -f qcow2 -o preallocation=metadata disk.img 4M
	echo "Create image done."

mkbochs:
	if [ ! -d $(BUILD_DIR) ]; then mkdir $(BUILD_DIR); fi
	rm disk.img
	bximage -hd=10M -mode="create" -q disk.img

hd:
	dd if=$(BUILD_DIR)/mbr.bin of=disk.img bs=512 count=1 conv=notrunc
	dd if=$(BUILD_DIR)/loader.bin of=disk.img bs=512 count=4 seek=2 conv=notrunc
	dd if=$(BUILD_DIR)/kernel.bin of=disk.img bs=512 count=200 seek=9 conv=notrunc

clean:
	rm -rf disk.img $(BUILD_DIR)

.PHONY:runqemu
runqemu:
	qemu -drive file=$(target_floppy),format=raw,media=disk -boot c -m 256 --no-reboot

.PHONY:run
run:
	bochs -f bochsrc

build: $(BUILD_DIR)/mbr.bin $(BUILD_DIR)/loader.bin $(BUILD_DIR)/kernel.bin

allqemu: mk_dir build hd

all: mkbochs build hd