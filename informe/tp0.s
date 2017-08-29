	.file	1 "tp0.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
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
	la	$a0,$LC0
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
$LC1:
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
	la	$a0,$LC1
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
$LC2:
	.ascii	"tp0 1.0\n\000"
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
	la	$a0,$LC2
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
	lw	$a0,56($fp)
	la	$t9,strlen
	jal	$ra,$t9
	sw	$v0,24($fp)
	li	$v0,1			# 0x1
	sw	$v0,28($fp)
	sw	$zero,32($fp)
$L21:
	lw	$v0,28($fp)
	beq	$v0,$zero,$L22
	lw	$v0,24($fp)
	srl	$v1,$v0,1
	lw	$v0,32($fp)
	sltu	$v0,$v0,$v1
	bne	$v0,$zero,$L23
	b	$L22
$L23:
	lw	$v1,56($fp)
	lw	$v0,32($fp)
	addu	$v0,$v1,$v0
	lb	$v0,0($v0)
	sll	$v1,$v0,1
	lw	$v0,_tolower_tab_
	addu	$v0,$v1,$v0
	addu	$a0,$v0,2
	lw	$v1,24($fp)
	lw	$v0,32($fp)
	subu	$v1,$v1,$v0
	lw	$v0,56($fp)
	addu	$v0,$v1,$v0
	addu	$v0,$v0,-1
	lb	$v0,0($v0)
	sll	$v1,$v0,1
	lw	$v0,_tolower_tab_
	addu	$v0,$v1,$v0
	addu	$v0,$v0,2
	lh	$v1,0($a0)
	lh	$v0,0($v0)
	beq	$v1,$v0,$L25
	sw	$zero,36($fp)
	b	$L20
$L25:
	lw	$v0,32($fp)
	addu	$v0,$v0,1
	sw	$v0,32($fp)
	b	$L21
$L22:
	li	$v0,1			# 0x1
	sw	$v0,36($fp)
