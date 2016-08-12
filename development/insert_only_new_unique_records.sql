
--	This is just a demo, so no actual INSERT

--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, units, source_schema, source_table, source_id, downloaded_at)
--
--		SELECT chirp_id, provider_id, started_at,
--			cav.concept, cav.value, cav.units, source_schema, source_table, source_id, downloaded_at
--		FROM (
--			SELECT i.chirp_id,
--				s.birth_date AS started_at,	-- I hope that the actual data include date lab performed
--				0 AS provider_id,
--				'health_lab' AS source_schema,
--				'newborn_screenings' AS source_table,
--				s.id AS source_id,
--				s.*,
--				imported_at AS downloaded_at
--			FROM health_lab.newborn_screenings s
--			JOIN private.identifiers i
--				ON  i.source_id     = s.accession_kit_number
--				AND i.source_column = 'accession_kit_number'
--				AND i.source_table  = 'newborn_screenings'
--				AND i.source_schema = 'health_lab'
--			WHERE imported_to_dw = 'FALSE'
--		) unimported_data
--		CROSS APPLY ( VALUES
--			('DEM:ZIP', CAST(zip_code AS VARCHAR(255)), NULL)
--		) cav ( concept, value, units )
--		WHERE cav.value IS NOT NULL
--



	SELECT new.chirp_id, new.provider_id, new.started_at, new.concept,
			new.value, new.units, new.source_schema, new.source_table,
			min_source_id AS source_id, min_downloaded_at AS downloaded_at
	FROM (
		SELECT chirp_id, provider_id, started_at, cav.concept,
			cav.value, cav.units, source_schema, source_table,
			MIN(source_id) AS min_source_id,
			MIN(downloaded_at) AS min_downloaded_at
		FROM (
			SELECT i.chirp_id,
				s.birth_date AS started_at,	-- I hope that the actual data include date lab performed
				0 AS provider_id,
				'health_lab' AS source_schema,
				'newborn_screenings' AS source_table,
				s.id AS source_id, s.*,
				imported_at AS downloaded_at
			FROM health_lab.newborn_screenings s
			JOIN private.identifiers i
				ON  i.source_id     = s.accession_kit_number
				AND i.source_column = 'accession_kit_number'
				AND i.source_table  = 'newborn_screenings'
				AND i.source_schema = 'health_lab'
			--	WHERE imported_to_dw = 'FALSE'
		) unimported_data
		CROSS APPLY ( VALUES
			('DEM:ZIP', CAST(zip_code AS VARCHAR(255)), NULL)
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL
		GROUP BY chirp_id, provider_id, started_at, cav.concept,
			cav.value, cav.units, source_schema, source_table
	) new
	LEFT JOIN dbo.observations o
	ON  new.chirp_id = o.chirp_id
	AND new.provider_id = o.provider_id
	AND new.started_at = o.started_at
	AND new.concept = o.concept
	AND new.value = o.value
	AND ISNULL(new.units,'NULL') = ISNULL(o.units,'NULL')
	AND new.source_schema = o.source_schema
	AND new.source_table = o.source_table
	WHERE o.chirp_id IS NULL

--	As units is commonly NULL, would need more thorough comparison there.
--	Of course, this only works if units is NEVER CORRECTLY 'NULL'!
--	Same with ended_at.
--	All other fields should NOT be NULL









--	Rather than GROUP BY and multiple MIN() functions which may result in data
--	from different records, although this is unlikely,
--	trying ROW_NUMBER, PARTITION BY, ORDER BY, WHERE row = 1


	SELECT chirp_id, provider_id, started_at, concept,
			value, units, source_schema, source_table,
			source_id, downloaded_at
	FROM (
		SELECT chirp_id, provider_id, started_at, cav.concept,
			cav.value, cav.units, source_schema, source_table,
			source_id, downloaded_at,
			ROW_NUMBER() OVER ( PARTITION BY
					chirp_id, provider_id, started_at, cav.concept,
					cav.value, cav.units, source_schema, source_table
				ORDER BY source_id ASC) AS row
		FROM (
			SELECT i.chirp_id,
				s.birth_date AS started_at,	-- I hope that the actual data include date lab performed
				0 AS provider_id,
				'health_lab' AS source_schema,
				'newborn_screenings' AS source_table,
				s.id AS source_id, s.*,
				imported_at AS downloaded_at
			FROM health_lab.newborn_screenings s
			JOIN private.identifiers i
				ON  i.source_id     = s.accession_kit_number
				AND i.source_column = 'accession_kit_number'
				AND i.source_table  = 'newborn_screenings'
				AND i.source_schema = 'health_lab'
			--	WHERE imported_to_dw = 'FALSE'
		) unimported_data
		CROSS APPLY ( VALUES
			('DEM:ZIP', CAST(zip_code AS VARCHAR(255)), NULL)
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL
	) rowed
	WHERE row = 1




