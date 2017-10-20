#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	myread
	.ent	myread

myread:
	.frame $fp, 32, ra
	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 32
    
	.cprestore 24
    
	sw	ra,  32(sp)
    sw	gp,  28(sp)
	sw	$fp, 24(sp)
	
    sw  a0, 0(sp)       #file_in
    sw  a1, 4(sp)       #ibuf

    move	$fp, sp

    li	a0, 1024	    # cargo el parametro para mymalloc
    jal	mymalloc	    # llamo a la funcion
    sw 	v0, 16(sp)		# guardo la direccion de memoria reservada para el buffer de PALABRA

    add t0, zero, zero
    sw  t0, 20(sp)

loop:
    li	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw	a0, 0(sp)       # a0: file descriptor number.
	la	a1, 16(sp)      # a1: data pointer.
	lw	a2, 4(sp)       # a2: available space.
	syscall

    bne	a3, zero, read_error    #verifico error de lectura
    beqz v0, return # si read no lee nada finalizo el programa

    lw t0, 20(sp)
    addi t0, t0, 1
    sw t0, 20(sp)

    b loop

read_error:
	li	v0, SYS_exit
	li	a0, 1
	syscall

return:
    lw      v0, 20(sp)
    
	move	sp, $fp

    lw	ra,  32(sp)
	lw	gp,  28(sp)
    lw	$fp, 24(sp)

    addu	sp, sp, 32
	j	    ra
	.end	myread

    

    
