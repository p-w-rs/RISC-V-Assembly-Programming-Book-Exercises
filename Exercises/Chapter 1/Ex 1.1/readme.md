# [Section 1.1 - Code Generation Tools](https://riscv-programming.org/ale-exercise-book/book/ch01-01-code-generation-tools.html#instructions)

Perform the following program compilation process step-by-step, i.e., generating the assembly language code and then the object code for each source file and finally calling the linker to put all the object files together and produce the executable file named prog.x.

[file1.c](./file1.c)

```c
extern void write(int __fd, const void *__buf, int __n);

int main(void) {
  const char str[] = "Hello World!\n";
  write(1, str, 13);
  return 0;
}
```

[file2.c](./file2.c)

```c
extern int main(void);

void exit(int code) {
  __asm__ __volatile__("mv a0, %0           # return code\n"
                       "li a7, 93           # syscall exit (64) \n"
                       "ecall"
                       :           // Output list
                       : "r"(code) // Input list
                       : "a0", "a7");
}

void write(int __fd, const void *__buf, int __n) {
  __asm__ __volatile__("mv a0, %0           # file descriptor\n"
                       "mv a1, %1           # buffer \n"
                       "mv a2, %2           # size \n"
                       "li a7, 64           # syscall write (64) \n"
                       "ecall"
                       :                                 // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
}

void _start() {
  int ret_code = main();
  exit(ret_code);
}
```

1.  Compile the C code to RISC-V asm

```bash
riscv64-unknown-elf-gcc file1.c -S -o file1.s
riscv64-unknown-elf-gcc file2.c -S -o file2.s
```

2.  Compile asm to object file

```bash
riscv64-unknown-elf-as file1.s -c -o file1.o
riscv64-unknown-elf-as file2.s -c -o file2.o
```

3.  Show objdump of object files

file1.o

```bash
riscv64-unknown-elf-objdump -D file1.o

file1.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	add	s0,sp,32
   8:	000007b7          	lui	a5,0x0
   c:	00078793          	mv	a5,a5
  10:	6398                	ld	a4,0(a5)
  12:	fee43023          	sd	a4,-32(s0)
  16:	4798                	lw	a4,8(a5)
  18:	fee42423          	sw	a4,-24(s0)
  1c:	00c7d783          	lhu	a5,12(a5) # c <main+0xc>
  20:	fef41623          	sh	a5,-20(s0)
  24:	fe040793          	add	a5,s0,-32
  28:	4635                	li	a2,13
  2a:	85be                	mv	a1,a5
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	000080e7          	jalr	ra # 2e <main+0x2e>
  36:	4781                	li	a5,0
  38:	853e                	mv	a0,a5
  3a:	60e2                	ld	ra,24(sp)
  3c:	6442                	ld	s0,16(sp)
  3e:	6105                	add	sp,sp,32
  40:	8082                	ret
	...

Disassembly of section .rodata:

0000000000000000 <.LC0>:
   0:	6548                	ld	a0,136(a0)
   2:	6c6c                	ld	a1,216(s0)
   4:	6f57206f          	j	72ef8 <.LC0+0x72ef8>
   8:	6c72                	ld	s8,280(sp)
   a:	2164                	fld	fs1,192(a0)
   c:	000a                	c.slli	zero,0x2

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	4700                	lw	s0,8(a4)
   2:	203a4343          	fmadd.s	ft6,fs4,ft3,ft4,rmm
   6:	6728                	ld	a0,72(a4)
   8:	31393863          	.insn	4, 0x31393863
   c:	3864                	fld	fs1,240(s0)
   e:	6364                	ld	s1,192(a4)
  10:	2932                	fld	fs2,264(sp)
  12:	3120                	fld	fs0,96(a0)
  14:	2e322e33          	.insn	4, 0x2e322e33
  18:	0030                	add	a2,sp,8

Disassembly of section .riscv.attributes:

0000000000000000 <.riscv.attributes>:
   0:	4641                	li	a2,16
   2:	0000                	unimp
   4:	7200                	ld	s0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <.riscv.attributes+0x14>
   c:	003c                	add	a5,sp,8
   e:	0000                	unimp
  10:	1004                	add	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3676                	fld	fa2,376(sp)
  16:	6934                	ld	a3,80(a0)
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	li	t5,-20
  1c:	326d                	addw	tp,tp,-5 # fffffffffffe0ffb <main+0xfffffffffffe0ffb>
  1e:	3070                	fld	fa2,224(s0)
  20:	615f 7032 5f31      	.insn	6, 0x5f317032615f
  26:	3266                	fld	ft4,120(sp)
  28:	3270                	fld	fa2,224(a2)
  2a:	645f 7032 5f32      	.insn	6, 0x5f327032645f
  30:	30703263          	.insn	4, 0x30703263
  34:	7a5f 6369 7273      	.insn	6, 0x727363697a5f
  3a:	7032                	.insn	2, 0x7032
  3c:	5f30                	lw	a2,120(a4)
  3e:	6d7a                	ld	s10,408(sp)
  40:	756d                	lui	a0,0xffffb
  42:	316c                	fld	fa1,224(a0)
  44:	3070                	fld	fa2,224(s0)
	...
```

