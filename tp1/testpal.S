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

    
    
return:
    move    v0, zero
	move	sp, $fp
	lw	    ra, 20(sp)
	lw	    $fp, 16(sp)
    lw	    gp, 12(sp)
	addu	sp, sp, 24
	j	    ra
	.end	testpal

    
