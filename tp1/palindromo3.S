# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	palindrome
	.ent	palindrome
palindrome:
	.frame $fp, 60, ra
	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 60
    
	.cprestore 32
    
	sw	ra,  56(sp)
	sw	$fp, 52(sp)
	sw	gp,  48(sp)

    sw  a0, 0(sp)       #file_in
    sw  a1, 4(sp)       #ibuf
    sw  a2, 8(sp)       #file_out
    sw  a3, 12(sp)      #obuf

    move	$fp, sp

    ###################################################
    #cargo los buffers necesarios para operar
    #buffer_entrada -> empty
    #buffer_word -> empty
    #bufer_salida -> empty

    li	a0, 100		    # cargo el parametro para mymalloc
    sw  a0, 44(sp)      # guardo en el stack el tamaño maximo del buffer palabra
    jal	mymalloc	    # llamo a la funcion
    sw 	v0, 20(sp)		# guardo la direccion de memoria reservada para el buffer de PALABRA
    add t0, zero, zero
    sw  t0, 16(sp)      # guardo el tamaño del buffer (incialmente vacio)
    
    lw	a0, 4(sp)		# cargo el parametro para mymalloc
    jal	mymalloc	    # llamo a la funcion
    sw 	v0, 24(sp)		# guardo la direccion de memoria reservada para el buffer de ENTRADA
    add t0, zero, zero
    sw  t0, 36(sp)      # guardo el tamaño del buffer (incialmente vacio)

    lw	a0, 12(sp)		# cargo el parametro para mymalloc
    jal mymalloc	    # llamo a la funcion
    sw 	v0, 28(sp)		# guardo la direccion de memoria reservada para el buffer de SALIDA
    add t0, zero, zero
    sw  t0, 40(sp)      # guardo el tamaño del buffer (incialmente vacio)

    ###################################################

leerArchivo:
	#read file_in -> buffer_entrada (I Bytes)

    li	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw	a0, 0(sp)       # a0: file descriptor number.
	lw	a1, 24(sp)      # a1: data pointer.
	lw	a2, 4(sp)       # a2: available space.
	syscall

    bne	a3, zero, read_error    #verifico error de lectura

    beqz v0, palindromoReturn # si read no lee nada finalizo el programa

    add t0, zero, zero  # en t0 cargo el indice inicial del buffer
    move t9, v0         # en t9 cargo el tamaño del contenido del buffer
    

leoByte:
    beqz t9, leerArchivo # si buffer_entrada.size == 0 => leerArchivo

    # c = leo un byte <- buffer_entrada
    lw  t1, 24(sp)  # cargo la direccion del buffer de entrada en t1
    add t1, t1, t0  # a la direccion le sumo el indice
    lb  t2, 0(t1)      # c = t2, guardo en t2 el byte
    
	#buffer_entrada.size --
    sub 	t9, t9, 1
    
	# si c no es alfanumerico tengo que testear
    # si lo que hay en el buffer de word es palindromo
	slti	t3, t2, 48
	sne 	t4, t2, 45
	add 	t3, t4, t3
	beq 	t3, 2, test_palindromo
	sgt 	t3, t2, 57
	slti 	t4, t2, 65
	add		t3, t3, t4
	beq 	t3, 2, test_palindromo
	sgt 	t3, t2, 90
	slti	t4, t2, 97
	add 	t3, t3, t4
	sne 	t4, t2, 95
	add 	t3, t3, t4
	beq 	t3, 3, test_palindromo
	slti	t3, t2, 123
	beqz	t3, test_palindromo
    
	# sino: pongo a c en el buffer de palabra (voy construyendo la palabra)
    lw  t7, 20(sp) # en t7 tengo la direccion del buffer PALABRA
    lw  t8, 16(sp) # guardo en t8 el tamaño del buffer PALABRA
    add t7, t7, t8 # en t7 la direccion del char a guardar
    sb  t2, 0(t7)
    
    add 	t0, t0, 1
	# buffer_word.size ++
    addi    t8, 1
    sw      t8, 16(sp)
        
	# (ver que el buffer word no se llene)
	# (si se llena pedir mas memoria, hacer swap con memoria pedida y memoria vieja)
    
    b leoByte # vuelvo a leer un byte

test_palindromo:
	#me fijo si buffer_word es palindromo
	#si es palindromo => esPalindromoTrue
	#sino => leoByte
	
esPalindromoTrue:
	# buffer_word -> buffer_salida
	# (hay que fijarse que buffer salida tenga espacio suficiente)
	# si se llena buffer salida => escribirArchivo
	# buffer_salida + '\n'
	# buffer_salida.size ++
    
    lw  t0, 20(sp)  # en t0 addr de buffer PALABRA
    lw  t1, 28(sp)  # en t1 addr de buffer SALIDA
    lw  t2, 16(sp)  # en t2 tam buffer PALABRA
    lw  t3, 40(sp)  # en t3 tam buffer SALIDA
    add t4, zero, zero # en t4 posicion caracter PALABRA (i = 0)

    addu    t1, t1, t3 # en t1 posicion para el proximo caracter (t1 = j)

llenarBufferSalida:
    add     t0, t0, t4 
    lb      t5, 0(t0)      # t5 = PALABRA[i]
    sb      t5, 0(t1)      # SALIDA[j] = PALABRA[i]
    lw      t6, 12(sp)  # t6 tamaño maximo buffer SALIDA
    addi    t3, t3, 1   # j + 1
    
    beq     t6, t3, escribirArchivo # si se llena el buffer escribo (ojo con los indices)
    
    addi    t4, t4, 1   # i + 1

    #me fijo si no se termino la palabra
    blt t4, t2, llenarBufferSalida

    #sino => se termino la palabra -> guardo \n en buffer salida
    add t7, zero, 10    # guardo en t7 el valor 10 ('\n')
    add t1, t1, t3      # addr SALIDA + j (SALIDA [j])
    sb  t7, 0(t1)          # SALIDA[j] = '\n'
    addi    t3, t3, 1   # j + 1
    
    beq     t6, t3, escribirArchivo # si se llena el buffer escribo (ojo con los indices)

    b llenarBufferSalida

escribirArchivo:
	# write buffer_salida -> file_out
    li  v0, SYS_write
    lw  a0, 8(sp)       #cargo en a0 el fno del archivo de salida
    lw  a1, 28(sp)      #cargo en a1 la direccion del buffer de salida
    lw  a2, 40(sp)      #cargo en a2 el tamaño del buffer
    syscall

    bne	a3, zero, write_error    #verifico error de escritura

    add t0, zero, zero
    sw  t0, 40(sp)      #reinicio el tamaño del buffer a 0

    b leoByte           #vuelvo a intentar leer bytes del buffer de entrada

write_error:
read_error:
	li	v0, SYS_exit
	li	a0, 1
	syscall

palindromoReturn:
	move    v0, zero
	move	sp, $fp
	lw	    ra, 56(sp)
	lw	    $fp, 52(sp)
	addu	sp, sp, 60
	j	    ra
	.end	palindrome
    
