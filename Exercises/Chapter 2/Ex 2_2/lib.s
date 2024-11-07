	.file	"lib.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	read
	.type	read, @function
read:
	addi	sp,sp,-48
	sd	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sd	a1,-48(s0)
	mv	a4,a2
	sw	a5,-36(s0)
	mv	a5,a4
	sw	a5,-40(s0)
	lw	a5,-36(s0)
	mv	a4,a5
	ld	a5,-48(s0)
	lw	a3,-40(s0)
 #APP
# 11 "lib.c" 1
	mv a0, a4           # file descriptor
mv a1, a5           # buffer 
mv a2, a3           # size 
li a7, 63           # syscall read code (63) 
ecall               # invoke syscall 
mv a5, a0           # move return value to ret_val

# 0 "" 2
 #NO_APP
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	mv	a0,a5
	ld	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	read, .-read
	.align	1
	.globl	write
	.type	write, @function
write:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sd	a1,-32(s0)
	mv	a4,a2
	sw	a5,-20(s0)
	mv	a5,a4
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	mv	a4,a5
	ld	a5,-32(s0)
	lw	a3,-24(s0)
 #APP
# 32 "lib.c" 1
	mv a0, a4           # file descriptor
mv a1, a5           # buffer 
mv a2, a3           # size 
li a7, 64           # syscall write (64) 
ecall
# 0 "" 2
 #NO_APP
	nop
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	write, .-write
	.ident	"GCC: (gc891d8dc2) 13.2.0"
