# [Section 1.2 - Automating the compilation process with Makefiles](https://riscv-programming.org/ale-exercise-book/book/ch01-02-code-generation-tools.html#automating-the-compilation-process-with-makefiles)

In this exercise, you must produce a Makefile script that automates the compilation process carried out manually in the [previous exercise](https://riscv-programming.org/ale-exercise-book/book/ch01-01-code-generation-tools.html), i.e., for a program that contains two source files (file1.c and file2.c). The final file to be produced must be named prog.x. For this, you must create a rule for each intermediate file, until you reach the final file.

---

```makefile
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
```

Just for the record, I think Makefiles are ultimately a bad idea because as you use more advanced concept and capabilities it begins to obfuscate how a project is actually being compiled. This is especially difficult if new files are to be added/changed and if the directory structure of the project changes.

I often find a bash script or even a python script to be more informative for compilation. If we are deciding to not be transparent I prefer something like [SCons](https://scons.org) and I detest tools like [CMake](https://cmake.org).
