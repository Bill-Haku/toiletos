# ToiletOS

**This is ToiletOS - an OS where all Apps can shits.**

## New Branch

- No GRUB Version

## Devlop log

### 0.0.1

Finish MBR: boot from 100 block on the hard disk

Finish basic Kernel: show the information and author

![image-20220511200149799](/Users/hakubill/Library/Application Support/typora-user-images/image-20220511200149799.png)

### 0.0.2

Finish kernel loader:  boot a loader to boot kernel with MBR

Add MakeFile for boot: easily compile source files and write into disk img

### 0.1

Boot into system with Grub

![image-20220512223913398](/Users/hakubill/Library/Application Support/typora-user-images/image-20220512223913398.png)

### 0.2

Implement kernel-level string output and color output

![image-20220516124354887](/Users/hakubill/Library/Application Support/typora-user-images/image-20220516124354887.png)

### 0.3.0

Move the emulator to Bochs as Qemu seems to be some problem when running Assembly codes, and each run gets a different result in Qemu.

### 0.3.1

Add support for Interrupt.

When interrupt occurs, a string will be printed.

### 0.3.2

Improve interrupt feature: print interrupt vector code.

### 0.3.3

Increase the frequency of PIT8253 to 100Hz.

### 0.3.4

Implement ASSERT.

### 0.3.5

Support common string functions.

Support common bitmap operations.

### 0.4

Implement memory management.

Adjust start infos.

![image-20220624210336363](/Users/hakubill/Library/Application Support/typora-user-images/image-20220624210336363.png)

### 0.4.1 

Implement basic thread management.

### 0.4.2

Improve thread management and error handler.

Test 2 thread exchange.

### 0.4.3

Implemet basic console output operations.

### 0.4.4

Implement keyboard input and output based on ioqueue.

![image-20220627095606477](/Users/hakubill/Library/Application Support/typora-user-images/image-20220627095606477.png)

### 0.4.5

Implement TSS and a basic user process management.
