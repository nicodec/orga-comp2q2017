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

    lw	a0, 4(sp)		# cargo el parametro para mymalloc
    jal	ra, mymalloc	# llamo a la funcion
    sw 	v0, 24(sp)		# guardo la direccion de memoria reservada para el buffer de ENTRADA

    lw	a0, 12(sp)		# cargo el parametro para mymalloc
    jal ra, mymalloc	# llamo a la funcion
    sw 	v0, 28(sp)		# guardo la direccion de memoria reservada para el buffer de SALIDA

prog:
    li	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw	a0, 0(sp)       # a0: file descriptor number.
	la	a1, 24(sp)      # a1: data pointer.
	lw	a2, 4(sp)          # a2: available space.
	syscall
    
    li	v0, SYS_write   # ver dentro de <sys/syscall.h>.
	lw  a0, 8(sp)       # a0: file descriptor number.
	la	a1, 28(sp)      # a1: output data pointer.
	lw	a2, 12(sp)          # a2: output byte size.
	syscall

    li  t0, 10          #guardo salto de linea en t0
    sw  t0, 52(sp)      #guardo el salto de linea en el stack
    
    li	v0, SYS_write   # ver dentro de <sys/syscall.h>.
	lw  a0, 8(sp)       # a0: file descriptor number.
	la	a1, 52(sp)      # a1: output data pointer.
	li	a2, 1           # a2: output byte size.
	syscall

    
free_buffer:
	lw	a0, 24(sp)
	jal ra, myfree		# libero la memoria reservada para el buffer de entrada

	lw	a0, 28(sp)
	jal	ra, myfree		# libero la memoria reservada para el buffer de salida

palindrome_return:
    move    v0, t0
	move	sp, $fp
	lw	    ra, 44(sp)
	lw	    $fp, 40(sp)
	addu	sp, sp, 48
	j	    ra
	.end	palindrome
    
    
