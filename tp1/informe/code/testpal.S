#include <sys/syscall.h>
#include <mips/regdef.h>

	.text
	.align	2

	.globl	testpal
	.ent	testpal    
testpal:
    .frame $fp, 24, ra
	.set	noreorder
	.cpload	t9
	.set	reorder
    subu	sp, sp, 24
	.cprestore 32
    
	sw	ra, 20(sp)
	sw	$fp, 16(sp)
	sw	gp, 12(sp)

    move	$fp, sp

    add     t9, zero, zero # i = 0

test:
    slti	t0, a1, 2           # si a1 (len palabra) < 2 => es palindromo
	bne	    t0, zero, returnTrue

    add     a0, a0, t9          # palabra[i]
    lb      t1, 0(a0)           # t1 = palabra[i]

    move    t8, t1
    jal     to_lowercase        # lo paso a lowercase
    move    t1, t8              # t1 = tolower(palabra[i])


    addi    t2, a1, -1          # t2 = len - 1
    add     t2, t2, a0
    lb      t2, 0(t2)           # t2 = palabra[len-1]

    move    t8, t2
    jal     to_lowercase
    move    t2, t8              # t2 = tolower(palabra[len - 1])

    bne     t1, t2, esFalse     # si t1 != t2 no es palindromo

    #sino actualizo los indices

    sub     a1, a1, 2           # len = len - 2
    addi    t9, t9, 1           # i = i + 1

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
    lw	    gp, 12(sp)
	addu	sp, sp, 24
	j	    ra
	.end	testpal

    
