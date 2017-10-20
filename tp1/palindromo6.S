# palindrome.S - ver tp1.c.
#
# $Date: 2017/09/24 17:12:06 $

#include <sys/syscall.h>
#include <mips/regdef.h>

    .text
    .align  2

    .globl  palindrome
    .ent    palindrome
    
palindrome:
    .frame $fp, 84, ra
    .set    noreorder
    .cpload t9
    .set    reorder

    subu    sp, sp, 84
    
    .cprestore 60
    
    sw  ra,  72(sp)
    sw  gp,  68(sp)
    sw  $fp, 64(sp)
    
    sw  a0, 0(sp)       #file_in
    sw  a1, 4(sp)       #ibuf
    sw  a2, 8(sp)       #file_out
    sw  a3, 12(sp)      #obuf

    move    $fp, sp

    ###################################################
    #cargo los buffers necesarios para operar
    #buffer_entrada -> empty
    #buffer_word -> empty
    #bufer_salida -> empty

    li  a0, 100         # cargo el parametro para mymalloc
    sw  a0, 52(sp)      # guardo en el stack el tamaño maximo del buffer palabra
    jal mymalloc        # llamo a la funcion
    sw  v0, 28(sp)      # guardo la direccion de memoria reservada para el buffer de PALABRA
    add t0, zero, zero
    sw  t0, 40(sp)      # guardo el tamaño del buffer (incialmente vacio)
    
    lw  a0, 4(sp)       # cargo el parametro para mymalloc
    jal mymalloc        # llamo a la funcion
    sw  v0, 32(sp)      # guardo la direccion de memoria reservada para el buffer de ENTRADA
    add t0, zero, zero
    sw  t0, 44(sp)      # guardo el tamaño del buffer (incialmente vacio)

    lw  a0, 12(sp)      # cargo el parametro para mymalloc
    jal mymalloc        # llamo a la funcion
    sw  v0, 36(sp)      # guardo la direccion de memoria reservada para el buffer de SALIDA
    add t0, zero, zero
    sw  t0, 48(sp)      # guardo el tamaño del buffer (incialmente vacio)

    add t0, zero, zero
    sw  t0, 16(sp)      # guardo SALIDA pos = 0
    sw  t0, 20(sp)      # guardo ENTRADA pos = 0
    sw  t0, 24(sp)      # guardo PALABRA pos = 0

    ###################################################

leerArchivo:
    #read file_in -> buffer_entrada (I Bytes)

    li  v0, SYS_read    # ver dentro de <sys/syscall.h>.
    lw  a0, 0(sp)       # a0: file descriptor number.
    lw  a1, 32(sp)      # a1: data pointer.
    lw  a2, 4(sp)       # a2: available space.
    syscall

    bne a3, zero, read_error    #verifico error de lectura

    beqz v0, palindromoReturn # si read no lee nada finalizo el programa

    add t0, zero, zero  # en t0 cargo el indice inicial del buffer
    sw  t0, 20(sp)      # guardo en el stack ENTRADA pos
    
    sw  v0, 44(sp)      # guardo en el stack ENTRADA size

test:
    lw  a0, 32(sp)      # cargo en a0 la PALABRA addr
    lw  a1, 44(sp)      # cargo en a1 PALABRA size
    jal testpal         # esPalindromo(PALABRA addr, PALABRA size)

    bnez v0, palindromoReturn # si v0 = 0 => palindromo true

escribirArchivo:
    # write buffer_salida -> file_out
    li  v0, SYS_write   # write
    lw  a0, 8(sp)       # cargo en a0 el fno del archivo de salida
    lw  a1, 32(sp)      # cargo en a1 la direccion del buffer de salida
    lw  a2, 4(sp)      # cargo en a2 el tamaño del buffer
    syscall

    bne a3, zero, write_error    #verifico error de escritura

    b palindromoReturn

write_error:
read_error:
    li  v0, SYS_exit
    li  a0, 1
    syscall

palindromoReturn:
    move    v0, zero
    move    sp, $fp

    lw  ra,  72(sp)
    lw  gp,  68(sp)
    lw  $fp, 64(sp)

    addu    sp, sp, 84
    j       ra
    .end    palindrome

