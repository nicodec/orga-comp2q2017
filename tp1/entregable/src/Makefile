PROGS  = tp1
CFLAGS = -g -Wall

all: $(PROGS)
	:

tp1: tp1.c palindromo.S mystrlen.S mymalloc.S testpal.S myrealloc.S check_alfaNumerico.S putch.S write_file.S cargar_buffer_salida.S
	$(CC) $(CFLAGS) -o $@ $> 
clean:
	rm -f $(PROGS) *.so *.o *.a *.core
