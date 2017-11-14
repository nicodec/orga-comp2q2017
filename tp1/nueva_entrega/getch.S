#include <mips/regdef.h>
#include <sys/syscall.h>

.text

.abicalls
.align 2

.globl getch
.ent getch

getch:
    #debugging info: descripcion del stack frame
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

    ##################### ARGUMENTOS #######################
	sw	a0, 40($fp)		# a0: file descriptor
	sw	a1, 44($fp)		# a1: puntero buffer
	sw	a2, 48($fp)		# a2: tamaño del buffer
	sw	a3, 52($fp)		# a3: posicion a extraer
    ########################################################
    move t0, a0
    move t1, a1
    move t2, a2
    move t3, a3

leoByte:
    add t1, t1, t3                  # buffer addr + pos char
    lb  t4, 0(t1)                   # cargo en t4 char
    
llenar_buffer:
    li  	v0, SYS_read            # ver dentro de <sys/syscall.h>.
	# lw  	a0, 16(sp)              # a0: file descriptor number.
	# lw  	a1, buffer_entrada      # a1: data pointer.
	# lw  	a2, entrada_size        # a2: available space.
	syscall
	bne 	a3, zero, read_error    #verifico error de lectura
    
	add 	t0, zero, zero          # en t0 cargo el indice inicial del buffer
	sw  	t0, entrada_read_pos    # guardo en el stack ENTRADA pos
	sw  	v0, 44(sp)              # guardo en el stack ENTRADA size


	
