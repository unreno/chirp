

./registry_init.bash

cat bulk_insert_birth_records.sql



INSERT INTO private.identifiers ( chirp_id, source_schema, 
    source_table, source_column, source_id ) 
  SELECT private.create_unique_chirp_id(), 'vital', 'births',
    'cert_year_num', cert_year_num 
  FROM vital.births b WHERE b.imported_to_dw = 'FALSE';

SELECT COUNT(*) FROM private.identifiers




EXEC bin.import_into_data_warehouse



