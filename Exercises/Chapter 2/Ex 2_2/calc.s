	.file	"calc.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	input_buffer
	.bss
	.align	3
	.type	input_buffer, @object
	.size	input_buffer, 255
input_buffer:
	.zero	255
	.globl	output_buffer
	.section	.sbss,"aw",@nobits
	.align	3
	.type	output_buffer, @object
	.size	output_buffer, 2
output_buffer:
	.zero	2
	.text
	.align	1
	.globl	char_to_int
	.type	char_to_int, @function
char_to_int:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sb	a5,-17(s0)
	lbu	a5,-17(s0)
	sext.w	a5,a5
	addiw	a5,a5,-48
	sext.w	a5,a5
	mv	a0,a5
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	char_to_int, .-char_to_int
	.align	1
	.globl	int_to_char
	.type	int_to_char, @function
int_to_char:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	andi	a5,a5,0xff
	addiw	a5,a5,48
	andi	a5,a5,0xff
	mv	a0,a5
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	int_to_char, .-int_to_char
	.section	.rodata
	.align	3
.LC0:
	.string	"Invalid operation\n"
	.align	3
.LC1:
	.string	"Error reading input\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	li	a2,255
	lui	a5,%hi(input_buffer)
	addi	a1,a5,%lo(input_buffer)
	li	a0,0
	call	read
	mv	a5,a0
	sw	a5,-24(s0)
	lw	a5,-24(s0)
	sext.w	a5,a5
	ble	a5,zero,.L6
	lui	a5,%hi(input_buffer)
	addi	a5,a5,%lo(input_buffer)
	lbu	a5,0(a5)
	mv	a0,a5
	call	char_to_int
	mv	a5,a0
	sw	a5,-28(s0)
	lui	a5,%hi(input_buffer)
	addi	a5,a5,%lo(input_buffer)
	lbu	a5,4(a5)
	mv	a0,a5
	call	char_to_int
	mv	a5,a0
	sw	a5,-32(s0)
	lui	a5,%hi(input_buffer)
	addi	a5,a5,%lo(input_buffer)
	lbu	a5,2(a5)
	sb	a5,-33(s0)
	lbu	a5,-33(s0)
	sext.w	a5,a5
	mv	a3,a5
	li	a4,45
	beq	a3,a4,.L7
	mv	a3,a5
	li	a4,45
	bgt	a3,a4,.L8
	mv	a3,a5
	li	a4,42
	beq	a3,a4,.L9
	mv	a4,a5
	li	a5,43
	bne	a4,a5,.L8
	lw	a5,-28(s0)
	mv	a4,a5
	lw	a5,-32(s0)
	addw	a5,a4,a5
	sw	a5,-20(s0)
	j	.L10
.L7:
	lw	a5,-28(s0)
	mv	a4,a5
	lw	a5,-32(s0)
	subw	a5,a4,a5
	sw	a5,-20(s0)
	j	.L10
.L9:
	lw	a5,-28(s0)
	mv	a4,a5
	lw	a5,-32(s0)
	mulw	a5,a4,a5
	sw	a5,-20(s0)
	j	.L10
.L8:
	li	a2,18
	lui	a5,%hi(.LC0)
	addi	a1,a5,%lo(.LC0)
	li	a0,1
	call	write
	li	a5,1
	j	.L11
.L10:
	lw	a5,-20(s0)
	mv	a0,a5
	call	int_to_char
	mv	a5,a0
	mv	a4,a5
	lui	a5,%hi(output_buffer)
	sb	a4,%lo(output_buffer)(a5)
	lui	a5,%hi(output_buffer)
	addi	a5,a5,%lo(output_buffer)
	li	a4,10
	sb	a4,1(a5)
	li	a2,2
	lui	a5,%hi(output_buffer)
	addi	a1,a5,%lo(output_buffer)
	li	a0,1
	call	write
	j	.L12
.L6:
	li	a2,20
	lui	a5,%hi(.LC1)
	addi	a1,a5,%lo(.LC1)
	li	a0,1
	call	write
.L12:
	li	a5,0
.L11:
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc2) 13.2.0"
