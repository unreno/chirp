#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.


cat << EOF

-- MS Sets these before every “CREATE TRIGGER”
-- Not sure if calling them once will suffice.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF db_id('chirp') IS NOT NULL
	DROP DATABASE chirp;

CREATE DATABASE chirp;
GO
USE chirp;

--Wanted to see these Database Diagrams and this seemed to work.
ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];

IF OBJECT_ID('debug_log', 'U') IS NOT NULL
	DROP TABLE debug_log;
CREATE TABLE debug_log ( message text, logged_at DATETIME DEFAULT CURRENT_TIMESTAMP );
GO
IF OBJECT_ID ( 'log', 'P' ) IS NOT NULL
	DROP PROCEDURE log;
GO
CREATE PROCEDURE log(@msg TEXT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO debug_log ( message )
	VALUES ( @msg );
END
GO

EOF


cat create_identifiers.tsql

cat create_warehouse.tsql

cat create_vital_records.tsql
