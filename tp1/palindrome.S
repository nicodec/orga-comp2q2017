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
	.frame $fp, 48, ra
	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 48
    
	.cprestore 32
	sw	ra, 44(sp)
	sw	$fp, 40(sp)
	sw	gp, 36(sp)

    sw  a0, 0(sp)       #file_in
    sw  a1, 4(sp)       #ibuf
    sw  a2, 8(sp)       #file_out
    sw  a3, 12(sp)      #obuf

    move	$fp, sp

	li	a0, 15		# cargo el parametro para mymalloc
    jal	mymalloc	# llamo a la funcion
    sw 	v0, 20(sp)		# guardo la direccion de memoria reservada para el buffer de PALABRA

    lw	a0, 4(sp)		# cargo el parametro para mymalloc
    jal	mymalloc	# llamo a la funcion
    sw 	v0, 24(sp)		# guardo la direccion de memoria reservada para el buffer de ENTRADA

    lw	a0, 12(sp)		# cargo el parametro para mymalloc
    jal mymalloc	# llamo a la funcion
    sw 	v0, 28(sp)		# guardo la direccion de memoria reservada para el buffer de SALIDA

prog:
    li	v0, SYS_read    # ver dentro de <sys/syscall.h>.
	lw	a0, 0(sp)       # a0: file descriptor number.
	la	a1, 24(sp)      # a1: data pointer.
	lw	a2, 4(sp)          # a2: available space.
	syscall

    bne	a3, zero, read_error    #verifico error de lectura

	add 	t0, zero, zero		# indice para recorrer el buffer (i)
	move 	t9, zero			# indice para ultima letra de palabra
	la	t1, 24(sp)		# cargo la direccion del buffer de etrada en t1
	lb	t2, 0(t1)			# cargo el primer valor del buffer de entrada en t2
	lw	t7, 4(sp)
	la	t8, 20(sp)		# guardo la direccion del buffer para palabra
	beqz 	t2, buffer_write

buffer_word_read:
	beq		t0, t7, prog 
	slti	t3, t2, 48
	sne 	t4, t2, 45
	add 	t3, t4, t3
	beq 	t3, 2, palindrome_check
	sgt 	t3, t2, 57
	slti 	t4, t2, 65
	add		t3, t3, t4
	beq 	t3, 2, palindrome_check
	sgt 	t3, t2, 90
	slti	t4, t2, 97
	add 	t3, t3, t4
	sne 	t4, t2, 95
	add 	t3, t3, t4
	beq 	t3, 3, palindrome_check
	slti	t3, t2, 123
	beqz	t3, palindrome_check

	add		t9, t9, 1		# guardo el indice del final de la palabra en t9
	add		t0, t0, 1		# i = i + 1
	sb 		t2, 0(t8)		# guardo la letra en el buffer de palabra
	add 	t8, t8, 1		# paso a la siguiente posicion de memoria para letra de palabra
	add 	t1, t1, 1
	lb 		t2, 0(t1)
	j 		buffer_word_read	# sigo leyendo letras hasta econtrar un caracter que no sea alfanumerico

#en a0 tengo len
#en a1 tengo la palabra
	
palindrome_check:
	la 		t8, 20(sp)		#  guardo en t8 la direccion de la palabra
	add 	t0, t0, 1		# i = i + 1
	add 	t1, t1, 1
	lb 		t2, 0(t1)
	slti	t3, t9, 2		# me fijo que la palabra tenga mas de una letra
	bnez	t3, palindromo_fail
	sub 	t5, t9, 1		# guardo el indice de la ultima letra para operar (last = len - 1)
	move	a0, t9
	move	t6, zero		# inicio un indice para la primer letra (first = 0)

esPalindromo:
	lb  	t3, 0(t8)		# cargo en t3 el primer byte (primera letra)
	add	    t4, t5, t8		# en t4 last + a1
	lb  	t4, 0(t4)		# en t4 ultimo byte (ultima letra)
	bne	    t3, t4, palindromo_fail   # si no son iguales no es palindromo

    #sino actualizo los indices
	sub 	t5, t5, 2		# a last le resto 2 (ya iguale dos letras)
	sub 	a0, a0, 1
	add 	t6, t6, 1		# a first le sumo 1
	add		t8, t8, 1		# muevo el puntero de t8 a la siguiente letra
	blt		a0, t6, esTrue
	j	esPalindromo        # vuelvo a controlar si es palindromo

palindromo_fail:
	move	t9, zero
	j 		buffer_word_read
    
esTrue:
    #cargo la palabra en el buffer de escritura
    #si el buffer se llena lo mando al kernel y sigo escribiendo desde cero

escribirArchivo:
    li  v0, SYS_write
    lw  a0, 8(sp)       #cargo en a0 el fno del archivo de salida
    la  a1, 28(sp)      #cargo en a1 la direccion del buffer de salida
    lw  a2, 12(sp)      #cargo en a2 el tamaño del buffer (ojo! puede ser mas chico)
    #TODO

    bne	a3, zero, write_error    #verifico error de escritura

    #una vez que escribe, tengo que vaciar el buffer(poner el indice en 0)
    
    #aca tengo que volver a leer del buffer de entrada(no leer del archivo de nuevo)

    
# free_buffer:
# 	la	a0, 24(sp)
# 	jal myfree		# libero la memoria reservada para el buffer de entrada

# 	la	a0, 28(sp)
# 	jal	myfree		# libero la memoria reservada para el buffer de salida

#Si hay IO error tengo que salir
write_error:
read_error:
	li	v0, SYS_exit
	li	a0, 1
	syscall

palindrome_return:
    move    v0, t0
	move	sp, $fp
	lw	    ra, 44(sp)
	lw	    $fp, 40(sp)
	addu	sp, sp, 48
	j	    ra
	.end	palindrome
    
    
