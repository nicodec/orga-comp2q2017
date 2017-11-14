#include <mips/regdef.h>
#include <sys/syscall.h>

.text

.abicalls
.align 2

.globl write_file
.ent write_file

write_file:
	.frame $fp, 40, ra

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
	# 20	|  		|	|	\
	# 	+---------------+	|	LTA
	# 16	|  		|	|	/
	# 	+---------------+
	# 12	|		|	\
	# 	+---------------+	|
	# 08	|		|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|		|	|
	# 	+---------------+	|
	# 00	|		|	/
	# 	+---------------+

	###################### ARGUMENTOS #######################
	sw 		a0, 40($fp) 	# a0: file_descriptor de salida
	sw 		a1, 44($fp)		# a1: cantidad de bytes a escribir

	######### ESCRIBIR BUFFER DE SALIDA EN ARCHIVO ##########

	li  	v0, SYS_write   # write
	lw  	a0, 40($fp)       # cargo en a0 el fno del archivo de salida
	lw  	a1, buffer_salida      # cargo en a1 la direccion del buffer de salida
	lw  	a2, 44($fp)      # cargo en a2 el tamaño del buffer
	syscall

	bne		a3, zero, write_error    #verifico error de escritura

	li 		v0, 0

	b 		return

	write_error:
	li 		v0, 1

	return:
	lw		a0, 40($fp)
	move 	a1, zero

	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end 	write_file
	.size	write_file,.-write_file

	.rdata
	