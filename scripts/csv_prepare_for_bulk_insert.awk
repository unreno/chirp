BEGIN { 
	OFS="|";
#	FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)" #	legit csv
	FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)|(\"[^,]*\")" 
#	(\"[^,]*\") is for my malformed csv
#	([^,\"]*) will match Windows' ^M's so matches end of line giving extra field
#			remove them with cat test.csv | tr -d "\r" > test2.csv 
#	I suspect the extra field will break bulk insert
}
{
	gsub("\r","");# remove windows
	for(i=1;i<=NF;i++){
		if( ($i ~ /^"/) && ($i ~ /"$/) ){
			f=substr($i,2,length($i)-2)
		}else{
			f=$i; 
		};
		gsub(/""/,"\"",f);
		printf f;
		if( i != NF) printf OFS;
	}; 
	printf "\n";
}
