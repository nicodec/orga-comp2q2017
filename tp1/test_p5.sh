#! /bin/bash

FAILED_TESTS=0
TOTAL_TESTS=0

test_file() {
	let TOTAL_TESTS=$TOTAL_TESTS+1
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
			let FAILED_TESTS=$FAILED_TESTS+1
			echo -e "\e[1;31mTest failed!\e[0m"
	else
			echo -e "\e[1;32mTest passed\e[0m"
	fi
	
}

execute_program() {
	./tp5 -i $1 -o $2
}

make_test() {
	echo "Test: $1"

	> "./tests/test-${1}-in"
	> "./tests/test-${1}-out"
	> "./tests/test-${1}-expected"

	printf "$2" >> "./tests/test-${1}-in"
	printf "$3" >> "./tests/test-${1}-expected"
	
	execute_program "./tests/test-${1}-in" "./tests/test-${1}-out"
	test_file "./tests/test-${1}-out" "./tests/test-${1}-expected"
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

echo "Starting Tests"
echo


# ------------- Sector de PRUEBAS----------------------------------------------

make_test one_letter_a "a " "a"
make_test empty_file "" "\n"
make_test no_palindroms "as ba dsjais hola este test no tiene palindromos " "\n"
make_test todos_palindromos "arribalabirra somos " "arribalabirra\nsomos\n"
make_test varias_lineas "hola\neste es un documento con muchas lineas\nneuquen es un palindromo\ny menem tambien " "neuquen\ny\nmenem\n"
make_test all_letters "a b c d e f g h i " "a\nb\nc\nd\ne\nf\ng\nh\ni\n"
make_test case_sensitive "Somos es palindromo y NeuQuen tambien" "Somos\ny\nNeuQuen\n"
make_test numbers_and_letters "939 6a6 528dsa 528 ab " "939\n6a6\n"
make_test text_with_dash "so_m_os " "so_m_os\n"
make_test text_with_middledash "s-a-s " "s-a-s\n"
make_test text_with_dots "a.b.c " "a\nb\nc\n"
make_test long_text "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa " "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n"
# Agregar pruebas aca

# -----------------------------------------------------------------------------

echo --------------------

if [ $FAILED_TESTS == 0 ]
then
	echo -e "\e[92mAll $TOTAL_TESTS tests passed!!!\e[0m"
else
	echo -e "\e[91m Failed tests: $FAILED_TESTS from $TOTAL_TESTS\e[0m"
fi

echo --------------------