$L20:
	lw	$v0,36($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	es_capicua
	.size	es_capicua, .-es_capicua
	.rdata
	.align	2
$LC3:
	.ascii	" %1023s\000"
	.text
	.align	2
	.globl	read_word
	.ent	read_word
read_word:
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
	sw	$a1,44($fp)
	lw	$a0,40($fp)
	la	$a1,$LC3
	lw	$a2,44($fp)
	la	$t9,fscanf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	read_word
	.size	read_word, .-read_word
	.rdata
	.align	2
$LC4:
	.ascii	"help\000"
	.align	2
$LC5:
	.ascii	"version\000"
	.align	2
$LC6:
	.ascii	"input\000"
	.align	2
$LC7:
	.ascii	"output\000"
	.data
	.align	2
	.type	long_options.0, @object
	.size	long_options.0, 80
long_options.0:
	.word	$LC4
	.word	0
	.word	0
	.word	104
	.word	$LC5
	.word	0
	.word	0
	.word	86
	.word	$LC6
	.word	1
	.word	0
	.word	105
	.word	$LC7
	.word	1
	.word	0
	.word	111
	.word	0
	.word	0
	.word	0
	.word	0
	.rdata
	.align	2
$LC8:
	.ascii	"hVui:o:\000"
	.align	2
$LC9:
	.ascii	"archivo entrada: %s\n\000"
	.align	2
$LC10:
	.ascii	"archivo salida: %s\n\000"
	.align	2
$LC11:
	.ascii	"r\000"
	.align	2
$LC12:
	.ascii	"can't open input file, errno = %d\n\000"
	.align	2
$LC13:
	.ascii	"w\000"
	.align	2
$LC14:
	.ascii	"Can't open output file, errno = %d\n\000"
	.align	2
$LC15:
	.ascii	"%s\n\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,1128,$ra		# vars= 1080, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,1128
	.cprestore 24
	sw	$ra,1120($sp)
	sw	$fp,1116($sp)
	sw	$gp,1112($sp)
	move	$fp,$sp
	sw	$a0,1128($fp)
	sw	$a1,1132($fp)
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
$L28:
	addu	$v0,$fp,60
	sw	$v0,16($sp)
	lw	$a0,1128($fp)
	lw	$a1,1132($fp)
	la	$a2,$LC8
	la	$a3,long_options.0
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v1,32($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L30
	b	$L29
$L30:
	lw	$v0,32($fp)
	addu	$v0,$v0,-63
	sw	$v0,1108($fp)
	lw	$v1,1108($fp)
	sltu	$v0,$v1,49
	beq	$v0,$zero,$L37
	lw	$v0,1108($fp)
	sll	$v1,$v0,2
	la	$v0,$L38
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L38:
	.gpword	$L36
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L33
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L32
	.gpword	$L34
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L37
	.gpword	$L35
	.text
$L32:
	sw	$zero,36($fp)
	b	$L28
$L33:
	sw	$zero,40($fp)
	b	$L28
$L34:
	sw	$zero,44($fp)
	lw	$v0,optarg
	sw	$v0,52($fp)
	b	$L28
$L35:
	sw	$zero,48($fp)
	lw	$v0,optarg
	sw	$v0,56($fp)
	b	$L28
$L36:
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L37:
	la	$t9,print_usage
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L29:
	lw	$v0,36($fp)
	bne	$v0,$zero,$L39
	la	$t9,print_help
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L39:
	lw	$v0,40($fp)
	bne	$v0,$zero,$L40
	la	$t9,print_version
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L40:
	la	$a0,$LC9
	lw	$a1,52($fp)
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC10
	lw	$a1,56($fp)
	la	$t9,printf
	jal	$ra,$t9
	la	$v0,__sF
	sw	$v0,64($fp)
	la	$v0,__sF+88
	sw	$v0,68($fp)
	lw	$v0,44($fp)
	bne	$v0,$zero,$L42
	lw	$a0,52($fp)
	la	$a1,$LC11
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,64($fp)
	lw	$v0,64($fp)
	bne	$v0,$zero,$L42
	la	$t9,__errno
	jal	$ra,$t9
	la	$a0,$LC12
	lw	$a1,0($v0)
	la	$t9,printf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,1104($fp)
	b	$L27
$L42:
	lw	$v0,48($fp)
	bne	$v0,$zero,$L44
	lw	$a0,56($fp)
	la	$a1,$LC13
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,68($fp)
	lw	$v0,68($fp)
	bne	$v0,$zero,$L44
	la	$t9,__errno
	jal	$ra,$t9
	la	$a0,$LC14
	lw	$a1,0($v0)
	la	$t9,printf
	jal	$ra,$t9
	li	$v1,1			# 0x1
	sw	$v1,1104($fp)
	b	$L27
$L44:
	li	$v0,1			# 0x1
	sw	$v0,72($fp)
$L46:
	lw	$v1,72($fp)
	li	$v0,1			# 0x1
	beq	$v1,$v0,$L48
	b	$L47
$L48:
	addu	$v0,$fp,80
	lw	$a0,64($fp)
	move	$a1,$v0
	la	$t9,read_word
	jal	$ra,$t9
	sw	$v0,72($fp)
	addu	$v0,$fp,80
	move	$a0,$v0
	la	$t9,es_capicua
	jal	$ra,$t9
	beq	$v0,$zero,$L46
	addu	$v0,$fp,80
	lw	$a0,68($fp)
	la	$a1,$LC15
	move	$a2,$v0
	la	$t9,fprintf
	jal	$ra,$t9
	b	$L46
$L47:
	lw	$v0,44($fp)
	bne	$v0,$zero,$L50
	lw	$a0,64($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L50:
	lw	$v0,48($fp)
	bne	$v0,$zero,$L51
	lw	$a0,68($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L51:
	sw	$zero,1104($fp)
$L27:
	lw	$v0,1104($fp)
	move	$sp,$fp
	lw	$ra,1120($sp)
	lw	$fp,1116($sp)
	addu	$sp,$sp,1128
	j	$ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
