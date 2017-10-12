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

    sw  a0, 0(sp)       #file_in
    sw  a1, 4(sp)       #ibuf
    sw  a2, 8(sp)       #file_out
    sw  a3, 12(sp)      #obuf

    move	$fp, sp

prog:
read:
    li	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw	a0, 0(sp)       # a0: file descriptor number.
	la	a1, 52(sp)      # a1: data pointer.
	lw	a2, 4(sp)       # a2: available space.
	syscall

    bne	a3, zero, read_error    #verifico error

	lw	t0, 4(sp)               #si lei menos que el tamaño del buffer
	blt	v0, t0, eof             #estoy en el final del archivo
    beq	v0, zero, eof
    b   palindrome_return

eof:
write:
    li	v0, SYS_write   # ver dentro de <sys/syscall.h>.
	lw  a0, 8(sp)       # a0: file descriptor number.
	la	a1, 52(sp)      # a1: output data pointer.
	lw	a2, 12(sp)      # a2: output byte size.
	syscall

    li  t0, 10          #guardo salto de linea en t0
    sw  t0, 52(sp)      #guardo el salto de linea en el stack
    
    li	v0, SYS_write   # ver dentro de <sys/syscall.h>.
	lw  a0, 8(sp)       # a0: file descriptor number.
	la	a1, 52(sp)      # a1: output data pointer.
	li	a2, 1           # a2: output byte size.
	syscall

    b palindrome_return

write_error:
read_error:
	li	v0, SYS_exit
	li	a0, 1
	syscall

palindrome_return:
    #li      v0, 0
	move	sp, $fp
	lw	    ra, 44(sp)
	lw	    $fp, 40(sp)
	addu	sp, sp, 48
	j	    ra
	.end	palindrome
    
    
