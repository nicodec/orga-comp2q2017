#include <mips/regdef.h>
#include <sys/syscall.h>

.text

.abicalls
.align 2

.globl check_alfaNumerico
.ent check_alfaNumerico

check_alfaNumerico:
	.frame $fp, 40, ra

	#bloque para codigo pic
	.set noreorder
	.cpload t9
	.set reorder

	#creo stack frame
	subu	sp, sp, 40

	#bloque para codigo pic
	.cprestore 24

	# salvando el callee
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

	move 	$fp, sp

	####################### STACK FRAME ######################
	#	+---------------+
	# 52	|		|	\
	#	+---------------+	|
	# 48	|		|	|
	#	+---------------+	|	ABA CALLER
	# 44	|		|	|
	#	+---------------+	|
	# 40	|	a0	|	/
	# 	+---------------+
	# 36	|		|	\
	# 	+---------------+	|
	# 32	|	ra	|	|
	# 	+---------------+	|	SRA
	# 28	|	fp	|	|
	# 	+---------------+	|
	# 24	|	gp	|	/
	# 	+---------------+
	# 20	|  		|	|	\
	# 	+---------------+	|	LTA
	# 16	|  		|	|	/
	# 	+---------------+
	# 12	|		|	\
	# 	+---------------+	|
	# 08	|		|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|		|	|
	# 	+---------------+	|
	# 00	|		|	/
	# 	+---------------+

	##################### ARGUMENTOS #######################
	sw	a0, 40($fp)	# a0: caracter a analizar

	#################### PSEUDOCODIGO ###########################
	##	if (t2 < '0' && t2 != '-') {
	##		return 0;
	##	} else if (t2 > '9' && t2 < 'A') {
	##		return 0;
	##	} else if (t2 > 'Z' && t2 < 'a' && t2 != '_') {
	##		return 0;
	##	} else if (t2 > 'z') {
	##		return 0;
	##	}
	##	putch(buffer_palabra, pos);
	##	return 1;
	################# FIN BLOQUE DE PSEUDOCODIGO ###############

	lb 		t2, 40($fp) 	# pongo en t2 la palabra que se va a analizar

checker:
	# chequeo si el caracter ingresado es alfanumerico o '-' o '_'
	slti    t3, t2, 48					# t2 < '0'
	sne     t4, t2, 45					# t2 != '-'
	add     t3, t4, t3
	beq     t3, 2, especial_char 		# if (t2 < '0' && t2 != '-')
	sgt     t3, t2, 57					# t2 > '9'
	slti    t4, t2, 65					# t2 < 'A'
	add     t3, t3, t4
	beq     t3, 2, especial_char 		# else if (t2 > '9' && t2 < 'A')
	sgt     t3, t2, 90					# t2 > 'Z'
	slti    t4, t2, 97					# t2 < 'a'
	add     t3, t3, t4
	sne     t4, t2, 95					# t2 != '_'
	add     t3, t3, t4
	beq     t3, 3, especial_char 		# else if (t2 > 'Z' && t2 < 'a' && t2 != '_')
	slti    t3, t2, 123					# t2 > 'z'
	beqz    t3, especial_char 			# else if (t2 > 'z')

	lw 		a0, buffer_word
	lw		a1, word_size
	move 	a2, t2
	lw 		a3, word_max_size
	jal 	putch
	sw 		a1, word_size

	b 		alfanum_char

especial_char:
	li 		v0, 0
	b 		return

alfanum_char:
	li 		v0, 1

return:
	lw	a0, 40($fp)

	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end 	check_alfaNumerico
	.size	check_alfaNumerico,.-check_alfaNumerico

	.rdata

