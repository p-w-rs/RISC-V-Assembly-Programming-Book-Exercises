# [Debugging a program](https://riscv-programming.org/ale-exercise-book/book/ch02-03-debugging-a-program.html#debugging-a-program)

This exercise requires students to use the ALE simulator interactive commands to inspect the contents of registers and memory locations of a running program.

### [Instructions](https://riscv-programming.org/ale-exercise-book/book/ch02-03-debugging-a-program.html#instructions)

In this exercise, you must modify the code below with your academic record (RA) number, assemble and link the code, and run it step by step in the simulator's interactive mode, as explained in the previous sections.

```riscvasm
.globl _start

_start:
  li a0, 134985  #<<<=== Academic Record number (RA)
  li a1, 0
  li a2, 0
  li a3, -1
loop:
  andi t0, a0, 1
  add  a1, a1, t0
  xor  a2, a2, t0
  addi a3, a3, 1
  srli a0, a0, 1
  bnez a0, loop

end:
  la a0, result
  sw a1, 0(a0)
  li a0, 0
  li a7, 93
  ecall

result:
  .word 0
```

This program receives as input the value of its RA in register a0 and produces as output the values in registers a1, a2, and a3. Assume the program has received your RA as input and answer the following questions:

1. What are the values of the following registers in hexadecimal representation when the execution reaches the "end" label?

   -  a0: 0x00000000
   -  a1: 0x00000008
   -  a2: 0x00000000
   -  a3: 0x00000011

2. What are the values of the following registers in hexadecimal representation when the execution reaches the “loop” label for the fifth time?

   -  a0: 0x000020f4
   -  a1: 0x00000002
   -  a2: 0x00000000
   -  a3: 0x00000003

3. What are the values of the following registers in hexadecimal representation after the simulator executes the first 25 instructions?

   -  a0: 0x000020f4
   -  a1: 0x00000002
   -  a2: 0x00000000
   -  a3: 0x00000003

4. What are the values of the following registers in hexadecimal representation when the execution reaches the “loop” label for the eighth time?

   -  a0: 0x0000041e
   -  a1: 0x00000003
   -  a2: 0x00000001
   -  a3: 0x00000006

5. What are the values of the following registers in hexadecimal representation after the simulator executes the first 30 instructions?

   -  a0: 0x000020f4
   -  a1: 0x00000002
   -  a2: 0x00000000
   -  a3: 0x00000003

6. What are the values of the following registers in hexadecimal representation when the contents of a1 and a2 are different from 0 and have the same value?

   -  a0: ?
   -  a3: ?

7. What value (in hexadecimal representation) is stored at the "result" memory location after the execution of instruction sw a1, 0(a0) (located after the "end" label)?

   0x00000517



BTW this was a complete and udder waste of time especially if I was actually new to programming and assembly. Even somewhat familiar as I am, I want to learn assembly, so having me debug a program when I have no idea what it does or have any notion of what these assembly commands mean is a complete waste of time and poor design for the book and the exercises.

### Debugging Commands Used

