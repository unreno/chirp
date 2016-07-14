

SELECT a.* FROM OPENROWSET( 
	BULK 'C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2016a.csv.psv',
	FORMATFILE = 'Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\development\births.fmt'
) AS a


#cert_yr|cert_num|void|name_sur|name_sux|name_fir|name_mid|sex|bth_date|birth_mo|birth_da|birth_yr|bth_time|place|facility|birth_st|birth_ci|birth_co|attendant|mom_snam|mom_xnam|mom_fnam|mom_mnam|maiden_n|mom_dob|mom_age|mom_age1|mom_bst|mom_bthcntry_fips|mom_bthstate_fips|mom_rst|mom_rci|mom_rco|mom_address|mom_apt|mom_rzip|incity|mres_cntry_fips|mres_st_fips|mres_city_fips|mres_cnty_fips|mom_edu|mom_occ|mom_occup1|mom_bus|mom_busines1|mom_ssn|fa_sname|fa_xname|fa_fname|fa_mname|fa_dob|fa_age|fa_age1|fa_bst|fa_edu|fa_occ|fa_occup1|fa_bus|fa_busines1|fa_ssn|mom_everm|married_be

