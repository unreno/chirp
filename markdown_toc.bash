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
		#	remove leading #s
		anchor=${anchor//\#}
		# remove leading whitespace characters
		anchor="${anchor#"${anchor%%[![:space:]]*}"}"
		# remove trailing whitespace characters
		anchor="${anchor%"${anchor##*[![:space:]]}"}"
		#	replace spaces with dashes
		anchor=${anchor// /-}

		#	grab the leading # string (will lose one)
		indent=${tag%#*}
		indent=${indent//\#/  }

		#	remove leading #s
		tag=${tag//\#}
		# remove leading whitespace characters
		tag="${tag#"${tag%%[![:space:]]*}"}"
		# remove trailing whitespace characters
		tag="${tag%"${tag##*[![:space:]]}"}"

#		echo "$indent* [${tag//\#}]($base#${anchor//\#})"
		echo "$indent* [${tag}]($base#${anchor})"

	done

done
