# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
    .align 2

	.globl  palindrome
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
	
	# a0 file_in
	# a1 ibuf
	# a2 file_out
	# a3 obuf

	move    $fp, sp

	###################################################
	#cargo los buffers necesarios para operar
	#buffer_entrada -> empty
	#buffer_word -> empty
	#bufer_salida -> empty

    move t0, a0
    move t1, a1
    move t2, a2
    move t3, a3

    li  a0, 100             # cargo el parametro para mymalloc
	sw  a0, 52(sp)          # guardo en el stack el tamaño maximo del buffer palabra
	jal mymalloc            # llamo a la funcion
    beqz v0, malloc_error_a # verifico error de mymalloc
	sw  v0, 28(sp)          # guardo la direccion de memoria reservada para el buffer de PALABRA
    
	add t4, zero, zero
	sw  t4, 40(sp)          # guardo el tamaño del buffer (incialmente vacio)
	
	move a0, t1           # cargo el parametro para mymalloc
	jal mymalloc            # llamo a la funcion
    beqz v0, malloc_error_b # verifico error de mymalloc
	sw  v0, 32(sp)          # guardo la direccion de memoria reservada para el buffer de ENTRADA
	add t4, zero, zero
	sw  t4, 44(sp)          # guardo el tamaño del buffer (incialmente vacio)

	move a0, t3          # cargo el parametro para mymalloc
	jal mymalloc            # llamo a la funcion
    beqz v0, malloc_error_c # verifico error de mymalloc
	sw  v0, 36(sp)          # guardo la direccion de memoria reservada para el buffer de SALIDA
	add t4, zero, zero
	sw  t4, 48(sp)          # guardo el tamaño del buffer (incialmente vacio)

	sw 	zero, 84(sp)	    # marca fin de proceso
	add t4, zero, zero
	sw  t4, 16(sp)          # guardo SALIDA pos = 0
	sw  t4, 20(sp)          # guardo ENTRADA pos = 0
	sw  t4, 24(sp)          # guardo PALABRA pos = 0

	###################################################

leerArchivo:
	#read file_in -> buffer_entrada (I Bytes)

	li  	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	move  	a0, t0          # a0: file descriptor number.
	lw  	a1, 32(sp)      # a1: data pointer.
	move  	a2, t2          # a2: available space.
	syscall

	bne 	a3, zero, read_error    #verifico error de lectura

	seq  	t0, v0, zero
	sw 		t0, 84(sp) 		# si no se leyeron mas caracteres pongo el flag en 1
	beqz 	v0, escribirArchivo # si read no lee nada finalizo el programa

	add 	t0, zero, zero  # en t0 cargo el indice inicial del buffer
	sw  	t0, 20(sp)      # guardo en el stack ENTRADA pos
	
	sw  	v0, 44(sp)      # guardo en el stack ENTRADA size

leoByte:
	lw  t5, 44(sp)      # cargo en t5 ENTRADA size
	beq t5, zero, leerArchivo # si ENTRADA size == 0 => leerArchivo

	# c = leo un byte <- buffer_entrada
	lw  t0, 20(sp)      # cargo en t0 ENTRADA pos (t0 = i)
	lw  t1, 32(sp)      # cargo en t1 ENTRADA addr
	add t1, t1, t0      # sumo ENTRDA addr + pos
	lb  t2, 0(t1)       # c: t2 = ENTRADA[i]
	
	sub t5, t5, 1       # ENTRADA size - 1
	add t0, t0, 1       # ENTRADA pos + 1
	sw  t5, 44(sp)      # guardo en stack ENTRADA size
	sw  t0, 20(sp)      # guardo en stack ENTRADA pos

testAlfaNumerico:
	# si c no es alfanumerico tengo que testear
	# si lo que hay en el buffer de word es palindromo
	slti    t3, t2, 48
	sne     t4, t2, 45
	add     t3, t4, t3
	beq     t3, 2, test_palindromo
	sgt     t3, t2, 57
	slti    t4, t2, 65
	add     t3, t3, t4
	beq     t3, 2, test_palindromo
	sgt     t3, t2, 90
	slti    t4, t2, 97
	add     t3, t3, t4
	sne     t4, t2, 95
	add     t3, t3, t4
	beq     t3, 3, test_palindromo
	slti    t3, t2, 123
	beqz    t3, test_palindromo
	
	# sino: pongo a c en el buffer de palabra (voy construyendo la palabra)
	lw  t7, 28(sp)      # cargo en t7 PALABRA addr
	lw  t8, 16(sp)      # cargo en t8 PALABRA pos (t8 = j)
	add t7, t7, t8      # t7 cargo PALABRA addr + pos
	sb  t2, 0(t7)       # PALABRA[j] = c

	lw  t0, 40(sp)      # cargo en t0 PALABRA size
	add t0, t0, 1       # PALABRA size + 1
	sw  t0, 40(sp)      # guardo en el stack PALABRA size
	
	addi    t8, 1       # PALABRA pos + 1
	sw      t8, 16(sp)  # guardo PALABRA pos en el stack

    # (ver que el buffer word no se llene)
	# (si se llena pedir mas memoria, hacer swap con memoria pedida y memoria vieja)
	lw 		t6, 52(sp)	# tamaño maximo de palabra
	sne 	t6, t8, t6 	# si no son iguales t6 = 1 sino t6 = 0
	sub 	t6, t6, 1
	bltzal 	t6, reasignar_buffer_palabra
			
	
	
	b leoByte # vuelvo a leer un byte

