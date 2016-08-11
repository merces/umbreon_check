all:	
	nasm -f elf64 umbreon_check_64.asm
	ld -o umbreon_check_64 umbreon_check_64.o

clean:
	rm -f umbreon_check_64 umbreon_check_64.o