```bash
>>> symbols
_start 0x110b4
result 0x110f8
loop 0x110c8
end 0x110e0

>>> until 0x110c8
#1 0 000110b4 00021537 r 0a         00021000  lui      x10, 0x21
#2 0 000110b8 f4950513 r 0a         00020f49  addi     x10, x10, -0xb7
#3 0 000110bc 00000593 r 0b         00000000  addi     x11, x0, 0x0
#4 0 000110c0 00000613 r 0c         00000000  addi     x12, x0, 0x0
#5 0 000110c4 fff00693 r 0d         ffffffff  addi     x13, x0, -0x1

>>> peek r a0
0x00020f49
>>> peek r a1
0x00000000
>>> peek r a2
0x00000000
>>> peek r a3
0xffffffff

### loop iter 1
>>> step 1
#6 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
>>> until 0x110c8
#7 0 000110cc 005585b3 r 0b         00000001  add      x11, x11, x5
#8 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#9 0 000110d4 00168693 r 0d         00000000  addi     x13, x13, 0x1
#10 0 000110d8 00155513 r 0a         000107a4  srli     x10, x10, 0x1
#11 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### loop iter 2
>>> step 1
#12 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
>>> until 0x110c8
#13 0 000110cc 005585b3 r 0b         00000001  add      x11, x11, x5
#14 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#15 0 000110d4 00168693 r 0d         00000001  addi     x13, x13, 0x1
#16 0 000110d8 00155513 r 0a         000083d2  srli     x10, x10, 0x1
#17 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### loop iter 3
>>> step 1
#18 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
>>> until 0x110c8
#19 0 000110cc 005585b3 r 0b         00000001  add      x11, x11, x5
#20 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#21 0 000110d4 00168693 r 0d         00000002  addi     x13, x13, 0x1
#22 0 000110d8 00155513 r 0a         000041e9  srli     x10, x10, 0x1
#23 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### loop iter 4
>>> step 1
#24 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
>>> until 0x110c8
#25 0 000110cc 005585b3 r 0b         00000002  add      x11, x11, x5
#26 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#27 0 000110d4 00168693 r 0d         00000003  addi     x13, x13, 0x1
#28 0 000110d8 00155513 r 0a         000020f4  srli     x10, x10, 0x1
#29 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### We've reached the loop label for the fifth time.
>>> peek r a0
0x000020f4
>>> peek r a1
0x00000002
>>> peek r a2
0x00000000
>>> peek r a3
0x00000003

>>> step 1
#30 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
>>> peek r a0
0x000020f4
>>> peek r a1
0x00000002
>>> peek r a2
0x00000000
>>> peek r a3
0x00000003

>>> step 1
#31 0 000110cc 005585b3 r 0b         00000002  add      x11, x11, x5
>>> peek r a0
0x000020f4
>>> peek r a1
0x00000002
>>> peek r a2
0x00000000
>>> peek r a3
0x00000003

### loop iter 5
until 0x110c8
#32 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#33 0 000110d4 00168693 r 0d         00000004  addi     x13, x13, 0x1
#34 0 000110d8 00155513 r 0a         0000107a  srli     x10, x10, 0x1
#35 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### loop iter 6
>>> step 1
#36 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
>>> until 0x110c8
#37 0 000110cc 005585b3 r 0b         00000002  add      x11, x11, x5
#38 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#39 0 000110d4 00168693 r 0d         00000005  addi     x13, x13, 0x1
#40 0 000110d8 00155513 r 0a         0000083d  srli     x10, x10, 0x1
#41 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### loop iter 7
>>> step 1
#42 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
>>> until 0x110c8
#43 0 000110cc 005585b3 r 0b         00000003  add      x11, x11, x5
#44 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#45 0 000110d4 00168693 r 0d         00000006  addi     x13, x13, 0x1
#46 0 000110d8 00155513 r 0a         0000041e  srli     x10, x10, 0x1
#47 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14

### We've reached the loop label for the eighth time.
>>> peek r a0
0x0000041e
>>> peek r a1
0x00000003
>>> peek r a2
0x00000001
>>> peek r a3
0x00000006

>>> until 0x110f8
#6 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#7 0 000110cc 005585b3 r 0b         00000001  add      x11, x11, x5
#8 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#9 0 000110d4 00168693 r 0d         00000000  addi     x13, x13, 0x1
#10 0 000110d8 00155513 r 0a         000107a4  srli     x10, x10, 0x1
#11 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#12 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#13 0 000110cc 005585b3 r 0b         00000001  add      x11, x11, x5
#14 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#15 0 000110d4 00168693 r 0d         00000001  addi     x13, x13, 0x1
#16 0 000110d8 00155513 r 0a         000083d2  srli     x10, x10, 0x1
#17 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#18 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#19 0 000110cc 005585b3 r 0b         00000001  add      x11, x11, x5
#20 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#21 0 000110d4 00168693 r 0d         00000002  addi     x13, x13, 0x1
#22 0 000110d8 00155513 r 0a         000041e9  srli     x10, x10, 0x1
#23 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#24 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#25 0 000110cc 005585b3 r 0b         00000002  add      x11, x11, x5
#26 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#27 0 000110d4 00168693 r 0d         00000003  addi     x13, x13, 0x1
#28 0 000110d8 00155513 r 0a         000020f4  srli     x10, x10, 0x1
#29 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#30 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#31 0 000110cc 005585b3 r 0b         00000002  add      x11, x11, x5
#32 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#33 0 000110d4 00168693 r 0d         00000004  addi     x13, x13, 0x1
#34 0 000110d8 00155513 r 0a         0000107a  srli     x10, x10, 0x1
#35 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#36 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#37 0 000110cc 005585b3 r 0b         00000002  add      x11, x11, x5
#38 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#39 0 000110d4 00168693 r 0d         00000005  addi     x13, x13, 0x1
#40 0 000110d8 00155513 r 0a         0000083d  srli     x10, x10, 0x1
#41 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#42 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#43 0 000110cc 005585b3 r 0b         00000003  add      x11, x11, x5
#44 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#45 0 000110d4 00168693 r 0d         00000006  addi     x13, x13, 0x1
#46 0 000110d8 00155513 r 0a         0000041e  srli     x10, x10, 0x1
#47 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#48 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#49 0 000110cc 005585b3 r 0b         00000003  add      x11, x11, x5
#50 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#51 0 000110d4 00168693 r 0d         00000007  addi     x13, x13, 0x1
#52 0 000110d8 00155513 r 0a         0000020f  srli     x10, x10, 0x1
#53 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#54 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#55 0 000110cc 005585b3 r 0b         00000004  add      x11, x11, x5
#56 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#57 0 000110d4 00168693 r 0d         00000008  addi     x13, x13, 0x1
#58 0 000110d8 00155513 r 0a         00000107  srli     x10, x10, 0x1
#59 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#60 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#61 0 000110cc 005585b3 r 0b         00000005  add      x11, x11, x5
#62 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#63 0 000110d4 00168693 r 0d         00000009  addi     x13, x13, 0x1
#64 0 000110d8 00155513 r 0a         00000083  srli     x10, x10, 0x1
#65 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#66 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#67 0 000110cc 005585b3 r 0b         00000006  add      x11, x11, x5
#68 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#69 0 000110d4 00168693 r 0d         0000000a  addi     x13, x13, 0x1
#70 0 000110d8 00155513 r 0a         00000041  srli     x10, x10, 0x1
#71 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#72 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#73 0 000110cc 005585b3 r 0b         00000007  add      x11, x11, x5
#74 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#75 0 000110d4 00168693 r 0d         0000000b  addi     x13, x13, 0x1
#76 0 000110d8 00155513 r 0a         00000020  srli     x10, x10, 0x1
#77 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#78 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#79 0 000110cc 005585b3 r 0b         00000007  add      x11, x11, x5
#80 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#81 0 000110d4 00168693 r 0d         0000000c  addi     x13, x13, 0x1
#82 0 000110d8 00155513 r 0a         00000010  srli     x10, x10, 0x1
#83 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#84 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#85 0 000110cc 005585b3 r 0b         00000007  add      x11, x11, x5
#86 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#87 0 000110d4 00168693 r 0d         0000000d  addi     x13, x13, 0x1
#88 0 000110d8 00155513 r 0a         00000008  srli     x10, x10, 0x1
#89 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#90 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#91 0 000110cc 005585b3 r 0b         00000007  add      x11, x11, x5
#92 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#93 0 000110d4 00168693 r 0d         0000000e  addi     x13, x13, 0x1
#94 0 000110d8 00155513 r 0a         00000004  srli     x10, x10, 0x1
#95 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#96 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#97 0 000110cc 005585b3 r 0b         00000007  add      x11, x11, x5
#98 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#99 0 000110d4 00168693 r 0d         0000000f  addi     x13, x13, 0x1
#100 0 000110d8 00155513 r 0a         00000002  srli     x10, x10, 0x1
#101 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#102 0 000110c8 00157293 r 05         00000000  andi     x5, x10, 0x1
#103 0 000110cc 005585b3 r 0b         00000007  add      x11, x11, x5
#104 0 000110d0 00564633 r 0c         00000001  xor      x12, x12, x5
#105 0 000110d4 00168693 r 0d         00000010  addi     x13, x13, 0x1
#106 0 000110d8 00155513 r 0a         00000001  srli     x10, x10, 0x1
#107 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#108 0 000110c8 00157293 r 05         00000001  andi     x5, x10, 0x1
#109 0 000110cc 005585b3 r 0b         00000008  add      x11, x11, x5
#110 0 000110d0 00564633 r 0c         00000000  xor      x12, x12, x5
#111 0 000110d4 00168693 r 0d         00000011  addi     x13, x13, 0x1
#112 0 000110d8 00155513 r 0a         00000000  srli     x10, x10, 0x1
#113 0 000110dc fe0516e3 r 00         00000000  bne      x10, x0, . - 0x14
#114 0 000110e0 00000517 r 0a         000110e0  auipc    x10, 0x0
#115 0 000110e4 01850513 r 0a         000110f8  addi     x10, x10, 0x18
#116 0 000110e8 00b52023 m 000110f8   00000008  sw       x11, 0x0(x10)
#117 0 000110ec 00000513 r 0a         00000000  addi     x10, x0, 0x0
#118 0 000110f0 05d00893 r 11         0000005d  addi     x17, x0, 0x5d
#119 0 000110f4 00000073 r 0a         00000000  ecall

>>> peek m 0x110e0
0x000110e0: 0x00000517
```

