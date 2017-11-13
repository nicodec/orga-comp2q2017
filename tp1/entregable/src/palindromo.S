# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align  2

	.globl  palindrome

	.globl 	buffer_entrada
	.globl	entrada_size
	.globl 	entrada_read_pos

	.globl 	buffer_salida
	.globl	salida_size

	.globl 	buffer_word
	.globl	word_max_size
	.globl 	word_size

	.ent    palindrome
	
palindrome:
	.frame $fp, 88, ra
	.set    noreorder
	.cpload t9
	.set    reorder

	subu    sp, sp, 88
	
	.cprestore 60
	
	sw  ra,  72(sp)
	sw  gp,  68(sp)
	sw  $fp, 64(sp)
	
	sw  a0, 0(sp)       #file_in
	sw  a1, 4(sp)       #ibuf
	sw  a2, 8(sp)       #file_out
	sw  a3, 12(sp)      #obuf

	move    $fp, sp

	###################################################
	#cargo los buffers necesarios para operar
	#buffer_entrada -> empty
	#buffer_word -> empty
	#buffer_salida -> empty

	li  a0, 100         # cargo el parametro para mymalloc
	sw  a0, word_max_size      # guardo en el stack el tamaño maximo del buffer palabra
	jal mymalloc        # llamo a la funcion
	sw  v0, buffer_word      # guardo la direccion de memoria reservada para el buffer de PALABRA
	add t0, zero, zero
	sw  t0, word_size      # guardo el tamaño del buffer (incialmente vacio)
	
	lw  a0, 4(sp)       # cargo el parametro para mymalloc
	jal mymalloc        # llamo a la funcion
	sw  v0, buffer_entrada      # guardo la direccion de memoria reservada para el buffer de ENTRADA
	add t0, zero, zero
	sw  t0, 44(sp)      # guardo el tamaño del buffer (incialmente vacio)

	lw  a0, 12(sp)      # cargo el parametro para mymalloc
	jal mymalloc        # llamo a la funcion
	sw  v0, buffer_salida      # guardo la direccion de memoria reservada para el buffer de SALIDA
	add t0, zero, zero
	sw  t0, 48(sp)      # guardo el tamaño del buffer (incialmente vacio)

	sw 	zero, 84(sp)	# marca fin de proceso
	add t0, zero, zero
	sw  t0, entrada_read_pos      # guardo ENTRADA pos = 0
	sw  t0, 24(sp)      # guardo SALIDA pos = 0

	###################################################

leerArchivo:
	#read file_in -> buffer_entrada (I Bytes)

	li  	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw  	a0, 0(sp)       # a0: file descriptor number.
	lw  	a1, buffer_entrada      # a1: data pointer.
	lw  	a2, 4(sp)       # a2: available space.
	syscall

	bne 	a3, zero, read_error    #verifico error de lectura

	seq  	t0, v0, zero
	sw 		t0, 84(sp) 		# si no se leyeron mas caracteres pongo el flag en 1
	beqz 	v0, escribirArchivo # si read no lee nada finalizo el programa

	add 	t0, zero, zero  # en t0 cargo el indice inicial del buffer
	sw  	t0, entrada_read_pos      # guardo en el stack ENTRADA pos
	
	sw  	v0, 44(sp)      # guardo en el stack ENTRADA size

leoByte:
	lw  t5, 44(sp)      # cargo en t5 ENTRADA size
	beq t5, zero, leerArchivo # si ENTRADA size == 0 => leerArchivo

	# c = leo un byte <- buffer_entrada
	lw  t0, entrada_read_pos      # cargo en t0 ENTRADA pos (t0 = i)
	lw  t1, buffer_entrada      # cargo en t1 ENTRADA addr
	add t1, t1, t0      # sumo ENTRDA addr + pos
	lb  t2, 0(t1)       # c: t2 = ENTRADA[i]
	
	sub t5, t5, 1       # ENTRADA size - 1
	add t0, t0, 1       # ENTRADA pos + 1
	sw  t5, 44(sp)      # guardo en stack ENTRADA size
	sw  t0, entrada_read_pos      # guardo en stack ENTRADA pos

testAlfaNumerico:
	# si c no es alfanumerico tengo que testear
	# si lo que hay en el buffer de word es palindromo

	move 	a0, t2
	jal 	check_alfaNumerico
	beqz 	v0, test_palindromo

    # (ver que el buffer word no se llene)
	# (si se llena pedir mas memoria, hacer swap con memoria pedida y memoria vieja)
	lw		t8, word_size
	lw 		t6, word_max_size	# tamaño maximo de palabra
	sne 	t6, t8, t6 	# si no son iguales t6 = 1 sino t6 = 0
	sub 	t6, t6, 1
	bltzal 	t6, reasignar_buffer_palabra
			
	
	
	b leoByte # vuelvo a leer un byte

reasignar_buffer_palabra:
	sw 		ra, 80(sp)
	lw 		a0, buffer_word
	lw 		a1, word_max_size
	mul		a2, a1, 2
	jal 	myrealloc
	sw 		v0, buffer_word
	sw 		a2, word_max_size

	lw 		ra, 80(sp)
	sw 		a2, 80(sp)
	j 	ra

