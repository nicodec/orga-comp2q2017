#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	testpal
	.ent	testpal    
testpal:
    .frame $fp, 36, ra
	.set	noreorder
	.cpload	t9
	.set	reorder

    subu	sp, sp, 36

	.cprestore 24
    
	sw	ra,  20(sp)
	sw	$fp, 16(sp)
    sw	a0,  0(sp)
	sw	a1, 4(sp)
    sw  t4, 28(sp)          # no estoy seguro de si se usan previamente por lo tanto los guardo para prevenir sobreescritura
    sw  t5, 32(sp)

    move	$fp, sp

    move    t4, a1
    add     t5, zero, zero # i = 0

test:
    slti	t0, a1, 2           # si a1 (len palabra) < 2 => es palindromo
	bne	    t0, zero, esTrue

    #add     a0, a0, t5          # palabra[i]
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
	sgt 	t7, t8, 64
	slti	t6, t8, 91
	add 	t6, t7, t6
	beq 	t6, 2, is_upper
	#move 	v0, t8
	j 		ra

is_upper:
	add 	t8, t8, 32
	j 		ra
    
return:
	move	sp, $fp
	lw	    ra, 20(sp)
	lw	    $fp, 16(sp)
    lw      t4, 28(sp)
    lw      t5, 32(sp)
	addu	sp, sp, 36
	j	    ra
	.end	testpal

    
