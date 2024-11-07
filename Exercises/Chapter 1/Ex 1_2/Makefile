gcc=riscv64-unknown-elf-gcc
as=riscv64-unknown-elf-as
ld=riscv64-unknown-elf-ld

prog.x : file1.o file2.o
	$(ld) -o prog.x file1.o file2.o

file1.o : file1.s
	$(as) -c -o file1.o file1.s

file2.o : file2.s
	$(as) -c -o file2.o file2.s

file1.s : file1.c
	$(gcc) -S -o file1.s file1.c

file2.s : file2.c
	$(gcc) -S -o file2.s file2.c

.PHONY : clean
clean:
	rm -f *.o *.s *.x
