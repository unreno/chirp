


LIBNAME mydb ODBC DATASRC=myodbc;
DATA june_obs;
	SET mydb.observations;
	KEEP chirp_id value;
	WHERE (concept='DEM:DOB' AND INPUT(value,ANYDTDTE30.) BETWEEN '01Jun2013'd AND '30Jun2013'd);
RUN;

PROC PRINT DATA=june_obs;
RUN;



:colorscheme morning
