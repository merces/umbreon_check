;
; umbreon_check checks for the presence of Umbreon rootkit hidden folder by
; calling getdents() syscall to list the content of /usr/lib directory
;
; Common usage: ./umbreon_check | strings | grep ^libc
;
; Author: Fernando Merces, FTR, Trend Micro
;
; x86 Linux syscall args order: eax, ebx, ecx, edx, esi, edi - https://w3challs.com/syscalls/?arch=x86

BITS 32

%define O_RDONLY 00
%define O_NONBLOCK 04000
%define O_DIRECTORY 0200000
%define O_CLOEXEC 02000000

%define stdout 1

%define sys_write 4
%define sys_open 5
%define sys_exit 1
%define sys_getdents 141

	section .data
path: db "/usr/lib/", 0

	section .text
global _start
_start:
	; int open(const char *pathname, int flags, mode_t mode);
	mov edx, (O_NONBLOCK | O_DIRECTORY | O_CLOEXEC)
	mov ecx, O_RDONLY
	mov ebx, path
	mov eax, sys_open
	int 0x80

	; int getdents(unsigned int fd, struct linux_dirent *dirp, unsigned int count);
	mov edx, 32768
	sub esp, edx ; alloca()
	mov ecx, esp 
	mov ebx, eax 		
	mov eax, sys_getdents
	int 0x80

	; int write(int fd, const void *buf, size_t count);
	; edx (count) is still 32768
	mov ecx, esp
	;add ecx, 18 ; d_name offset
	mov ebx, stdout
	mov eax, sys_write
	int 0x80

exit:
	; void exit(int status);
	mov ebx, 0
	mov eax, sys_exit
	int 0x80
