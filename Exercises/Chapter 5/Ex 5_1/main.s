	.file	"main.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	pack
	.type	pack, @function
pack:
	addi	sp,sp,-64
	sd	s0,56(sp)
	addi	s0,sp,64
	mv	a5,a0
	mv	a4,a2
	sd	a3,-56(s0)
	sw	a5,-36(s0)
	mv	a5,a1
	sw	a5,-40(s0)
	mv	a5,a4
	sw	a5,-44(s0)
	lw	a5,-44(s0)
	mv	a4,a5
	lw	a5,-40(s0)
	subw	a5,a4,a5
	sext.w	a5,a5
	addiw	a5,a5,1
	sext.w	a5,a5
	li	a4,1
	sllw	a5,a4,a5
	sext.w	a5,a5
	addiw	a5,a5,-1
	sw	a5,-20(s0)
	lw	a5,-36(s0)
	mv	a4,a5
	lw	a5,-20(s0)
	and	a5,a4,a5
	sext.w	a5,a5
	lw	a4,-40(s0)
	sllw	a5,a5,a4
	sw	a5,-24(s0)
	ld	a5,-56(s0)
	lw	a5,0(a5)
	lw	a4,-24(s0)
	or	a5,a5,a4
	sext.w	a4,a5
	ld	a5,-56(s0)
	sw	a4,0(a5)
	nop
	ld	s0,56(sp)
	addi	sp,sp,64
	jr	ra
	.size	pack, .-pack
	.align	1
	.globl	parse_number
	.type	parse_number, @function
