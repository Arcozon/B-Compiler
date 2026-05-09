#!/usr/bin/bash
if [ "$#" -eq 0 ]; then
	DIR_B="test_syntax/"
	for file in "$DIR_B"*; do
		echo -e '\e[1;36m ----- '" $file "' ----\e[0m\n' 
		./B <$file 
		echo
	done
else
	for arg in $@; do
		./B <$arg
	done
fi

