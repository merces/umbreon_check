ARCH = $(shell uname -m)

all: 32 64

32:
	nasm -f elf32 umbreon_check_32.asm
	ld -m elf_i386 -o umbreon_check_32 umbreon_check_32.o

64:
	nasm -f elf64 umbreon_check_64.asm
	ld -m elf_x86_64 -o umbreon_check_64 umbreon_check_64.o

clean:
	rm -f umbreon_check_?? umbreon_check_*.o
