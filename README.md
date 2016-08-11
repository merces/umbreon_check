Umbreon rootkit check
=====================

These small programs are written in Assembly language and need NASM (http://www.nasm.us/) to compile.
As Umbreon rootkit hook almost all libc functions to hide itself, I created these programs that
directly call getdent() syscall in Linux systems so the presence of Umbreon root folder can be unveiled.

## Compile
      apt-get install nasm binutils grep
      make

## Usage
      ./umbreon_check | strings | grep ^libc

## How it works
