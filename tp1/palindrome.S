# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

    .text
	.align	2
    .abicalls
	.globl	palindrome
	.ent	palindrome
palindrome:
    .frame $fp, 40, ra # ver el 40
    .set noreorder
    .cpload tq
    .set reorder
    subu sp, sp, 40 # ver 40 creo stack
    sw	ra, 40(sp) #guardo el ra en stack
	sw	$fp, 36(sp)	#guardo el fp en stack
    sw	gp, 32(sp) #guardo el gp en stack
    sw	a0, 0(sp) #guardo el 1er parametro N en el stack  en stack
	sw	a1, 4(sp) #guardo el 2do parametro N en el stack  en stack
	sw	a2, 8(sp) #guardo el 3er parametro N en el stack  en stack
	sw	a3, 12(sp) #guardo el 4to parametro N en el stack  en stack
    
    
    
    
