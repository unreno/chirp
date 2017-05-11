#!/usr/bin/env bash




#--
#--	Some stray double quotes and extra tabs muck things up so remove them.
#--	cat "20161130 CHIRP address hist export 2010.txt.original" | tr -d \" | tr -d "\t" > "20161130 CHIRP address hist export 2010.txt"
#--
#SELECT COUNT(1) FROM webiz.addresses_buffer
#--	0
#EXEC bin.import_webiz_addresses 'C:\Users\gwendt\Desktop\Data\WebIZ\20161130 CHIRP address hist export 2010.txt'
#--	SELECT * FROM webiz.addresses_buffer
#SELECT COUNT(1) FROM webiz.addresses_buffer
#--	110800
#SELECT COUNT(1) FROM webiz.addresses
#--	0
#INSERT INTO webiz.addresses SELECT * FROM webiz.addresses_buffer
#DELETE FROM webiz.addresses_buffer
#SELECT COUNT(1) FROM webiz.addresses
#--	110800
#
#
#--
#--	Some stray double quotes and extra tabs muck things up so remove them.
#--	Also, some fields contain a carriage return so need to join these short lines.
#--	Fortunately, they are predictable
#--	cat "20161130 CHIRP immunizations export 2010.txt.original" | tr -d \" | tr -d "\t" | awk -F\| '(NF == 43){ print } (NF == 37){ s=$0 } (NF == 7){ print s$0 }'  > "20161130 CHIRP immunizations export 2010.txt"
#--
#
#
#--
#SELECT COUNT(1) FROM webiz.immunizations_buffer
#--	0
#EXEC bin.import_webiz_immunizations 'C:\Users\gwendt\Desktop\Data\WebIZ\20161130 CHIRP immunizations export 2010.txt'
#--	SELECT * FROM webiz.immunizations_buffer
#SELECT COUNT(1) FROM webiz.immunizations_buffer
#--	671038
#SELECT COUNT(1) FROM webiz.immunizations
#--	0
#INSERT INTO webiz.immunizations SELECT * FROM webiz.immunizations_buffer
#DELETE FROM webiz.immunizations_buffer
#SELECT COUNT(1) FROM webiz.immunizations
#--	671038
#
#
#SELECT COUNT(1) FROM webiz.insurances_buffer
#--	0
#EXEC bin.import_webiz_insurances 'C:\Users\gwendt\Desktop\Data\WebIZ\20161130 CHIRP insurance export 2010.txt'
#--	SELECT * FROM webiz.insurances_buffer
#SELECT COUNT(1) FROM webiz.insurances_buffer
#--	3801
#SELECT COUNT(1) FROM webiz.insurances
#--	0
#INSERT INTO webiz.insurances SELECT * FROM webiz.insurances_buffer
#DELETE FROM webiz.insurances_buffer
#SELECT COUNT(1) FROM webiz.insurances
#--	3801
#
#
#SELECT COUNT(1) FROM webiz.local_ids_buffer
#--	0
#EXEC bin.import_webiz_local_ids 'C:\Users\gwendt\Desktop\Data\WebIZ\20161130 CHIRP local id export 2010.txt'
#--	SELECT * FROM webiz.local_ids_buffer
#SELECT COUNT(1) FROM webiz.local_ids_buffer
#--	46363	--	43867
#SELECT COUNT(1) FROM webiz.local_ids
#--	0
#INSERT INTO webiz.local_ids SELECT * FROM webiz.local_ids_buffer
#DELETE FROM webiz.local_ids_buffer
#SELECT COUNT(1) FROM webiz.local_ids
#--	46363	--	43867
#
#SELECT COUNT(1) FROM webiz.races_buffer
#--	0
#EXEC bin.import_webiz_races 'C:\Users\gwendt\Desktop\Data\WebIZ\20161130 CHIRP race ethn export 2010.txt'
#--	SELECT * FROM webiz.races_buffer
#SELECT COUNT(1) FROM webiz.races_buffer
#--	54468	--	53088
#SELECT COUNT(1) FROM webiz.races
#--	0
#INSERT INTO webiz.races SELECT * FROM webiz.races_buffer
#DELETE FROM webiz.races_buffer
#SELECT COUNT(1) FROM webiz.races
#--	54468	--	53088






