# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	palindrome
	.ent	palindrome
palindrome:
	.frame $fp, 48, ra
	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 48
    
	.cprestore 32
	sw	ra, 44(sp)
	sw	$fp, 40(sp)
	sw	gp, 36(sp)

    sw  a0, 0(sp)
    sw  a1, 4(sp)
    sw  a2, 8(sp)
    sw  a3, 12(sp)

    move	$fp, sp

prog:
    li	v0, SYS_read # ver dentro de <sys/syscall.h>.
	li	a0, 0        # a0: file descriptor number.
	la	a1, 28(sp)   # a1: data pointer.
	li	a2, 1        # a2: available space.
	syscall
    
    li	v0, SYS_write # ver dentro de <sys/syscall.h>.
	lw  a0, 8(sp)         # a0: file descriptor number.
	la	a1, 28(sp)    # a1: output data pointer.
	li	a2, 1         # a2: output byte size.
	syscall

    li  t0, 10
    sw  t0, 52(sp)
    
    li	v0, SYS_write # ver dentro de <sys/syscall.h>.
	lw  a0, 8(sp)     # a0: file descriptor number.
	la	a1, 52(sp)    # a1: output data pointer.
	li	a2, 1         # a2: output byte size.
	syscall


    

palindrome_return:
    move    v0, t0
	move	sp, $fp
	lw	    ra, 44(sp)
	lw	    $fp, 40(sp)
	addu	sp, sp, 48
	j	    ra
	.end	palindrome
    
    
