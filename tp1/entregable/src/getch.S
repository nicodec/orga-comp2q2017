#include <mips/regdef.h>
#include <sys/syscall.h>

.text

.abicalls
.align 2

.globl getch
.ent getch

getch:
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
	# 52	|		|	\
	#	+---------------+	|
	# 48	|		|	|
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
	# 20	|  		|	\
	# 	+---------------+	|	LTA
	# 16	|  		|	/
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
	sw	a1, 44($fp)		# a1: posicion a leer
	#################### PSEUDOCODIGO ##########################
	## 	const char* buffer = a0;
	## 	int i = a1;
	## 	char letra = buffer[i];
	##	a1++;
	##	return letra;
	################# FIN BLOQUE DE PSEUDOCODIGO ###############

	lw 		t0, 40($fp)
	lw 		t1, 44($fp)

	add 	t2, t0, t1		# adelanto el puntero a la posicion donde quiero leer

	lb 		v0, 0(t2)

	return:
	lw		a0, 40($fp)
	lw		a1, 44($fp)
	add 	a1, a1, 1

	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end 	getch
	.size	getch,.-getch

	.rdata
