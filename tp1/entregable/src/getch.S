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
	# 44	|		|	|
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
	sw	a0, 40($fp)		# a0: file descriptor archivo de entrada
	#################### PSEUDOCODIGO ##########################
	## 	const char* buffer = a0;
	## 	int i = a1;
	## 	char letra = buffer[i];
	##	a1++;
	##	return letra;
	################# FIN BLOQUE DE PSEUDOCODIGO ###############

	bne  	entrada_max_size, entrada_size, read_char

	li  	v0, SYS_read			# ver dentro de <sys/syscall.h>.
	lw  	a0, 40($fp)				# a0: file descriptor number.
	lw  	a1, buffer_entrada		# a1: data pointer.
	lw  	a2, entrada_max_size	# a2: available space.
	syscall

	bne 	a3, zero, error			#verifico error de lectura

	beqz 	v0, return			 	# si read no lee nada finalizo el programa

	sw  	zero, entrada_read_pos	# guardo en el stack ENTRADA pos
	
	sw  	v0, entrada_size		# guardo en el stack ENTRADA size

read_char:
	lw 		t0, buffer_entrada
	lw		t1, entrada_read_pos
	add 	t0, t0, t1
	lb 		v0, 0(t0)

	addi 	t1, t1, 1				# adelanto el puntero a la siguiente posicion de lectura

	sw 		t1, entrada_read_pos
	li 		a2, zero

	b 		return

error:
	li 		a2, 1
return:
	lw		a0, 40($fp)

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
