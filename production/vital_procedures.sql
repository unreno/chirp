


IF OBJECT_ID ( 'vital.decode_sex', 'FN' ) IS NOT NULL
	DROP FUNCTION vital.decode_sex;
GO
CREATE FUNCTION vital.decode_sex( @code INT )
	RETURNS VARCHAR(255)
BEGIN
	-- not sure that 'TOP 1' or 'ORDER BY code' are necessary
	-- but need to ensure that return VARCHAR and not a set.
	RETURN ( SELECT TOP 1 sex FROM vital.sexes 
		WHERE code = @code 
		ORDER BY code )
END
GO


/*
FROM Format Birth.sas
	value sex
	value state
	value county
	VALUE city
	value place_prior
	value place
	value facility
	value attendant
	value marital
	value education
	value standard1_yesno
	value standard2_yesno
	value standard3_yesno
	value standard4_yesno
	value standard5_yesno
	value risk
	value ob_proc
	value c_l_d
	value method
	value presentation
	value route
	value abnormal
	value congenital
	value karotype
	value cig_pck
	value bthwt_unit
	value bwt_grp
	value gest_grp
	value pv_trims
	value evindex
	value nopnc 
	value kipca
	value age_groups
	value ethnic
	value race
	VALUE bridge_race
	value hisp_nchs
	VALUE ethnic_nchs
	value race_ethnic
	value source_pay
*/
