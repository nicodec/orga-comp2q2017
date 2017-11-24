# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

	.data

	###################### DECLARACION VARIABLES GLOBALES ######################

buffer_entrada:		.word	1
entrada_size:		.word	1
entrada_read_pos:	.word	1

buffer_salida:	.word	1
salida_size:	.word	1
salida_read_pos: 	.word 	0

buffer_word: 	.word	1
word_max_size:	.word	1
word_size:		.word	1

	.text
	.align  2

	.globl  palindrome

	.globl 	buffer_entrada
	.globl	entrada_size
	.globl 	entrada_read_pos

	.globl 	buffer_salida
	.globl	salida_size
	.globl 	salida_read_pos

	.globl 	buffer_word
	.globl	word_max_size
	.globl 	word_size

	.ent    palindrome
	
palindrome:
	.frame $fp, 64, ra

	#bloque para codigo pic
	.set    noreorder
	.cpload t9
	.set    reorder

	#creo stack frame
	subu    sp, sp, 64
	
	#bloque para codigo pic
	.cprestore 48
	
	# salvando el callee
	sw  ra,  56(sp)
	sw  $fp, 52(sp)

	move    $fp, sp

	####################### STACK FRAME ######################
	#	+---------------+
	# 76	|	a3	|	\
	#	+---------------+	|
	# 72	|	a2	|	|
	#	+---------------+	|	ABA CALLER
	# 68	|	a1	|	|
	#	+---------------+	|
	# 64	|	a0	|	/
	#	+---------------+
	# 60	|		|	\
	#	+---------------+	|
	# 56	|	ra	|	|
	#	+---------------+	|	SRA
	# 52	|	fp	|	|
	#	+---------------+	|
	# 48	|	gp	|	/
	#	+---------------+
	# 44	|		|	|	\
	#	+---------------+
	# 40	|		|	|	|
	# 	+---------------+
	# 36	|	alg	|	|	|
	# 	+---------------+
	# 32	|		|	|	|	LTA
	# 	+---------------+
	# 28	|		|	|	|
	# 	+---------------+
	# 24	|		|	|	|
	# 	+---------------+
	# 20	|  		|	|	|
	# 	+---------------+
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

	############################ ARGUMENTOS ##########################
	sw  a0, 64($fp)				# a0: file_in (file_descriptor de entrada)
	sw 	a1, 68($fp)
	sw  a1, entrada_size		# a1: ibuf (tamaño del buffer de entrada)
	sw  a2, 72($fp)				# a2: file_out (file_descriptor de salida)
	sw 	a3, 76($fp)
	sw  a3, salida_size			# a3: obuf (tamaño del buffer de salida)

	###################################################
	#cargo los buffers necesarios para operar
	#buffer_entrada -> empty
	#buffer_word -> empty
	#buffer_salida -> empty

	li  a0, 100					# cargo el parametro para mymalloc
	sw  a0, word_max_size		# guardo en el stack el tamaño maximo del buffer palabra
	jal mymalloc				# llamo a la funcion
    beqz v0, malloc_error_a # verifico error de mymalloc
	sw  v0, buffer_word			# guardo la direccion de memoria reservada para el buffer de PALABRA
	add t0, zero, zero
	sw  t0, word_size 			# guardo el tamaño del buffer (incialmente vacio)
	
	lw  a0, entrada_size		# cargo el parametro para mymalloc
	jal mymalloc				# llamo a la funcion
    beqz v0, malloc_error_b # verifico error de mymalloc
	sw  v0, buffer_entrada		# guardo la direccion de memoria reservada para el buffer de ENTRADA
	add t0, zero, zero
	sw  t0, 44($fp)				# guardo el tamaño del buffer (incialmente vacio)

	lw  a0, salida_size 		# cargo el parametro para mymalloc
	jal mymalloc				# llamo a la funcion
    beqz v0, malloc_error_c # verifico error de mymalloc
	sw  v0, buffer_salida		# guardo la direccion de memoria reservada para el buffer de SALIDA
	add t0, zero, zero

	sw 	zero, 28($fp)			# marca fin de proceso
	add t0, zero, zero
	sw  t0, entrada_read_pos	# guardo ENTRADA pos = 0
	sw  t0, 24($fp)				# guardo SALIDA pos = 0

	###################################################

leerArchivo:
	#read file_in -> buffer_entrada (I Bytes)

	li  	v0, SYS_read			# ver dentro de <sys/syscall.h>.
	lw  	a0, 64($fp)				# a0: file descriptor number.
	lw  	a1, buffer_entrada		# a1: data pointer.
	lw  	a2, entrada_size		# a2: available space.
	syscall

	bne 	a3, zero, read_error	#verifico error de lectura

	beqz 	v0, escribirArchivo_quit 	# si read no lee nada finalizo el programa

	move 	t0, zero				# en t0 cargo el indice inicial del buffer
	sw  	t0, entrada_read_pos	# guardo en el stack ENTRADA pos
	
	sw  	v0, 44($fp)				# guardo en el stack ENTRADA size

