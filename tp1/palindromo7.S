# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
    .align 2

	.globl  palindrome
	.ent    palindrome

    # a0 file_in
	# a1 ibuf
	# a2 file_out
	# a3 obuf
	
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
	
	move    $fp, sp

    move t0, a0
    move t1, a1
    move t2, a2
    move t3, a3

	################## BUFFERS ########################
	# cargo los buffers necesarios para operar
	# buffer_entrada -> empty
	# buffer_word -> empty
	# bufer_salida -> empty
    ###################################################

    ########### BUFFER PALABRA ################################################
    
    li  a0, 100             # cargo el parametro para mymalloc
	sw  a0, 52(sp)          # guardo en el stack el tamaño maximo del buffer palabra
	jal mymalloc            # llamo a la funcion
    beqz v0, malloc_error_a # verifico error de mymalloc
	sw  v0, 28(sp)          # guardo la direccion de memoria reservada para el buffer de PALABRA
    
	add t4, zero, zero
	sw  t4, 40(sp)          # guardo el tamaño del buffer (incialmente vacio)

    ########## BUFFER ENTRADA #################################################
	
	move a0, t1             # cargo el parametro para mymalloc
	jal mymalloc            # llamo a la funcion
    beqz v0, malloc_error_b # verifico error de mymalloc
	sw  v0, 32(sp)          # guardo la direccion de memoria reservada para el buffer de ENTRADA
	add t4, zero, zero
	sw  t4, 44(sp)          # guardo el tamaño del buffer (incialmente vacio)

    ########## BUFFER SALIDA ##################################################

	move a0, t3             # cargo el parametro para mymalloc
	jal mymalloc            # llamo a la funcion
    beqz v0, malloc_error_c # verifico error de mymalloc
	sw  v0, 36(sp)          # guardo la direccion de memoria reservada para el buffer de SALIDA
	add t4, zero, zero
	sw  t4, 48(sp)          # guardo el tamaño del buffer (incialmente vacio)

    ########## GUARDO LAS POSICIONES DE LOS BUFFERS ###########################

	sw 	zero, 84(sp)	    # marca fin de proceso
	add t4, zero, zero
	sw  t4, 16(sp)          # guardo SALIDA pos = 0
	sw  t4, 20(sp)          # guardo ENTRADA pos = 0
	sw  t4, 24(sp)          # guardo PALABRA pos = 0

	###########################################################################

    add t0, zero, zero          # i = 0
    
cargar_caracter:
    sw t0, i_pos_stack          # respaldo t0
    jal getc                    # llamo a getc
    lb t1, 0(v0)                # t1 = c
    beq t1, EOF, palindromoReturn
    sb t1, char_stack
    
    move a0, t1                 # cargo en a0 c para llamar a test_alfanumerico
    jal test_alfanumerico       # llamo a test_alfanumerico
    beqz v0, test_palindromo    # si c no es alfanumerico voy a ver si es palindromo

    ########## sino agrego c a palabra #############
    lw t0, i_pos_stack          # cargo i del stack
    lb  t1, char_stack          # cargo c del stack
    lw t2, PALABRA_addr         # cargo PALABRA addr del stack
    add t2, t2, t0              # palabra[i]
    sb  t1, 0(t3)               # palabra[i] = c
    addi t1, t2, 1              # i++
    b cargar_caracter
    ################################################

test_palindromo:
    add t0, zero, zero          # i = 0
    sw  t0, i_pos_stack         # guardo i en el stack
    
    lw a0, PALABRA_addr         # cargo PALABRA addr del stack
    jal test_pal                # llamo a test_pal
    
    beqz v0, palindromo_true    # si v0 == 0 entonces es palindromo
    b cargar_caracter

palindromo_true:
    # cargar parametros de guardar_palabra
    guardar_palabra
    b cargar_caracter

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
	sw 		ra, 80(sp)
	lw      a0, 28(sp)
	jal     myfree
	lw      a0, 32(sp)
	jal     myfree
	lw      a0, 36(sp)
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
    
