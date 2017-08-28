#! /bin/bash

test_file() {
	if [ ! -f "$1" ]
	then
		echo -e "\e[31mNo file $1\e[0m"
	fi
	if [ ! -f "$2" ]
	then
		echo -e "\e[31mNo file $2\e[0m"	
	fi
	
	DIFF=$(diff $1 $2)
	if [ "$DIFF" != "" ]
	then
			echo -e "\e[1;31mTest failed!\e[0m"
	else
			echo -e "\e[1;32mTest passed\e[0m"
	fi
	
}

execute_program() {
	./tp0 -i $1 -o $2
}

make_test() {
	echo "Test: $1"

	> "./tests/test-${1}_in"
	> "./tests/test-${1}_out"
	> "./tests/test-${1}_expected"

	printf "$2" >> "./tests/test-${1}_in"
	printf "$3" >> "./tests/test-${1}_expected"
	
	execute_program "./tests/test-${1}_in" "./tests/test-${1}_out"
	test_file "./tests/test-${1}_out" "./tests/test-${1}_expected"
	echo
}

if [ ! -d tests ]
then
	mkdir tests
fi

rm -r ./tests/*

if [ ! -f ./tests/log_test ]
then
	touch ./tests/log_test
fi

echo Compiling Source
if ! gcc -Wall -o tp0 tp0.c; then
  echo Compilation Failed
  exit 1
fi
echo Compilation Success

echo "Starting Tests"
echo

make_test one_letter_a "a" "a\n"
make_test empty_file "" ""
make_test no_palindroms "as ba dsjais hola este test no tiene palindromos" ""
make_test p "arribalabirra somos" "arribalabirra\nsomos\n"