leoByte:
	lw  t5, 44($fp)      			# cargo en t5 ENTRADA size
	beq t5, zero, leerArchivo 		# si ENTRADA size == 0 => leerArchivo

	# c = leo un byte <- buffer_entrada
	lw  t0, entrada_read_pos      	# cargo en t0 ENTRADA pos (t0 = i)
	lw  t1, buffer_entrada      	# cargo en t1 ENTRADA addr
	add t1, t1, t0      			# sumo ENTRDA addr + pos
	lb  t2, 0(t1)       			# c: t2 = ENTRADA[i]
	
	sub t5, t5, 1       			# ENTRADA size - 1
	add t0, t0, 1       			# ENTRADA pos + 1
	sw  t5, 44($fp)      			# guardo en stack ENTRADA size
	sw  t0, entrada_read_pos      	# guardo en stack ENTRADA pos

testAlfaNumerico:
	# si c no es alfanumerico tengo que testear
	# si lo que hay en el buffer de word es palindromo

	move 	a0, t2
	jal 	check_alfaNumerico
	beqz 	v0, test_palindromo

    # (ver que el buffer word no se llene)
	# (si se llena pedir mas memoria, hacer swap con memoria pedida y memoria vieja)
	lw		t8, word_size
	lw 		t6, word_max_size		# tamaño maximo de palabra
	sne 	t6, t8, t6 				# si no son iguales t6 = 1 sino t6 = 0
	sub 	t6, t6, 1
	bltzal 	t6, reasignar_buffer_palabra
			
	b leoByte # vuelvo a leer un byte

###########################################################################
################# ASIGNO MAS TAMAÑO AL BUFFER DE PALABRA ##################
###########################################################################
reasignar_buffer_palabra:
# En este punto copio el buffer de palabra en uno nuevo con el doble de capacidad
	sw 		ra, 36($fp)

	lw 		a0, buffer_word
	lw 		a1, word_max_size
	mul		a2, a1, 2
	jal 	myrealloc

    beqz    v0, realloc_error

	sw 		v0, buffer_word
	sw 		a2, word_max_size

	lw 		ra, 36($fp)
	sw 		a2, 36($fp)
	j 		ra

###########################################################################
############### CHEQUEO SI LA PALABRA LEIDA ES PALINDROMO #################
###########################################################################
test_palindromo:
	#me fijo si buffer_word es palindromo
	
	lw  	a0, buffer_word      	# cargo en a0 la PALABRA addr
	lw  	a1, word_size      		# cargo en a1 PALABRA size
	beqz 	a1, leoByte         	# si PALABRA size == 0 no hago test_palindromo

	jal 	testpal         		# esPalindromo(PALABRA addr, PALABRA size)

	beqz 	v0, esPalindromoTrue 	# si v0 = 0 => palindromo true
	
	# si no es palindromo vacio el buffer PALABRA
noPalindromo:
	move    t0, zero  				# t0 = 0
	sw      zero, word_size 		# word_size = 0
	b       leoByte

esPalindromoTrue:
	# buffer_word -> buffer_salida
	# (hay que fijarse que buffer salida tenga espacio suficiente)
	# si se llena buffer salida => escribirArchivo
	# buffer_salida + '\n'
	# buffer_salida.size ++
	
llenarBufferSalida:
	lw 		a0, 72($fp)				# 
	jal 	cargar_buffer_salida

	bnez 	v0, write_error

	b leoByte

escribirArchivo_quit:
	# write buffer_salida -> file_out
	lw 		a0, 72($fp)
	lw 		a1, salida_read_pos
	jal 	write_file

	bne		v0, zero, write_error   #verifico error de escritura

	b palindromoReturn

write_error:
read_error:
	jal     free_memory

	li	v0, SYS_exit
	li	a0, 1
	syscall

realloc_error:
    jal     free_memory_noword
    li	v0, SYS_exit
	li	a0, 1
	syscall

malloc_error_c:
    lw      a0, 36(sp)
    jal     myfree
malloc_error_b:
    lw      a0, 32(sp)
    jal     myfree
malloc_error_a:
    lw      a0, 28(sp)
    jal     myfree
    li	v0, SYS_exit
	li	a0, 1
	syscall

free_memory:
	sw 		ra, 36($fp)
	lw      a0, buffer_word
	jal     myfree
free_memory_noword:
	lw      a0, buffer_entrada
	jal     myfree
	lw      a0, buffer_salida
	jal     myfree
	lw 		ra, 36($fp)
	j       ra

palindromoReturn:
	jal     free_memory

	# restauro argumentos
	lw  a0, 64($fp)				# a0: file_in (file_descriptor de entrada)
	lw 	a1, 68($fp)
	lw  a2, 72($fp)				# a2: file_out (file_descriptor de salida)
	lw 	a3, 76($fp)

	# valor de salida exitoso
	move    v0, zero

	move	sp, $fp

	lw	ra,  56(sp)
	lw	$fp, 52(sp)
	lw	gp,  48(sp)

	addu	sp, sp, 64
	j	    ra
	.end	palindrome

