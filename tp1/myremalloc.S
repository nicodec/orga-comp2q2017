#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	myrealloc
	.ent	myrealloc    
myrealloc:
    .frame $fp, 56, ra
	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 56

	.cprestore 24
    
	sw	ra,  20(sp)
	sw	$fp, 16(sp)
    sw	a0,  0(sp) 			# direccion a reasignar
	sw	a1, 4(sp)			# tamaño a asignado
	sw	a2, 8(sp)			# tamaño a asignar

##########################################################
# 	guardo registros temporales que pueden estar en uso

	sw	t0, 28(sp)
	sw	t1, 32(sp)
	sw 	t2, 36(sp)
	sw 	t3, 40(sp)
    sw  t4, 44(sp)          # no estoy seguro de si se usan previamente por lo tanto los guardo para prevenir sobreescritura
    sw  t5, 48(sp)
    sw  t6, 52(sp)

##########################################################

    move	$fp, sp

    lw 		a0, 8(sp)
    jal 	mymalloc
    sw 		v0, 12(sp)		# nueva direccion de memoria

    lw		t1, 4(sp) 		# tamaño viejo
    move 	t0, zero		# pos buffer viejo
    lw 		t4, 0(sp)		# direccion buffer viejo
    lw 		t5, 12(sp)		# direccion buffer nuevo

##########################################################
#	copio lo que habia en el viejo buffer al nuevo 
#	posicion por posicion
copiar:
	lw 		t6, 0(t4)		# aux = viejo[i]
	sw		t6, 0(t5)		# nuevo[i] = aux

	add 	t0, t0, 1		# i = i + 1
	add 	t4, t4, 1		# siguiente posicion de viejo
	add 	t5, t5, 1		# siguiente posicion de nuevo
	
	blt		t0, t1, copiar 	# si no copie todo el viejo sigo copiando

#	de lo contrario retorno al programa 
return:
#	libero la memoria reservada por el buffer viejo
	lw 		a0, 0(sp)
	jal		myfree

	move	sp, $fp
	lw	    ra, 20(sp)
	lw	    $fp, 16(sp)

#########################################################
#	restauro los registros temporales
    lw		t0, 28(sp)
	lw		t1, 32(sp)
	lw	 	t2, 36(sp)
	lw	 	t3, 40(sp)
    lw		t4, 44(sp)          # no estoy seguro de si se usan previamente por lo tanto los guardo para prevenir sobreescritura
    lw		t5, 48(sp)
    lw  	t6, 52(sp)
    lw		a1, 4(sp)			# tamaño a asignado
	lw		a2, 8(sp)			# tamaño a asignar

#########################################################
#	guardo en v0 el la direccion de memoria del nuevo buffer y retorno
	lw 		v0, 12(sp)

	addu	sp, sp, 56
	j	    ra
	.end	myrealloc
