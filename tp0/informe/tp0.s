	.file	1 "tp0_3.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	N
	.data
	.align	2
	.type	N, @object
	.size	N, 4
N:
	.word	100
	.rdata
	.align	2
$LC0:
	.ascii	"Error while allocating memory at init_array\n\000"
	.text
	.align	2
	.globl	init_array
	.ent	init_array
init_array:
	.frame	$fp,40,$ra		# vars= 0, regs= 4/0, args= 16, extra= 8
	.mask	0xd0010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,36($sp)
	sw	$fp,32($sp)
	sw	$gp,28($sp)
	sw	$s0,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	sw	$a1,44($fp)
	lw	$s0,40($fp)
	lw	$v0,44($fp)
	sll	$v0,$v0,2
	move	$a0,$v0
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,0($s0)
	lw	$v0,40($fp)
	lw	$v0,0($v0)
	bne	$v0,$zero,$L18
	la	$a0,__sF+176
	la	$a1,$LC0
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L18:
	lw	$v0,40($fp)
	sw	$zero,4($v0)
	lw	$v1,40($fp)
	lw	$v0,44($fp)
	sw	$v0,8($v1)
	lw	$v1,40($fp)
	lw	$v0,44($fp)
	sw	$v0,12($v1)
	lw	$v0,40($fp)
	lw	$v0,0($v0)
	sb	$zero,0($v0)
	move	$sp,$fp
	lw	$ra,36($sp)
	lw	$fp,32($sp)
	lw	$s0,24($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	init_array
	.size	init_array, .-init_array
	.rdata
	.align	2
$LC1:
	.ascii	"Error while allocating memory at clear_array\n\000"
	.text
	.align	2
	.globl	clear_array
	.ent	clear_array
clear_array:
	.frame	$fp,40,$ra		# vars= 0, regs= 4/0, args= 16, extra= 8
	.mask	0xd0010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,36($sp)
	sw	$fp,32($sp)
	sw	$gp,28($sp)
	sw	$s0,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	lw	$v0,40($fp)
	lw	$a0,0($v0)
	la	$t9,free
	jal	$ra,$t9
	lw	$s0,40($fp)
	lw	$v0,40($fp)
	lw	$v0,12($v0)
	sll	$v0,$v0,2
	move	$a0,$v0
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,0($s0)
	lw	$v0,40($fp)
	lw	$v0,0($v0)
	bne	$v0,$zero,$L20
	la	$a0,__sF+176
	la	$a1,$LC1
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L20:
	lw	$v0,40($fp)
	sw	$zero,4($v0)
	lw	$v1,40($fp)
	lw	$v0,40($fp)
	lw	$v0,12($v0)
	sw	$v0,8($v1)
	lw	$v0,40($fp)
	lw	$v0,0($v0)
	sb	$zero,0($v0)
	move	$sp,$fp
	lw	$ra,36($sp)
	lw	$fp,32($sp)
	lw	$s0,24($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	clear_array
	.size	clear_array, .-clear_array
	.rdata
	.align	2
$LC2:
	.ascii	"Error reallocating memory\n\000"
	.text
	.align	2
	.globl	insert_char
	.ent	insert_char
insert_char:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	move	$v0,$a1
	sb	$v0,24($fp)
	lw	$v0,56($fp)
	lw	$v1,56($fp)
	lw	$a0,4($v0)
	lw	$v0,8($v1)
	bne	$a0,$v0,$L22
	lw	$v0,56($fp)
	lw	$v0,8($v0)
	sll	$v0,$v0,1
	sw	$v0,28($fp)
	lw	$v1,56($fp)
	lw	$v0,28($fp)
	sll	$v0,$v0,2
	lw	$a0,0($v1)
	move	$a1,$v0
	la	$t9,realloc
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	beq	$v0,$zero,$L23
	lw	$v1,56($fp)
	lw	$v0,32($fp)
	sw	$v0,0($v1)
	b	$L24
$L23:
	lw	$v0,56($fp)
	lw	$a0,0($v0)
	la	$t9,free
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC2
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L24:
	lw	$v1,56($fp)
	lw	$v0,28($fp)
	sw	$v0,8($v1)
$L22:
	lw	$v0,56($fp)
	lw	$v1,56($fp)
	lw	$a0,0($v0)
	lw	$v0,4($v1)
	addu	$v1,$a0,$v0
	lbu	$v0,24($fp)
	sb	$v0,0($v1)
	lw	$v1,56($fp)
	lw	$v0,56($fp)
	lw	$v0,4($v0)
	addu	$v0,$v0,1
	sw	$v0,4($v1)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	insert_char
	.size	insert_char, .-insert_char
	.align	2
	.globl	free_array
	.ent	free_array
free_array:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	lw	$v0,40($fp)
	lw	$a0,0($v0)
	la	$t9,free
	jal	$ra,$t9
	lw	$v0,40($fp)
	sw	$zero,0($v0)
	lw	$v1,40($fp)
	lw	$v0,40($fp)
	sw	$zero,4($v0)
	sw	$zero,8($v1)
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	free_array
	.size	free_array, .-free_array
	.rdata
	.align	2
$LC3:
	.ascii	"Usage: tp0 -i [input_file] -o [output_file]\n\000"
	.text
	.align	2
	.globl	print_usage
	.ent	print_usage
print_usage:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,$LC3
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_usage
	.size	print_usage, .-print_usage
	.rdata
	.align	2
$LC4:
	.ascii	"\tUsage:\n"
	.ascii	"\t\ttp0 -h\n"
	.ascii	"\t\ttp0 -V\n"
	.ascii	"\t\ttp0 [options]\n"
	.ascii	"\tOptions:\n"
	.ascii	"\t\t-V, --version\tPrint version and quit.\n"
	.ascii	"\t\t-h, --help\tPrint this information.\n"
	.ascii	"\t\t-i, --input\tLocation of the input file.\n"
	.ascii	"\t\t-o, --output\tLocation of the output file.\n"
	.ascii	"\tExamples:\n"
	.ascii	"\t\ttp0 -i ~/input -o ~/output\n\000"
	.text
	.align	2
	.globl	print_help
	.ent	print_help
print_help:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,$LC4
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_help
	.size	print_help, .-print_help
	.rdata
	.align	2
$LC5:
	.ascii	"tp0 2.0\n\000"
	.text
	.align	2
	.globl	print_version
	.ent	print_version
print_version:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,$LC5
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_version
	.size	print_version, .-print_version
	.align	2
	.globl	es_capicua
	.ent	es_capicua
es_capicua:
	.frame	$fp,32,$ra		# vars= 16, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,32
	.cprestore 0
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,32($fp)
	lw	$v0,32($fp)
	lw	$v0,4($v0)
	addu	$v0,$v0,-1
	sw	$v0,8($fp)
	lw	$v0,8($fp)
	bne	$v0,$zero,$L30
	sw	$zero,20($fp)
	b	$L29
$L30:
	li	$v0,1			# 0x1
	sw	$v0,12($fp)
	sw	$zero,16($fp)
$L31:
	lw	$v0,12($fp)
	beq	$v0,$zero,$L32
	lw	$v0,8($fp)
	srl	$v1,$v0,1
	lw	$v0,16($fp)
	sltu	$v0,$v0,$v1
	bne	$v0,$zero,$L33
	b	$L32
$L33:
	lw	$v0,32($fp)
	lw	$v1,0($v0)
	lw	$v0,16($fp)
	addu	$v0,$v1,$v0
	lb	$v0,0($v0)
	sll	$v1,$v0,1
	lw	$v0,_tolower_tab_
	addu	$v0,$v1,$v0
	addu	$a1,$v0,2
	lw	$a0,32($fp)
	lw	$v1,8($fp)
	lw	$v0,16($fp)
	subu	$v1,$v1,$v0
	lw	$v0,0($a0)
	addu	$v0,$v1,$v0
	addu	$v0,$v0,-1
	lb	$v0,0($v0)
	sll	$v1,$v0,1
	lw	$v0,_tolower_tab_
	addu	$v0,$v1,$v0
	addu	$v0,$v0,2
	lh	$v1,0($a1)
	lh	$v0,0($v0)
	beq	$v1,$v0,$L35
	sw	$zero,20($fp)
	b	$L29
$L35:
	lw	$v0,16($fp)
	addu	$v0,$v0,1
	sw	$v0,16($fp)
	b	$L31
$L32:
	li	$v0,1			# 0x1
	sw	$v0,20($fp)
$L29:
	lw	$v0,20($fp)
	move	$sp,$fp
	lw	$fp,28($sp)
	addu	$sp,$sp,32
	j	$ra
	.end	es_capicua
	.size	es_capicua, .-es_capicua
	.rdata
	.align	2
$LC6:
	.ascii	"Error leyendo caracter\n\000"
	.text
	.align	2
	.globl	read_word
	.ent	read_word
read_word:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$a0,48($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v1,24($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L37
	lw	$v0,48($fp)
	lhu	$v0,12($v0)
	srl	$v0,$v0,6
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L38
	la	$a0,__sF+176
	la	$a1,$LC6
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L38:
	sw	$zero,28($fp)
	b	$L36
$L37:
	.set	noreorder
	nop
	.set	reorder
$L39:
	lw	$v0,24($fp)
	slt	$v0,$v0,65
	bne	$v0,$zero,$L44
	lw	$v0,24($fp)
	slt	$v0,$v0,91
	bne	$v0,$zero,$L43
$L44:
	lw	$v0,24($fp)
	slt	$v0,$v0,97
	bne	$v0,$zero,$L45
	lw	$v0,24($fp)
	slt	$v0,$v0,123
	bne	$v0,$zero,$L43
$L45:
	lw	$v0,24($fp)
	slt	$v0,$v0,48
	bne	$v0,$zero,$L46
	lw	$v0,24($fp)
	slt	$v0,$v0,58
	bne	$v0,$zero,$L43
$L46:
	lw	$v1,24($fp)
	li	$v0,95			# 0x5f
	beq	$v1,$v0,$L43
	lw	$v1,24($fp)
	li	$v0,45			# 0x2d
	beq	$v1,$v0,$L43
	b	$L42
$L43:
	lb	$v0,24($fp)
	lw	$a0,52($fp)
	move	$a1,$v0
	la	$t9,insert_char
	jal	$ra,$t9
	b	$L47
$L42:
	lw	$v0,48($fp)
	lhu	$v0,12($v0)
	srl	$v0,$v0,6
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L48
	la	$a0,__sF+176
	la	$a1,$LC6
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L48:
	lw	$a0,52($fp)
	move	$a1,$zero
	la	$t9,insert_char
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,28($fp)
	b	$L36
$L47:
	lw	$a0,48($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sw	$v0,24($fp)
	b	$L39
$L36:
	lw	$v0,28($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	read_word
	.size	read_word, .-read_word
	.rdata
	.align	2
$LC7:
	.ascii	"help\000"
	.align	2
$LC8:
	.ascii	"version\000"
	.align	2
$LC9:
	.ascii	"input\000"
	.align	2
$LC10:
	.ascii	"output\000"
	.data
	.align	2
	.type	long_options.0, @object
	.size	long_options.0, 80
long_options.0:
	.word	$LC7
	.word	0
	.word	0
	.word	104
	.word	$LC8
	.word	0
	.word	0
	.word	86
	.word	$LC9
	.word	1
	.word	0
	.word	105
	.word	$LC10
	.word	1
	.word	0
	.word	111
	.word	0
	.word	0
	.word	0
	.word	0
	.rdata
	.align	2
$LC11:
	.ascii	"hVui:o:\000"
	.align	2
$LC12:
	.ascii	"r\000"
	.align	2
$LC13:
	.ascii	"can't open input file, errno = %d\n\000"
	.align	2
$LC14:
	.ascii	"w\000"
	.align	2
$LC15:
	.ascii	"Can't open output file, errno = %d\n\000"
	.align	2
$LC16:
	.ascii	"%s\n\000"
	.align	2
$LC17:
	.ascii	"Error writing at file\n\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,120,$ra		# vars= 72, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,120
	.cprestore 24
	sw	$ra,112($sp)
	sw	$fp,108($sp)
	sw	$gp,104($sp)
	move	$fp,$sp
	sw	$a0,120($fp)
	sw	$a1,124($fp)
	sw	$zero,32($fp)
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,36($fp)
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,40($fp)
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,44($fp)
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,48($fp)
	sw	$zero,52($fp)
	sw	$zero,56($fp)
	sw	$zero,60($fp)
$L50:
	addu	$v0,$fp,60
	sw	$v0,16($sp)
	lw	$a0,120($fp)
	lw	$a1,124($fp)
	la	$a2,$LC11
	la	$a3,long_options.0
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v1,32($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L52
	b	$L51
$L52:
	lw	$v0,32($fp)
	addu	$v0,$v0,-63
	sw	$v0,100($fp)
	lw	$v1,100($fp)
	sltu	$v0,$v1,49
	beq	$v0,$zero,$L59
	lw	$v0,100($fp)
	sll	$v1,$v0,2
	la	$v0,$L60
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L60:
	.gpword	$L58
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L55
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L54
	.gpword	$L56
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L59
	.gpword	$L57
	.text
$L54:
	sw	$zero,36($fp)
	b	$L50
$L55:
	sw	$zero,40($fp)
	b	$L50
$L56:
	sw	$zero,44($fp)
	lw	$v0,optarg
	sw	$v0,52($fp)
	b	$L50
$L57:
	sw	$zero,48($fp)
	lw	$v0,optarg
	sw	$v0,56($fp)
	b	$L50
$L58:
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L59:
	la	$t9,print_usage
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L51:
	lw	$v0,36($fp)
	bne	$v0,$zero,$L61
	la	$t9,print_help
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L61:
	lw	$v0,40($fp)
	bne	$v0,$zero,$L62
	la	$t9,print_version
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L62:
	la	$v0,__sF
	sw	$v0,64($fp)
	la	$v0,__sF+88
	sw	$v0,68($fp)
	lw	$v0,44($fp)
	bne	$v0,$zero,$L64
	lw	$a0,52($fp)
	la	$a1,$LC12
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,64($fp)
	lw	$v0,64($fp)
	bne	$v0,$zero,$L64
	la	$t9,__errno
	jal	$ra,$t9
	la	$a0,$LC13
	lw	$a1,0($v0)
	la	$t9,printf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,96($fp)
	b	$L49
$L64:
	lw	$v0,48($fp)
	bne	$v0,$zero,$L66
	lw	$a0,56($fp)
	la	$a1,$LC14
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,68($fp)
	lw	$v0,68($fp)
	bne	$v0,$zero,$L66
	la	$t9,__errno
	jal	$ra,$t9
	la	$a0,$LC15
	lw	$a1,0($v0)
	la	$t9,printf
	jal	$ra,$t9
	li	$v1,1			# 0x1
	sw	$v1,96($fp)
	b	$L49
$L66:
	addu	$v0,$fp,72
	move	$a0,$v0
	lw	$a1,N
	la	$t9,init_array
	jal	$ra,$t9
	addu	$v0,$fp,72
	lw	$a0,64($fp)
	move	$a1,$v0
	la	$t9,read_word
	jal	$ra,$t9
	sw	$v0,88($fp)
$L68:
	lw	$v1,88($fp)
	li	$v0,1			# 0x1
	beq	$v1,$v0,$L70
	b	$L69
$L70:
	addu	$v0,$fp,72
	move	$a0,$v0
	la	$t9,es_capicua
	jal	$ra,$t9
	beq	$v0,$zero,$L71
	lw	$a0,68($fp)
	la	$a1,$LC16
	lw	$a2,72($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	sw	$v0,92($fp)
	lw	$v0,92($fp)
	bgez	$v0,$L71
	la	$a0,__sF+176
	la	$a1,$LC17
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L71:
	addu	$v0,$fp,72
	move	$a0,$v0
	la	$t9,clear_array
	jal	$ra,$t9
	addu	$v0,$fp,72
	lw	$a0,64($fp)
	move	$a1,$v0
	la	$t9,read_word
	jal	$ra,$t9
	sw	$v0,88($fp)
	b	$L68
$L69:
	addu	$v0,$fp,72
	move	$a0,$v0
	la	$t9,free_array
	jal	$ra,$t9
	lw	$v0,44($fp)
	bne	$v0,$zero,$L73
	lw	$a0,64($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L73:
	lw	$v0,48($fp)
	bne	$v0,$zero,$L74
	lw	$a0,68($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L74:
	sw	$zero,96($fp)
$L49:
	lw	$v0,96($fp)
	move	$sp,$fp
	lw	$ra,112($sp)
	lw	$fp,108($sp)
	addu	$sp,$sp,120
	j	$ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
