
DECLARE @year INT = 2017;
DECLARE @month INT = 5;
--DECLARE @mid_this_month DATE = CAST(CAST(@year AS VARCHAR) + '-' + CAST(@month AS VARCHAR) + '-10' AS DATE);
--DECLARE @begin_prev_month DATE = DATEADD(m, DATEDIFF(m,0,@mid_this_month)-1,0);
--DECLARE @end_next_month DATE = DATEADD(s,-1,DATEADD(m, DATEDIFF(m,0,@mid_this_month)+2,0));

SELECT *, 
		birth_score + num_score + address_score +
			first_name_score + middle_name_score + last_name_score +
			mom_first_name_score + mom_maiden_name_score + mom_last_name_score AS score,
	RANK() OVER( PARTITION BY patient_id ORDER BY
		birth_score + num_score + address_score +
			first_name_score + middle_name_score + last_name_score +
			mom_first_name_score + mom_maiden_name_score + mom_last_name_score DESC ) AS rank
FROM (

	SELECT i.chirp_id, s.patient_id,
		b._date_of_birth_date, s.dob,

		CASE WHEN b._date_of_birth_date = s.dob THEN 1.0
			ELSE 0.0 END AS birth_score,
	
		b.mother_res_addr1, a.address_line1, s._address_line1,
		CASE WHEN LEN(b._mother_res_addr1) > 5 AND b._mother_res_addr1 IN ( a._address_line1, s._address_line1, a._address_line1_prehash, a._address_line1_precomma ) THEN 2.0
			WHEN b._mother_res_addr1_pre  IN ( a._address_line1_pre, s.street_number ) THEN 1.0
			WHEN b._mother_res_addr1_suf = a._address_line1_suf THEN 0.5
			ELSE 0.0 END AS address_score,
	
		b.hos_number, l.local_id,
		CASE WHEN LEN(b.hos_number) > 5 AND b.hos_number = l.local_id THEN 2.0
			WHEN LEN(b._hos_number_int) > 5 AND b._hos_number_int = l._local_id_int THEN 1.0
			ELSE 0.0 END AS num_score,

		b.plurality, b.sex, s.gender_code,
	
		b.name_first, s.first_name,
		CASE WHEN b._name_first = s._first_name THEN 2.0
			WHEN LEN(b._name_first_pre) > 5 AND b._name_first_pre = s._first_name_pre THEN 2.0
			ELSE 0.0 END AS first_name_score,
		b.name_middle, s.middle_name,
		CASE WHEN b._name_middle = s._middle_name THEN 1.0
			WHEN LEFT(b._name_middle,1) = LEFT(s._middle_name,1) THEN 0.5
			ELSE 0.0 END AS middle_name_score,
		b.name_last, s.last_name,
		CASE WHEN ( b._name_last IN ( s._last_name, s._last_name_pre, s._last_name_suf )
			OR b._name_last_pre IN ( s._last_name, s._last_name_pre, s._last_name_suf )
			OR b._name_last_suf IN ( s._last_name, s._last_name_pre, s._last_name_suf ) ) THEN 2.0
			WHEN ( 
				b._name_last IN ( s._mother_last_name, s._mother_last_name_pre, s._mother_last_name_suf,
					s._mother_maiden_name, s._mother_maiden_name_pre, s._mother_maiden_name_suf )
				OR b._name_last_pre IN ( s._mother_last_name, s._mother_last_name_pre, s._mother_last_name_suf,
					s._mother_maiden_name, s._mother_maiden_name_pre, s._mother_maiden_name_suf )
				OR b._name_last_suf IN ( s._mother_last_name, s._mother_last_name_pre, s._mother_last_name_suf,
					s._mother_maiden_name, s._mother_maiden_name_pre, s._mother_maiden_name_suf )
				OR s._last_name IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf,
					b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
				OR s._last_name_pre IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf,
					b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
				OR s._last_name_suf IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf,
					b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
			) THEN 1.0
			ELSE 0.0 END AS last_name_score,
	
		b.mother_name_first, s.mother_first_name,
		CASE WHEN b._mother_name_first = s._mother_first_name THEN 1.0
			WHEN b._mother_name_first_pre = s._mother_first_name_pre THEN 1.0
			ELSE 0.0 END AS mom_first_name_score,
		b.mother_name_last, s.mother_last_name,
		CASE WHEN ( s._mother_last_name IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf )
			OR s._mother_last_name_pre IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf )
			OR s._mother_last_name_suf IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf ) )
			THEN 1.0 ELSE 0.0 END AS mom_last_name_score,

		b.mother_name_last_p, s.mother_maiden_name,
		CASE WHEN ( s._mother_maiden_name IN 
				( b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
			OR s._mother_maiden_name_pre IN 
				( b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
			OR s._mother_maiden_name_suf IN 
				( b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf ) )
			THEN 1.0 ELSE 0.0 END AS mom_maiden_name_score
	
	FROM private.identifiers i
	JOIN vital.births b
		ON  i.source_id     = b.state_file_number
		AND i.source_column = 'state_file_number'
		AND i.source_table  = 'births'
		AND i.source_schema = 'vital'
--	CROSS JOIN webiz.immunizations s
--	Requiring same date of birth should speed things up.
	LEFT JOIN webiz.immunizations s ON b._date_of_birth_date = s.dob
	AND	(( b.sex in (1,2)  AND s.gender_code = CASE WHEN b.sex = 1 THEN 'M' WHEN b.sex = 2 THEN 'F'  END )
			OR b.sex not IN (1,2) )

	LEFT JOIN webiz.local_ids l
		ON s.patient_id = l.patient_id
	LEFT JOIN webiz.addresses a
		ON s.patient_id = a.patient_id
	LEFT JOIN private.identifiers i2
		ON  i2.source_id     = s.patient_id
		AND i2.source_column = 'patient_id'
		AND i2.source_table  = 'immunizations'
		AND i2.source_schema = 'webiz'
	WHERE YEAR(b._date_of_birth_date) = @year AND MONTH(b._date_of_birth_date) = @month
		AND i2.chirp_id IS NULL
--		AND s.dob BETWEEN @begin_prev_month AND @end_next_month

) AS computing_scores
WHERE birth_score + address_score + num_score +
	middle_name_score + last_name_score + first_name_score +
	mom_first_name_score + mom_last_name_score + mom_maiden_name_score >= 3
ORDER BY dob




