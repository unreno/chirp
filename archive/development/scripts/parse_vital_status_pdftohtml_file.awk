BEGIN{
	FS="<"
	split("", a)    #    empty array!
}
function shift(arr){
	rv=arr[1]
	for(i=1;i<length(arr);i++)
		arr[i]=arr[i+1]
	delete arr[length(arr)]
	return rv
}
( $2 == "br>" ){
	if( ( length(a) > 2 ) && (( $1 == "YES" ) || ( $1 == "NO" )) ){
		#    print the end of the previous line
		while( length(a) > 3 ){
			printf shift(a)
			printf ","
		}
		printf shift(a)
		printf "\n"
	}
	a[length(a)+1]=$1
}
END {
	while( length(a) > 1 ){
		printf shift(a)
		printf ","
	}
	printf shift(a)
	printf "\n"
}
