
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

PROC PRINT DATA=june_obs;
RUN;

