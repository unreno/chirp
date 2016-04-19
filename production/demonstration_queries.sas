
/*
	ANYDTDTE30. is NEEDED for full DATETIME.
	ANYDTDTE. is will work for just DATE.
	DOB is currently just a DATE, but ANYDTDTE30. will work.
*/


LIBNAME mydb ODBC DATASRC=myodbc;
DATA june_obs;
	SET mydb.observations;
	KEEP chirp_id value;
	WHERE (concept='DEM:DOB' AND INPUT(value,ANYDTDTE30.) BETWEEN '01Jun2013'd AND '30Jun2013'd);
RUN;
PROC SORT DATA=june_obs; BY chirp_id; RUN;
PROC PRINT DATA=june_obs;
RUN;


LIBNAME mydb ODBC DATASRC=myodbc;
DATA male_obs;
	KEEP chirp_id value;
	SET mydb.observations;
	WHERE (concept='DEM:Sex' AND value='M');
RUN;
PROC SORT DATA=male_obs; BY chirp_id; RUN;
PROC PRINT DATA=male_obs;
RUN;


DATA merged_males_born_in_june_2013;
	MERGE male_obs (IN=a RENAME= (value=sex) ) june_obs (IN=b RENAME= (value=dob));
	BY chirp_id;
	IF a and b;
RUN;
PROC PRINT DATA=merged_males_born_in_june_2013; RUN;


LIBNAME mydb ODBC DATASRC=myodbc;
DATA height (rename=(value=height) );
	KEEP chirp_id value started_at;
	SET mydb.observations;
	WHERE (concept='DEM:Height');
RUN;
PROC SORT DATA=height; BY chirp_id started_at; RUN;
PROC PRINT DATA=height;
RUN;


LIBNAME mydb ODBC DATASRC=myodbc;
DATA weight (rename=(value=weight) );
	KEEP chirp_id value started_at;
	SET mydb.observations;
	WHERE (concept='DEM:Weight');
RUN;
PROC SORT DATA=weight; BY chirp_id started_at; RUN;
PROC PRINT DATA=weight;
RUN;


DATA bmi;
	MERGE height (IN=a) weight (IN=b);
	BY chirp_id started_at;
	IF a and b;
	bmi=703 * weight / height**2;
RUN;
PROC SORT DATA=bmi; BY DESCENDING bmi; RUN;
PROC PRINT DATA=bmi; RUN;


