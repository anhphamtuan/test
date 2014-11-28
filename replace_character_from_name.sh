#!/bin/bash


if [ "$1" == '' ]; then
	echo "Systax: replace_character_from_name.sh Characters need to be replaced> [Characters to replace with] [Location]"
	exit
fi

if [ $3 == '' ]; then
	location=$(pwd)
elif [ -d $3 ]; then
        location=$3
else
	echo "There is no directory named $3"
	exit
fi

filelist=$(ls ${location} | grep $1)
for file in ${filelist}; do
	newfile="$(echo $file | sed "s/$1/$2/g")"
	mv "$location/$file" "$location/$newfile"
	[ -f "$location/$newfile" ]&&{ echo $newfile; }
done	
