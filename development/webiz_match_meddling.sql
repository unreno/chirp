/*

DELETE FROM dbo.observations WHERE source_schema = 'webiz'
DELETE FROM private.identifiers WHERE source_schema = 'webiz'
UPDATE b SET imported_to_observations = 'FALSE' FROM webiz.immunizations b

*/

		DECLARE @year INTEGER = 2015;
		DECLARE @month INTEGER = 1;

--	DECLARE @mid_this_month DATE = CAST(CAST(@year AS VARCHAR) + '-' + CAST(@month AS VARCHAR) + '-10' AS DATE);
--	DECLARE @begin_prev_month DATE = DATEADD(m, DATEDIFF(m,0,@mid_this_month)-1,0);
--	DECLARE @end_next_month DATE = DATEADD(s,-1,DATEADD(m, DATEDIFF(m,0,@mid_this_month)+2,0));

		SELECT chirp_id, patient_id,
				birth_score + num_score + address_score + zip_score +
					first_name_score + middle_name_score + last_name_score +
					mom_first_name_score + mom_maiden_name_score + mom_last_name_score AS score,
			RANK() OVER( PARTITION BY patient_id ORDER BY
				birth_score + num_score + address_score + zip_score +
					first_name_score + middle_name_score + last_name_score +
					mom_first_name_score + mom_maiden_name_score + mom_last_name_score DESC ) AS rank


				,dob,bth_date,last_name,name_sur,first_name,name_fir
				,middle_name,name_mid
				,inf_hospnum,local_id
				,mother_last_name,mom_snam
				,mom_fnam,mother_first_name
				,mother_maiden_name,maiden_n
				,mom_address,address_line1
				,birth_score,num_score,last_name_score,first_name_score,zip_score,mom_first_name_score
				,address_score,middle_name_score,mom_last_name_score,mom_maiden_name_score

		FROM (

			SELECT i.chirp_id, s.patient_id,
				CASE WHEN b.bth_date = s.dob THEN 1.0
--					WHEN b.bth_date BETWEEN DATEADD(day,-8,s.dob) AND DATEADD(day,8,s.dob) THEN 0.5
					ELSE 0.0 END AS birth_score,

				CASE WHEN b._mom_rzip = a.zip_code THEN 0.5
					ELSE 0.0 END AS zip_score,

				CASE WHEN b._mom_address = a._address_line1 THEN 1.0
					WHEN b._mom_address = a._address_line1_prehash THEN 1.0
					WHEN b._mom_address_pre = a._address_line1_pre THEN 0.5
					WHEN b._mom_address_suf = a._address_line1_suf THEN 0.5
					ELSE 0.0 END AS address_score,

				CASE WHEN b.inf_hospnum = l.local_id THEN 2.0
					ELSE 0.0 END AS num_score,

				CASE WHEN b._name_fir = s._first_name THEN 1.0
					ELSE 0.0 END AS first_name_score,
				CASE WHEN b._name_mid = s._middle_name THEN 1.0
					ELSE 0.0 END AS middle_name_score,
				CASE WHEN ( b._name_sur IN ( s._last_name, s._last_name_pre, s._last_name_suf )
					OR b._name_sur_pre IN ( s._last_name, s._last_name_pre, s._last_name_suf )
					OR b._name_sur_suf IN ( s._last_name, s._last_name_pre, s._last_name_suf ) )
					THEN 1.0 ELSE 0.0 END AS last_name_score,

				CASE WHEN b._mom_fnam = s._mother_first_name THEN 1.0
					ELSE 0.0 END AS mom_first_name_score,
				CASE WHEN ( s._mother_last_name IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf )
					OR s._mother_last_name_pre IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf )
					OR s._mother_last_name_suf IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf ) )
					THEN 1.0 ELSE 0.0 END AS mom_last_name_score,
				CASE WHEN ( s._mother_maiden_name IN ( b._maiden_n, b._maiden_n_pre, b._maiden_n_suf )
					OR s._mother_maiden_name_pre IN ( b._maiden_n, b._maiden_n_pre, b._maiden_n_suf )
					OR s._mother_maiden_name_suf IN ( b._maiden_n, b._maiden_n_pre, b._maiden_n_suf ) )
					THEN 1.0 ELSE 0.0 END AS mom_maiden_name_score


				,s.middle_name,b.name_mid
				,s.dob,b.bth_date,s.last_name,b.name_sur,s.first_name,b.name_fir
				,b.inf_hospnum,l.local_id
				,s.mother_last_name,b.mom_snam,s.mother_first_name,b.mom_fnam
				,s.mother_maiden_name,b.maiden_n
				,b.mom_address,a.address_line1
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
--				AND s.dob BETWEEN @begin_prev_month AND @end_next_month

		) AS computing_scores
		WHERE birth_score + zip_score + address_score + num_score +
			middle_name_score + last_name_score + first_name_score +
			mom_first_name_score + mom_last_name_score + mom_maiden_name_score >= 4

--	) AS ranked
--	WHERE rank = 1;
