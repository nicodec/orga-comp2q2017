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
    jal	mymalloc	# llamo a la funcion
    sw 	v0, 24(sp)		# guardo la direccion de memoria reservada para el buffer de ENTRADA

    lw	a0, 12(sp)		# cargo el parametro para mymalloc
    jal mymalloc	# llamo a la funcion
    sw 	v0, 28(sp)		# guardo la direccion de memoria reservada para el buffer de SALIDA

prog:
    li	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw	a0, 0(sp)       # a0: file descriptor number.
	la	a1, 24(sp)      # a1: data pointer.
	lw	a2, 4(sp)          # a2: available space.
	syscall

	add 	t0, zero, zero		# indice para recorrer el buffer (i)
	la	t1, 24(sp)		# cargo la direccion del buffer de etrada en t1
	lb	t2, 0(t1)			# cargo el primer valor del buffer de entrada en t2
	lw	t7, 4(sp)
	beqz 	t2, buffer_write

buffer_word_read:
	beq		t0, t7, prog 
	move	t8, t0		# guardo el indice del inicio de la palabra en t8
	slti	t3, t2, 48
	bnez	t3, palindrome_check
	slti	t3, t2, 58
	slti 	t4, t2, 65
	slt		t3, t3, t4
	bnez	t3, palindrome_check
	slti	t3, t2, 91
	slti	t4, t2, 97
	slt 	t3, t3, t4
	bnez	t3, palindrome_check
	slti	t3, t2, 123
	beqz	t3, palindrome_check

	move	t9, t0		# guardo el indice del final de la palabra en t9
	add		t0, t0, 1	# i = i + 1
	add 	t1, t1, 1
	lb 		t2, 0(t1)
	j 		buffer_word_read	# sigo leyendo letras hasta econtrar un caracter que no sea alfanumerico


palindrome_check:
	add 	t0, t0, 1	# i = i + 1

    
buffer_write:
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
	la	a0, 24(sp)
	jal myfree		# libero la memoria reservada para el buffer de entrada

	la	a0, 28(sp)
	jal	myfree		# libero la memoria reservada para el buffer de salida

palindrome_return:
    move    v0, t0
	move	sp, $fp
	lw	    ra, 44(sp)
	lw	    $fp, 40(sp)
	addu	sp, sp, 48
	j	    ra
	.end	palindrome
    
    