test_palindromo:

	#me fijo si buffer_word es palindromo
	
	lw  a0, buffer_word      # cargo en a0 la PALABRA addr
	lw  a1, word_size      # cargo en a1 PALABRA size
	jal testpal         # esPalindromo(PALABRA addr, PALABRA size)

	beqz v0, esPalindromoTrue # si v0 = 0 => palindromo true
	
	# si no es palindromo vacio el buffer PALABRA
noPalindromo:
	move    t0, zero  # t0 = 0
	sw      zero, word_size
	b       leoByte

esPalindromoTrue:
	# buffer_word -> buffer_salida
	# (hay que fijarse que buffer salida tenga espacio suficiente)
	# si se llena buffer salida => escribirArchivo
	# buffer_salida + '\n'
	# buffer_salida.size ++
	
	lw      t2, word_size  # cargo en t2 PALABRA size
	#lw  t3, 24(sp)  # cargo en t3 SALIDA pos
	add     t4, zero, zero # en t4 posicion caracter PALABRA (i = 0)
	sw 		zero, 56(sp)
	sw      zero, 76(sp)

llenarBufferSalida:
	lw      t0, buffer_word      # cargo en t0 PALABRA addr
	lw      t1, buffer_salida      # cargo en t1 SALIDA addr
	lw      t3, 24(sp)      # cargo en t3 SALIDA pos
	lw		t4, 56(sp)

	addu    t1, t1, t3      # en t1 SALIDA addr + pos
	add     t0, t0, t4      # en t0 PALABRA addr + pos
	lb      t5, 0(t0)       # t5 = PALABRA[i]
	sb      t5, 0(t1)       # SALIDA[j] = PALABRA[i]
	addi    t3, t3, 1       # j + 1
	addi    t4, t4, 1       # i + 1
	sw      t3, 24(sp)      # guardo SALIDA pos en el stack
	sw 		t4, 56(sp)

	lw      t6, 12(sp)              # cargo en t6 SALIDA max size

	beq     t6, t3, escribirArchivo # si se llena el buffer escribo
	
	# me fijo si no se termino la palabra
	blt t4, t2, llenarBufferSalida  # PALABRA pos < PALABRA size => sigo llenando

write_endofline:
	# sino => se termino la palabra -> guardo \n en buffer salida
	lw      t6, 12(sp)              # cargo en t6 SALIDA max size
	lw      t3, 24(sp)      # cargo en t3 SALIDA pos
	add     t7, zero, 10    # guardo en t7 el valor 10 ('\n')
	lw      t1, buffer_salida      # cargo en t1 SALIDA addr
	add     t1, t1, t3      # en t1 SALIDA addr + pos
	sb      t7, 0(t1)       # SALIDA[j] = '\n'
	addi    t3, t3, 1       # j + 1
	sw      t3, 24(sp)      # guardo SALIDA pos en el stack
	add     t8, zero, 1
	sw      t8, 76(sp)
	add     t4, t4, 1
	sw      zero, word_size

	beq     t3, t6, escribirArchivo # si se llena el buffer escribo (ojo con los indices)

	b leoByte


escribirArchivo:
	# write buffer_salida -> file_out
	sw      t2, word_size  # cargo en t2 PALABRA size
	sw      t4, 56(sp)

	li  	v0, SYS_write   # write
	lw  	a0, 8(sp)       # cargo en a0 el fno del archivo de salida
	lw  	a1, buffer_salida      # cargo en a1 la direccion del buffer de salida
	lw  	a2, 24(sp)      # cargo en a2 el tamaño del buffer
	syscall

	bne		a3, zero, write_error    #verifico error de escritura

	lw 		t2, 84(sp) 		# busco la marca de fin de procesamiento
	bnez	t2, palindromoReturn	# si la marca esta en 1 salgo del programa

	add 	t0, zero, zero
	sw  	t0, 24(sp)      # guardo en stack SALIDA pos = 0

	lw      t2, word_size  # cargo en t2 PALABRA size
	lw      t4, 56(sp)
	beq     t4, t2, write_endofline

	lw		t8, 76(sp)
	#beq 	t8, zero, llenarBufferSalida
	blt t4, t2, llenarBufferSalida
	
	#sw  t0, 48(sp)      # guardo en stack SALIDA size = 0

	b leoByte           #vuelvo a intentar leer bytes del buffer de entrada

write_error:
read_error:
	jal     free_memory

	li	v0, SYS_exit
	li	a0, 1
	syscall

free_memory:
	sw 		ra, 80(sp)
	lw      a0, buffer_word
	jal     myfree
	lw      a0, buffer_entrada
	jal     myfree
	lw      a0, buffer_salida
	jal     myfree
	lw 		ra, 80(sp)
	j       ra

palindromoReturn:
	jal     free_memory

	move    v0, zero
	move	sp, $fp

	lw	ra,  72(sp)
	lw	gp,  68(sp)
	lw	$fp, 64(sp)

	addu	sp, sp, 88
	j	    ra
	.end	palindrome

