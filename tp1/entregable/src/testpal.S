#include <sys/syscall.h>
#include <mips/regdef.h>

	.text

    .abicalls
	.align	2

	.globl	testpal
	.ent	testpal    
testpal:

    .frame $fp, 40, ra

    #bloque para codigo pic
	.set	noreorder
	.cpload	t9
	.set	reorder

    #creo stack frame
    subu	sp, sp, 40

    #bloque para codigo pic
	.cprestore 24
    
    # salvando el callee
	sw	$fp, 28(sp)
    sw  ra, 32(sp)

    move	$fp, sp

    ####################### STACK FRAME ######################
    #   +---------------+
    # 52    |       |   \
    #   +---------------+   |
    # 48    |       |   |
    #   +---------------+   |   ABA CALLER
    # 44    |   a1  |   |
    #   +---------------+   |
    # 40    |   a0  |   /
    #   +---------------+
    # 36    |       |   \
    #   +---------------+   |
    # 32    |   ra  |   |
    #   +---------------+   |   SRA
    # 28    |   fp  |   |
    #   +---------------+   |
    # 24    |   gp  |   /
    #   +---------------+
    # 20    |       |   |   \
    #   +---------------+   |   LTA
    # 16    |       |   |   /
    #   +---------------+
    # 12    |       |   \
    #   +---------------+   |
    # 08    |       |   |
    #   +---------------+   |   ABA CALLEE
    # 04    |       |   |
    #   +---------------+   |
    # 00    |       |   /
    #   +---------------+
    
    ##################### ARGUMENTOS #######################
    sw      a0, 40($fp)
    sw      a1, 44($fp)

    #################### PSEUDOCODIGO ###########################
    ##
    ################# FIN BLOQUE DE PSEUDOCODIGO ###############

    move    t4, a1
    add     t5, zero, zero # i = 0

test:
    slti	t0, a1, 2           # si a1 (len palabra) < 2 => es palindromo
	bne	    t0, zero, esTrue

    lb      t1, 0(a0)           # t1 = palabra[i]

    move    t8, t1
    jal     to_lowercase        # lo paso a lowercase
    move    t1, t8              # t1 = tolower(palabra[i])

    sub     t2, a1, 1          # t2 = len - 1
    add     t2, t2, a0
    lb      t2, 0(t2)           # t2 = palabra[len-1]

    move    t8, t2
    jal     to_lowercase
    move    t2, t8              # t2 = tolower(palabra[len - 1])

    bne     t1, t2, esFalse     # si t1 != t2 no es palindromo

    #sino actualizo los indices

    sub     t4, t4, 1
    add     a0, a0, 1           # muevo el puntero de t8 a la siguiente letra
    sub     a1, a1, 2           # len = len - 2
    addi    t5, t5, 1           # i = i + 1

    blt     t4, t5, esTrue
    j test

esFalse:
    # si es false devuelvo 1
    addi v0, zero, 1
    j return

esTrue:
    # si es true devuelvo 0
    add v0, zero, zero
    j return

to_lowercase:
    #si la letra es uppercase la paso a lowercase solo para el procesamiento
	sgt 	t7, t8, 64
	slti	t6, t8, 91
	add 	t6, t7, t6
	beq 	t6, 2, is_upper

	j 		ra

is_upper:
	add 	t8, t8, 32
	j 		ra
    
return:

    # restauro callee-saved regs
    lw      gp, 24(sp)
	lw	    $fp, 28(sp)
    lw      ra, 32(sp)
    # destruyo stack frame
	addu	sp, sp, 40
    # vuelvo a funcion llamante
	jr	    ra
	.end	testpal

    .size   testpal,.-testpal

    .rdata
