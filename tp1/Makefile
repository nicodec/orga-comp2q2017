PROGS  = tp1
CFLAGS = -g -Wall

all: $(PROGS)
	:

tp1: tp1.c palindrome.S mystrlen.S mymalloc.S
	$(CC) $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROGS) *.so *.o *.a *.core
