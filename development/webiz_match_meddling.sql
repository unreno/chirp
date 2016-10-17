


		DECLARE @year INTEGER = 2015;
		DECLARE @month INTEGER = 12;

		SELECT chirp_id, patient_id,
			birth_score + zip_score + address_score + num_score +
				last_name_score + first_name_score + mom_first_name_score AS score,
			RANK() OVER( PARTITION BY patient_id ORDER BY
				birth_score + zip_score + address_score + num_score +
					last_name_score + middle_name_score + first_name_score + mom_first_name_score DESC ) AS rank
	
	
				,gender_code,sex
				,middle_name,name_mid
				,dob,bth_date,last_name,name_sur,first_name,name_fir
				,inf_hospnum,local_id
--	so few have ssns
--				,ssn_child,ssn
				,mother_last_name,mom_snam,mom_fnam,mother_first_name
				,mother_maiden_name,maiden_n
				,_mom_address,_mom_address_pre,_mom_address_suf
				,_address_line1,_address_line1_pre,_address_line1_suf
				,mom_rzip,zip_code
				,birth_score,num_score,last_name_score,first_name_score,zip_score,mom_first_name_score,address_score,middle_name_score
				
		FROM (

			SELECT i.chirp_id, s.patient_id,
				CASE WHEN b.bth_date = s.dob THEN 1.0
					WHEN b.bth_date BETWEEN DATEADD(day,-8,s.dob) AND DATEADD(day,8,s.dob) THEN 0.5
					ELSE 0.0 END AS birth_score,

				CASE WHEN b._mom_rzip = a.zip_code THEN 1.0
					ELSE 0.0 END AS zip_score,

				CASE WHEN b._mom_address = a._address_line1 THEN 1.0
					WHEN b._mom_address_pre = a._address_line1_pre THEN 0.5
					WHEN b._mom_address_suf = a._address_line1_suf THEN 0.5
					ELSE 0.0 END AS address_score,

				CASE WHEN b.inf_hospnum = l.local_id THEN 1.0
					ELSE 0.0 END AS num_score,

				CASE WHEN ( s._mother_last_name IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mother_last_name_pre IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mother_last_name_suf IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mother_maiden_name IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mother_maiden_name_pre IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mother_maiden_name_suf IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._last_name IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._last_name_pre IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._last_name_suf IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					) THEN 1.0 ELSE 0.0 END AS last_name_score,

				CASE WHEN b._name_fir = s._first_name THEN 0.5
					ELSE 0.0 END AS first_name_score,
				CASE WHEN b._name_mid = s._middle_name THEN 0.5
					ELSE 0.0 END AS middle_name_score,
				CASE WHEN b._mom_fnam = s._mother_first_name THEN 1.0
					ELSE 0.0 END AS mom_first_name_score
				
				,s.gender_code,b.sex
				,s.middle_name,b.name_mid
				,s.dob,b.bth_date,s.last_name,b.name_sur,s.first_name,b.name_fir
				,b.inf_hospnum,l.local_id
--				,b.ssn_child,s.ssn
				,s.mother_last_name,b.mom_snam,s.mother_first_name,b.mom_fnam
				,s.mother_maiden_name,b.maiden_n
				,b._mom_address,b._mom_address_pre,b._mom_address_suf
				,a._address_line1,a._address_line1_pre,a._address_line1_suf
				,b.mom_rzip,a.zip_code
				
			FROM private.identifiers i
			JOIN vital.births b
				ON  i.source_id     = b.cert_year_num
				AND i.source_column = 'cert_year_num'
				AND i.source_table  = 'births'
				AND i.source_schema = 'vital'
			CROSS JOIN webiz.immunizations s
			LEFT JOIN webiz.local_ids l
				ON s.patient_id = l.patient_id
			LEFT JOIN webiz.addresses a
				ON s.patient_id = a.patient_id
			LEFT JOIN private.identifiers i2
				ON  i2.source_id     = s.patient_id
				AND i2.source_column = 'patient_id'
				AND i2.source_table  = 'immunizations'
				AND i2.source_schema = 'webiz'
			WHERE b._bth_date_year = @year AND b._bth_date_month = @month
				AND i2.chirp_id IS NULL

				AND s._dob_year = @year AND s._dob_month = @month

		) AS computing_scores
		WHERE birth_score + zip_score + address_score + num_score + middle_name_score +
			last_name_score + first_name_score + mom_first_name_score >= 3

--	) AS ranked
--	WHERE rank = 1;
