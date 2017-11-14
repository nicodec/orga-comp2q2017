#include <mips/regdef.h>
#include <sys/syscall.h>

.text

.abicalls
.align 2

.globl cargar_buffer_salida
.ent cargar_buffer_salida

cargar_buffer_salida:
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

	lw      t2, word_size  			# cargo en t2 PALABRA size
	add     t4, zero, zero 			# en t4 posicion caracter PALABRA (i = 0)
	sw 		zero, 16($fp)

llenarBufferSalida:
	lw      t0, buffer_word      	# cargo en t0 PALABRA addr
	lw      t1, buffer_salida      	# cargo en t1 SALIDA addr
	lw      t3, salida_read_pos      		# cargo en t3 SALIDA pos
	lw		t4, 16($fp)

	addu    t1, t1, t3      		# en t1 SALIDA addr + pos
	add     t0, t0, t4      		# en t0 PALABRA addr + pos
	lb      t5, 0(t0)       		# t5 = PALABRA[i]
	sb      t5, 0(t1)       		# SALIDA[j] = PALABRA[i]
	addi    t3, t3, 1       		# j + 1
	addi    t4, t4, 1       		# i + 1
	sw      t3, salida_read_pos      		# guardo SALIDA pos en el stack
	sw 		t4, 16($fp)

	lw      t6, salida_size         # cargo en t6 SALIDA max size

	beq     t6, t3, escribirArchivo # si se llena el buffer escribo
	
	# me fijo si no se termino la palabra
	blt t4, t2, llenarBufferSalida  # PALABRA pos < PALABRA size => sigo llenando

write_endofline:
	# sino => se termino la palabra -> guardo \n en buffer salida
	lw      t6, salida_size         # cargo en t6 SALIDA max size
	lw      t3, salida_read_pos      		# cargo en t3 SALIDA pos
	add     t7, zero, 10    		# guardo en t7 el valor 10 ('\n')
	lw      t1, buffer_salida       # cargo en t1 SALIDA addr
	add     t1, t1, t3      		# en t1 SALIDA addr + pos
	sb      t7, 0(t1)       		# SALIDA[j] = '\n'
	addi    t3, t3, 1       		# j + 1
	sw      t3, salida_read_pos      		# guardo SALIDA pos en el stack
	add     t4, t4, 1

	sw      zero, word_size

	beq     t3, t6, escribirArchivoE # si se llena el buffer escribo (ojo con los indices)

	b return


escribirArchivo:
	# write buffer_salida -> file_out
	sw      t2, word_size  			# cargo en t2 PALABRA size
escribirArchivoE:
	sw      t4, 16($fp)

	lw 		a0, 40($fp)
	lw 		a1, salida_read_pos
	jal 	write_file

	bne		v0, zero, write_error   #verifico error de escritura

	add 	t0, zero, zero
	sw  	t0, salida_read_pos      		# guardo en stack SALIDA pos = 0

	lw      t2, word_size  			# cargo en t2 PALABRA size
	lw      t4, 16($fp)
	beq     t4, t2, write_endofline

	blt 	t4, t2, llenarBufferSalida

	li 		v0, 0
	b 		return
	
write_error:
	li 	v0, 1

return:
	lw	a0, 40($fp)

	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end 	cargar_buffer_salida
	.size	cargar_buffer_salida,.-cargar_buffer_salida

	.rdata