parse_number:
	addi	sp,sp,-48
	sd	s0,40(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	sw	zero,-20(s0)
	li	a5,1
	sw	a5,-24(s0)
	ld	a5,-40(s0)
	lbu	a5,0(a5)
	mv	a4,a5
	li	a5,45
	bne	a4,a5,.L3
	li	a5,-1
	sw	a5,-24(s0)
	ld	a5,-40(s0)
	addi	a5,a5,1
	sd	a5,-40(s0)
	j	.L5
.L3:
	ld	a5,-40(s0)
	lbu	a5,0(a5)
	mv	a4,a5
	li	a5,43
	bne	a4,a5,.L5
	ld	a5,-40(s0)
	addi	a5,a5,1
	sd	a5,-40(s0)
	j	.L5
.L7:
	lw	a5,-20(s0)
	mv	a4,a5
	mv	a5,a4
	slliw	a5,a5,2
	addw	a5,a5,a4
	slliw	a5,a5,1
	sext.w	a4,a5
	ld	a5,-40(s0)
	lbu	a5,0(a5)
	sext.w	a5,a5
	addiw	a5,a5,-48
	sext.w	a5,a5
	addw	a5,a4,a5
	sw	a5,-20(s0)
	ld	a5,-40(s0)
	addi	a5,a5,1
	sd	a5,-40(s0)
.L5:
	ld	a5,-40(s0)
	lbu	a5,0(a5)
	mv	a4,a5
	li	a5,47
	bleu	a4,a5,.L6
	ld	a5,-40(s0)
	lbu	a5,0(a5)
	mv	a4,a5
	li	a5,57
	bleu	a4,a5,.L7
.L6:
	lw	a5,-24(s0)
	mv	a4,a5
	lw	a5,-20(s0)
	mulw	a5,a4,a5
	sext.w	a5,a5
	mv	a0,a5
	ld	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	parse_number, .-parse_number
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-96
	sd	ra,88(sp)
	sd	s0,80(sp)
	addi	s0,sp,96
	addi	a5,s0,-64
	li	a2,30
	mv	a1,a5
	li	a0,0
	call	read
	addi	a5,s0,-64
	sd	a5,-24(s0)
	sw	zero,-28(s0)
	j	.L10
.L11:
	ld	a0,-24(s0)
	call	parse_number
	mv	a5,a0
	mv	a4,a5
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a5,a5,-16
	add	a5,a5,s0
	sw	a4,-72(a5)
	ld	a5,-24(s0)
	addi	a5,a5,6
	sd	a5,-24(s0)
	lw	a5,-28(s0)
	addiw	a5,a5,1
	sw	a5,-28(s0)
.L10:
	lw	a5,-28(s0)
	sext.w	a4,a5
	li	a5,4
	ble	a4,a5,.L11
	sw	zero,-92(s0)
	lw	a5,-88(s0)
	addi	a4,s0,-92
	mv	a3,a4
	li	a2,2
	li	a1,0
	mv	a0,a5
	call	pack
	lw	a5,-84(s0)
	addi	a4,s0,-92
	mv	a3,a4
	li	a2,10
	li	a1,3
	mv	a0,a5
	call	pack
	lw	a5,-80(s0)
	addi	a4,s0,-92
	mv	a3,a4
	li	a2,15
	li	a1,11
	mv	a0,a5
	call	pack
	lw	a5,-76(s0)
	addi	a4,s0,-92
	mv	a3,a4
	li	a2,20
	li	a1,16
	mv	a0,a5
	call	pack
	lw	a5,-72(s0)
	addi	a4,s0,-92
	mv	a3,a4
	li	a2,31
	li	a1,21
	mv	a0,a5
	call	pack
	lw	a5,-92(s0)
	mv	a0,a5
	call	hex_code
	li	a5,0
	mv	a0,a5
	ld	ra,88(sp)
	ld	s0,80(sp)
	addi	sp,sp,96
	jr	ra
	.size	main, .-main
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
# 58 "main.c" 1
	mv a0, a4           # file descriptor
mv a1, a5           # buffer 
mv a2, a3           # size 
li a7, 63           # syscall write code (63) 
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
# 71 "main.c" 1
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
	.align	1
	.globl	hex_code
	.type	hex_code, @function
hex_code:
	addi	sp,sp,-64
	sd	ra,56(sp)
	sd	s0,48(sp)
	addi	s0,sp,64
	mv	a5,a0
	sw	a5,-52(s0)
	lw	a5,-52(s0)
	sw	a5,-20(s0)
	li	a5,48
	sb	a5,-40(s0)
	li	a5,120
	sb	a5,-39(s0)
	li	a5,10
	sb	a5,-30(s0)
	li	a5,9
	sw	a5,-24(s0)
	j	.L17
.L20:
	lw	a5,-20(s0)
	andi	a5,a5,15
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	sext.w	a4,a5
	li	a5,9
	bleu	a4,a5,.L18
	lw	a5,-28(s0)
	andi	a5,a5,0xff
	addiw	a5,a5,55
	andi	a4,a5,0xff
	lw	a5,-24(s0)
	addi	a5,a5,-16
	add	a5,a5,s0
	sb	a4,-24(a5)
	j	.L19
.L18:
	lw	a5,-28(s0)
	andi	a5,a5,0xff
	addiw	a5,a5,48
	andi	a4,a5,0xff
	lw	a5,-24(s0)
	addi	a5,a5,-16
	add	a5,a5,s0
	sb	a4,-24(a5)
.L19:
	lw	a5,-20(s0)
	srliw	a5,a5,4
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addiw	a5,a5,-1
	sw	a5,-24(s0)
.L17:
	lw	a5,-24(s0)
	sext.w	a4,a5
	li	a5,1
	bgt	a4,a5,.L20
	addi	a5,s0,-40
	li	a2,11
	mv	a1,a5
	li	a0,1
	call	write
	nop
	ld	ra,56(sp)
	ld	s0,48(sp)
	addi	sp,sp,64
	jr	ra
	.size	hex_code, .-hex_code
	.align	1
	.globl	exit
	.type	exit, @function
exit:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
 #APP
# 101 "main.c" 1
	mv a0, a5           # return code
li a7, 93           # syscall exit (64) 
ecall
# 0 "" 2
 #NO_APP
	nop
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	exit, .-exit
	.align	1
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	call	main
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	mv	a0,a5
	call	exit
	.size	_start, .-_start
	.ident	"GCC: (gc891d8dc2) 13.2.0"
