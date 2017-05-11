#!/usr/bin/env bash


#	bcp "DECLARE @colnames VARCHAR(max);SELECT @colnames = COALESCE(@colnames + CHAR(9), '') + column_name from chirp.INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='observations'; select @colnames;" queryout HeadersOnly.tsv -c -T
#	bcp "SELECT * FROM chirp.dbo.observations" queryout DataOnly.tsv -c -T
#	cat HeadersOnly.tsv DataOnly.tsv > Observations.tsv
#	awk 'BEGIN{FS="\t"}{print NF}' Observations.tsv | uniq