file2.o

```bash
riscv64-unknown-elf-objdump -D file2.o

file2.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <exit>:
   0:	1101                	add	sp,sp,-32
   2:	ec22                	sd	s0,24(sp)
   4:	1000                	add	s0,sp,32
   6:	87aa                	mv	a5,a0
   8:	fef42623          	sw	a5,-20(s0)
   c:	fec42783          	lw	a5,-20(s0)
  10:	853e                	mv	a0,a5
  12:	05d00893          	li	a7,93
  16:	00000073          	ecall
  1a:	0001                	nop
  1c:	6462                	ld	s0,24(sp)
  1e:	6105                	add	sp,sp,32
  20:	8082                	ret

0000000000000022 <write>:
  22:	1101                	add	sp,sp,-32
  24:	ec22                	sd	s0,24(sp)
  26:	1000                	add	s0,sp,32
  28:	87aa                	mv	a5,a0
  2a:	feb43023          	sd	a1,-32(s0)
  2e:	8732                	mv	a4,a2
  30:	fef42623          	sw	a5,-20(s0)
  34:	87ba                	mv	a5,a4
  36:	fef42423          	sw	a5,-24(s0)
  3a:	fec42783          	lw	a5,-20(s0)
  3e:	873e                	mv	a4,a5
  40:	fe043783          	ld	a5,-32(s0)
  44:	fe842683          	lw	a3,-24(s0)
  48:	853a                	mv	a0,a4
  4a:	85be                	mv	a1,a5
  4c:	8636                	mv	a2,a3
  4e:	04000893          	li	a7,64
  52:	00000073          	ecall
  56:	0001                	nop
  58:	6462                	ld	s0,24(sp)
  5a:	6105                	add	sp,sp,32
  5c:	8082                	ret

000000000000005e <_start>:
  5e:	1101                	add	sp,sp,-32
  60:	ec06                	sd	ra,24(sp)
  62:	e822                	sd	s0,16(sp)
  64:	1000                	add	s0,sp,32
  66:	00000097          	auipc	ra,0x0
  6a:	000080e7          	jalr	ra # 66 <_start+0x8>
  6e:	87aa                	mv	a5,a0
  70:	fef42623          	sw	a5,-20(s0)
  74:	fec42783          	lw	a5,-20(s0)
  78:	853e                	mv	a0,a5
  7a:	00000097          	auipc	ra,0x0
  7e:	000080e7          	jalr	ra # 7a <_start+0x1c>
	...

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	4700                	lw	s0,8(a4)
   2:	203a4343          	fmadd.s	ft6,fs4,ft3,ft4,rmm
   6:	6728                	ld	a0,72(a4)
   8:	31393863          	.insn	4, 0x31393863
   c:	3864                	fld	fs1,240(s0)
   e:	6364                	ld	s1,192(a4)
  10:	2932                	fld	fs2,264(sp)
  12:	3120                	fld	fs0,96(a0)
  14:	2e322e33          	.insn	4, 0x2e322e33
  18:	0030                	add	a2,sp,8

Disassembly of section .riscv.attributes:

0000000000000000 <.riscv.attributes>:
   0:	4641                	li	a2,16
   2:	0000                	unimp
   4:	7200                	ld	s0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <.riscv.attributes+0x14>
   c:	003c                	add	a5,sp,8
   e:	0000                	unimp
  10:	1004                	add	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3676                	fld	fa2,376(sp)
  16:	6934                	ld	a3,80(a0)
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	li	t5,-20
  1c:	326d                	addw	tp,tp,-5 # fffffffffffe0ffb <_start+0xfffffffffffe0f9d>
  1e:	3070                	fld	fa2,224(s0)
  20:	615f 7032 5f31      	.insn	6, 0x5f317032615f
  26:	3266                	fld	ft4,120(sp)
  28:	3270                	fld	fa2,224(a2)
  2a:	645f 7032 5f32      	.insn	6, 0x5f327032645f
  30:	30703263          	.insn	4, 0x30703263
  34:	7a5f 6369 7273      	.insn	6, 0x727363697a5f
  3a:	7032                	.insn	2, 0x7032
  3c:	5f30                	lw	a2,120(a4)
  3e:	6d7a                	ld	s10,408(sp)
  40:	756d                	lui	a0,0xffffb
  42:	316c                	fld	fa1,224(a0)
  44:	3070                	fld	fa2,224(s0)
	...
```

4.  Link object files together to create executable

```bash
riscv64-unknown-elf-ld file1.o file2.o -o prog.x
```

5.  Upload executable file to the [RISC-V ALE](https://riscv-programming.org/ale/) and run file

```bash
Welcome to RISC-V ALE
$ whisper /prog.x --newlib --setreg sp=0x7FFFFFC --isa acdfimsu
Hello World!
Target program exited with code 0
User stop
Retired 64 instructions in 0.00s  32000 inst/s
```

