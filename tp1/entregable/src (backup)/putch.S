#include <mips/regdef.h>
#include <sys/syscall.h>

.text

.abicalls
.align 2

.globl putch
.ent putch

putch:
	#debugging info: descripcion del stack frame
	.frame $fp, 40, ra		# ver que a lo mejor 40 no es un buen numero

	#bloque para codigo pic
	.set noreorder
	.cpload t9
	.set reorder

	#creo stack frame
	subu	sp, sp, 40

	#bloque para codigo pic
	.cprestore 24

	# salvando el callee
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

	move 	$fp, sp

	####################### STACK FRAME ######################
	
	#	+---------------+
	# 52	|	a3	|	\
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
	# 20	|  t1 (Backup)	|	\
	# 	+---------------+	|	LTA
	# 16	|  t0 (Backup)	|	/
	# 	+---------------+
	# 12	|		|	\
	# 	+---------------+	|
	# 08	|		|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|		|	|
	# 	+---------------+	|
	# 00	|		|	/
	# 	+---------------+

	##################### ARGUMENTOS #######################
	sw	a0, 40($fp)		# a0: puntero buffer
	sw	a1, 44($fp)		# a1: posicion a insertar
	sw	a2, 48($fp)		# a2: byte a insertar
	sw	a3, 52($fp)		# a3: tamaño maximo del buffer

	#################### PSEUDOCODIGO ##########################
	## 	const char* buffer = a0;
	## 	int i = a1;
	##	if (i == a3) {
	##		return 0;
	## 	}
	##	buffer[i] = a2;
	##	return 1;
	################# FIN BLOQUE DE PSEUDOCODIGO ###############

	lw 		t0, 44($fp)
	lw 		t1, 52($fp)

	bge 	t0, t1, error	# si i > buffer_size devuelvo error

	lw 		t2, 40($fp)
	add 	t2, t2, t0		# adelanto el puntero a la posicion donde quiero grabar

	lb 		t3, 48($fp)
	sb 		t3, 0(t2)		# guardo el byte en el buffer

	li 		v0, 1 	# Devuelvo 1 como grabado exitoso

	b return

	error:
	li v0, 0	# En caso de error devuelvo 0

	return:
	lw		a0, 40($fp)
	lw		a1, 44($fp)
	add 	a1, a1, 1
	lw		a2, 48($fp)

	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end 	putch
	.size	putch,.-putch

	.rdata

