PROGS  = tp1
CFLAGS = -g -Wall

all: $(PROGS)
	:

tp1: tp1.c palindrome.S mystrlen.S mymalloc.S
	$(CC) $(CFLAGS) -o $@ $>

tp1_3: tp1.c palindromo3.S mystrlen.S mymalloc.S testpal.S
	$(CC) $(CFLAGS) -o $@ $> 

tp5: tp1.c palindromo5.S mystrlen.S mymalloc.S testpal.S
	$(CC) $(CFLAGS) -o $@ $> 

tp1_4: tp1.c palindromo4.S mystrlen.S mymalloc.S testpal.S
	$(CC) $(CFLAGS) -o $@ $>

tpt: tp1.c palindromo6.S mystrlen.S mymalloc.S testpal.S
	$(CC) $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROGS) *.so *.o *.a *.core
