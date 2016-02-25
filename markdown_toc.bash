#!/usr/bin/env bash

#
#	Run this to generate a Github usable table of contents for the wiki
#	(run it in the wiki directory)
#

for file in *md ; do

	#	echo $file
	base=${file%.*}
	echo "* [[$base]]"
	#	ext=${file##*.}
	#	echo $ext

	#	Need to change the internal field separator so loops correctly.
	IFS=$'\n' 
	for tag in `grep "^#" $file` ; do
		#	echo $tag

		#	bash > 4.0
		#	${VARIABLE^^} converts to uppercase
		#	${VARIABLE,,} converts to lowercase
		anchor=${tag,,}
		#	remove slashes, apostrophes, 
		anchor=${anchor//\/}
		anchor=${anchor//\'}
		#	replace spaces with dashes
		anchor=${anchor// /-}

		#	grab the leading # string (will lose one)
		indent=${tag%#*}
		indent=${indent//\#/  }
		echo "$indent* [${tag//\#}]($base#${anchor//\#})"

	done

done