reasignar_buffer_palabra:
	sw 		ra, 80(sp)
	lw 		a0, 28(sp)
	lw 		a1, 52(sp)
	mul		a2, a1, 2
	jal 	myremalloc
	sw 		v0, 28(sp)
	sw 		a2, 52(sp)

	lw 		ra, 80(sp)
	sw 		a2, 80(sp)
	j 	ra

test_palindromo:

	#me fijo si buffer_word es palindromo
	
	lw  a0, 28(sp)      # cargo en a0 la PALABRA addr
	lw  a1, 40(sp)      # cargo en a1 PALABRA size
	jal testpal         # esPalindromo(PALABRA addr, PALABRA size)

	beqz v0, esPalindromoTrue # si v0 = 0 => palindromo true
	
	# si no es palindromo vacio el buffer PALABRA
noPalindromo:
	move    t0, zero  # t0 = 0
	sw      zero, 16(sp)      # PALABRA pos = 0
	sw      zero, 40(sp)
	b       leoByte

esPalindromoTrue:
	# buffer_word -> buffer_salida
	# (hay que fijarse que buffer salida tenga espacio suficiente)
	# si se llena buffer salida => escribirArchivo
	# buffer_salida + '\n'
	# buffer_salida.size ++
	
	lw      t2, 40(sp)  # cargo en t2 PALABRA size
	#lw  t3, 24(sp)  # cargo en t3 SALIDA pos
	add     t4, zero, zero # en t4 posicion caracter PALABRA (i = 0)
	sw 		zero, 56(sp)
	sw      zero, 76(sp)

llenarBufferSalida:
	lw      t0, 28(sp)      # cargo en t0 PALABRA addr
	lw      t1, 36(sp)      # cargo en t1 SALIDA addr
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
	lw      t1, 36(sp)      # cargo en t1 SALIDA addr
	add     t1, t1, t3      # en t1 SALIDA addr + pos
	sb      t7, 0(t1)       # SALIDA[j] = '\n'
	addi    t3, t3, 1       # j + 1
	sw      t3, 24(sp)      # guardo SALIDA pos en el stack
	add     t8, zero, 1
	sw      t8, 76(sp)
	add     t4, t4, 1
	sw      zero, 40(sp)

	beq     t3, t6, escribirArchivo # si se llena el buffer escribo (ojo con los indices)

	b leoByte


escribirArchivo:
	# write buffer_salida -> file_out
	sw      t2, 40(sp)  # cargo en t2 PALABRA size
	sw      t4, 56(sp)

	li  	v0, SYS_write   # write
	lw  	a0, 8(sp)       # cargo en a0 el fno del archivo de salida
	lw  	a1, 36(sp)      # cargo en a1 la direccion del buffer de salida
	lw  	a2, 24(sp)      # cargo en a2 el tamaño del buffer
	syscall

	bne		a3, zero, write_error    #verifico error de escritura

	lw 		t2, 84(sp) 		# busco la marca de fin de procesamiento
	bnez	t2, palindromoReturn	# si la marca esta en 1 salgo del programa

	add 	t0, zero, zero
	sw  	t0, 24(sp)      # guardo en stack SALIDA pos = 0

	lw      t2, 40(sp)  # cargo en t2 PALABRA size
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
	lw      a0, 28(sp)
	jal     myfree
	lw      a0, 32(sp)
	jal     myfree
	lw      a0, 36(sp)
	jal     myfree
	lw 		ra, 80(sp)
	j       ra
    
malloc_error_c:
	lw      a0, 32(sp)
    jal     myfree
malloc_error_b:
	lw      a0, 28(sp)
    jal     myfree
malloc_error_a:
    li	v0, SYS_exit
	li	a0, 1
	syscall

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

