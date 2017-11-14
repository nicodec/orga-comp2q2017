#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	myrealloc
	.ent	myrealloc

myrealloc:
    .frame $fp, 40, ra

	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 40

	.cprestore 24
    
	sw	$fp, 28(sp)
	sw	ra,  32(sp)

    move	$fp, sp

    ####################### STACK FRAME ######################
	#	+---------------+
	# 52	|		|	\
	#	+---------------+	|
	# 48	|	a2	|	|
	#	+---------------+	|	ABA CALLER
	# 44	|	a1	|	|
	#	+---------------+	|
	# 40	|	a0	|	/
	# 	+---------------+
	# 36	|		|	\
	# 	+---------------+	|
	# 32	|	ra	|	|
	# 	+---------------+	|	SRA
	# 28	|	fp	|	|
	# 	+---------------+	|
	# 24	|	gp	|	/
	# 	+---------------+
	# 20	|  		|	|	\
	# 	+---------------+	|	LTA
	# 16	|  	v0	|	|	/
	# 	+---------------+
	# 12	|		|	\
	# 	+---------------+	|
	# 08	|		|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|		|	|
	# 	+---------------+	|
	# 00	|		|	/
	# 	+---------------+

##################### ARGUMENTOS ########################
    sw	a0, 40($fp) 		# direccion a reasignar
	sw	a1, 44($fp)			# tamaño a asignado
	sw	a2, 48($fp)			# tamaño a asignar

##########################################################

    lw 		a0, 48($fp)
    jal 	mymalloc
    sw 		v0, 16($fp)		# nueva direccion de memoria

    lw		t1, 44($fp) 		# tamaño viejo
    move 	t0, zero		# pos buffer viejo
    lw 		t4, 40($fp)		# direccion buffer viejo
    lw 		t5, 16($fp)		# direccion buffer nuevo

##########################################################
#	copio lo que habia en el viejo buffer al nuevo 
#	posicion por posicion
copiar:
	lb 		t6, 0(t4)		# aux = viejo[i]
	sb		t6, 0(t5)		# nuevo[i] = aux

	add 	t0, t0, 1		# i = i + 1
	add 	t4, t4, 1		# siguiente posicion de viejo
	add 	t5, t5, 1		# siguiente posicion de nuevo
	
	blt		t0, t1, copiar 	# si no copie todo el viejo sigo copiando

#	de lo contrario retorno al programa 
return:
#	libero la memoria reservada por el buffer viejo
	lw 		a0, 40($fp)
	jal		myfree

	#########################################################
#	guardo en v0 el la direccion de memoria del nuevo buffer y retorno
	lw 		v0, 16($fp)
	#########################################################
    lw		a1, 44($fp)			# tamaño a asignado
	lw		a2, 48($fp)			# tamaño a asignar
	#########################################################

	lw		gp, 24(sp)
	lw	    $fp, 28(sp)
	lw	    ra, 32(sp)

	addu	sp, sp, 40

	jr	    ra
	
	.end	myrealloc
	.size 	myrealloc,.-myrealloc
