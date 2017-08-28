#!/bin/bash
echo Compiling Source
if ! gcc -Wall -o tp0 tp0.c; then
	echo Compilation Failed
	exit 1
fi
echo Compilation Success

echo Starting Test
echo "Test 1"
./tp0 -h
echo
echo

echo "Test 2"
echo
if [ -f /tmp/zero.txt ]; then
	rm /tmp/zero.txt
fi
if [ -f /tmp/out.txt ]; then
	rm /tmp/out.txt
fi
touch /tmp/zero.txt
./tp0 -i /tmp/zero.txt -o /tmp/out.txt
ls -l /tmp/out.txt
echo
echo

echo "Test 3"
echo
echo Hola M | ./tp0
echo
echo

echo "Test 4"
echo
cat entrada.txt
./tp0 -i entrada.txt -o -
