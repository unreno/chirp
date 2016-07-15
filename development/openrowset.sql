
DROP TABLE temp;
GO
CREATE TABLE temp (
	cert_yr INT,
	cert_num INT,
	name_sur VARCHAR(50),
	name_sux VARCHAR(50),
	other1 VARCHAR(50),
	name_fir VARCHAR(50),
	name_mid VARCHAR(50),
	sex INT,
	bth_date DATE,
	other2 VARCHAR(50),
	blank VARCHAR(50),
	ignore VARCHAR(MAX)
);
GO

DROP VIEW temp_view;
GO
CREATE VIEW temp_view AS SELECT
	cert_yr,
	cert_num,
	name_fir,
	name_mid,
	name_sur,
	name_sux,
	sex,
	bth_date,
	ignore
FROM temp;
GO


INSERT INTO temp_view
SELECT a.* 
FROM OPENROWSET( 
	BULK 'C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2016a.csv.psv',
	FORMATFILE = 'Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\development\births_view.fmt',
	FIRSTROW = 2
) AS a;

SELECT * FROM temp;




--	I don't understand why I need the Server Column Order AND the Server Column Name in the format file?


-- 	The column order seems to matter if using BULK INSERT, which is really stupid.
--	The name doesn't even have to be correct. Just the column order. Again. STUPID!


--	When using OPENROWSET, the name is likely more important.
--	If "SELECT *" is used, they are in the order specified, gaps ignored and named as given.
--	If using "INSERT INTO t1 SELECT * FROM t2", it will make life nice if the columns are in the same order.
--	Otherwise, ALL of the columns will need to be specified in the SELECT and/or the INSERT.
--	Make the format table order match the destination table order.
--	Not sure what to do about gaps.
--	https://msdn.microsoft.com/en-us/library/ms179250.aspx
--	For gaps, just skip a number.  Or use a bunch of 0's.

--	DO NOT skip a server order numbers!!!

--	You can skip columns in the source file, BUT NOT THE TARGET TABLE.

--	This skipping columns doesn't seem to work when
--	INSERT TO SELECT * FROM OPENROWSET();
--	Always get ...
--	Column name or number of supplied values does not match table definition.



-- *************
--
--	Likely a good idea to create a VIEW to match the FORMAT FILE.
--	The combination should allow skipping and reordering columns.
--	Make the format file and VIEW match the SOURCE FILE order.
--	Only fields in FILE to be in VIEW.
--
-- *************



--	Really not sure what to do if target table has a column that the source file
--	and therefore format file do not have. Think this will fail.
--	The fields after the missing column will be offset by 1 then dirty data.



--	This makes no sense
--	"To prevent a column in the table from receiving any data from the data file, set the server column order value to 0."




--	INSERT INTO MyTable SELECT a.* FROM  
--	OPENROWSET (BULK N'D:\data.csv', FORMATFILE = 'D:\format_no_collation.txt') AS a; 


--	Seems that the Server Column Order is more important than the Name
--	Name of the column copied from the SQL Server table. The actual name of the field is not required, but the field in the format file must not be blank.


-- Change mom_occ to Occupation and mom_occup1 to Industry (or similar and same for father)



#cert_yr|cert_num|void|name_sur|name_sux|name_fir|name_mid|sex|bth_date|birth_mo|birth_da|birth_yr|bth_time|place|facility|birth_st|birth_ci|birth_co|attendant|mom_snam|mom_xnam|mom_fnam|mom_mnam|maiden_n|mom_dob|mom_age|mom_age1|mom_bst|mom_bthcntry_fips|mom_bthstate_fips|mom_rst|mom_rci|mom_rco|mom_address|mom_apt|mom_rzip|incity|mres_cntry_fips|mres_st_fips|mres_city_fips|mres_cnty_fips|mom_edu|mom_occ|mom_occup1|mom_bus|mom_busines1|mom_ssn|fa_sname|fa_xname|fa_fname|fa_mname|fa_dob|fa_age|fa_age1|fa_bst|fa_edu|fa_occ|fa_occup1|fa_bus|fa_busines1|fa_ssn|mom_everm|married_be

