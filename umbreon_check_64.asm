;
; umbreon_check checks for the presence of Umbreon rootkit hidden folder by
; calling getdents() syscall to list the content of /usr/lib directory
;
; Common usage: ./umbreon_check | strings | grep ^libc
;
; Author: Fernando Merces, FTR, Trend Micro
;
; x86-64 Linux syscall args order: rdi, rsi, rdx, rcx - ref: https://w3challs.com/syscalls/?arch=x86_64

BITS 64

%define O_RDONLY 00
%define O_NONBLOCK 04000
%define O_DIRECTORY 0200000
%define O_CLOEXEC 02000000

%define stdout 1

%define sys_write 1
%define sys_open 2
%define sys_exit 60
%define sys_getdents 78

	section .data
path: db "/usr/lib/", 0

	section .text
global _start
_start:
	; int open(const char *pathname, int flags, mode_t mode);
	mov rdx, (O_NONBLOCK | O_DIRECTORY | O_CLOEXEC)
	mov rsi, O_RDONLY
	mov rdi, path
	mov rax, sys_open
	syscall

	; int getdents(unsigned int fd, struct linux_dirent *dirp, unsigned int count);
	mov rdx, 32768
	sub rsp, rdx ; alloca()
	mov rsi, rsp 
	mov rdi, rax 		
	mov rax, sys_getdents
	syscall

	; int write(int fd, const void *buf, size_t count);
	; rdx (count) is still 32768
	mov rsi, rsp
	add rsi, 18 ; d_name offset
	mov rdi, stdout
	mov rax, sys_write
	syscall

exit:
	; void exit(int status);
	mov rdi, 0
	mov rax, sys_exit
	syscall
