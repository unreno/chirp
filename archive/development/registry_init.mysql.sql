
DROP DATABASE IF EXISTS chirp;
CREATE DATABASE chirp;
CONNECT chirp;

DROP TABLE IF EXISTS debug_log; 

CREATE TABLE debug_log ( message text, logged_at DATETIME );

-- Unique constraints allow multiple NULLs (at least in MySQL)

-- Use their birthid or our id as PK?
CREATE TABLE births (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	number VARCHAR(255) NOT NULL,
	birthid INT,		-- probably unique
	birth2id INT,		-- probably unique
	medicalid INT,
	hearingbid INT,
	event_year INT,
	local_file_number VARCHAR(15),		-- probably unique
	state_file_number VARCHAR(11),		-- probably unique
	local_reg_number VARCHAR(15),		-- probably unique
	dob DATE,
	first_name VARCHAR(255),
	middle_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(1),
	imported_at DATETIME
);
ALTER TABLE births
	ADD CONSTRAINT unique_number UNIQUE (number);
ALTER TABLE births
	ADD CONSTRAINT unique_birthid UNIQUE (birthid);
ALTER TABLE births
	ADD CONSTRAINT unique_birth2id UNIQUE (birth2id);
ALTER TABLE births
	ADD CONSTRAINT unique_local_file_number UNIQUE (local_file_number);
ALTER TABLE births
	ADD CONSTRAINT unique_state_file_number UNIQUE (state_file_number);
ALTER TABLE births
	ADD CONSTRAINT unique_local_reg_number UNIQUE (local_reg_number);

CREATE TABLE birth2s (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	birthid INT,		-- probably unique
	birth2id INT		-- probably unique
);
ALTER TABLE birth2s
	ADD CONSTRAINT unique_birthid UNIQUE (birthid);
ALTER TABLE birth2s
	ADD CONSTRAINT unique_birth2id UNIQUE (birth2id);


-- Use their deathid or our id as PK?
CREATE TABLE deaths (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	number VARCHAR(255) NOT NULL,
	deathid INT,		-- probably unique
	death2id INT,		-- probably unique
	event_year INT,
	state_file_number VARCHAR(11),		-- probably unique
	local_file_number VARCHAR(15),		-- probably unique
	record_status VARCHAR(30),
	reg_type_code VARCHAR(10),
	local_reg_number VARCHAR(15),		-- probably unique
	permit_number VARCHAR(15),
	dob DATE,
	first_name VARCHAR(255),
	middle_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(1),
	imported_at DATETIME
);
ALTER TABLE deaths
	ADD CONSTRAINT unique_deathid UNIQUE (deathid);
ALTER TABLE deaths
	ADD CONSTRAINT unique_death2id UNIQUE (death2id);
ALTER TABLE deaths
	ADD CONSTRAINT unique_state_file_number UNIQUE (state_file_number);
ALTER TABLE deaths
	ADD CONSTRAINT unique_local_file_number UNIQUE (local_file_number);
ALTER TABLE deaths
	ADD CONSTRAINT unique_local_reg_number UNIQUE (local_reg_number);

CREATE TABLE death2s (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	deathid INT,		-- probably unique
	death2id INT		-- probably unique
);
ALTER TABLE death2s
	ADD CONSTRAINT unique_deathid UNIQUE (deathid);
ALTER TABLE death2s
	ADD CONSTRAINT unique_death2id UNIQUE (death2id);


CREATE TABLE renowns (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	number VARCHAR(255) NOT NULL,
	dob DATE,
	first_name VARCHAR(255),
	middle_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(1),
	imported_at DATETIME
);


CREATE TABLE identifiers (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	chirp_id VARCHAR(255) NOT NULL,
	source_name VARCHAR(255) NOT NULL,
	source_id VARCHAR(255) NOT NULL,
	created_at DATETIME
);


--	This only forces unique (in mysql) when both fields exist!
ALTER TABLE identifiers
	ADD CONSTRAINT unique_source_name_and_id UNIQUE (source_name,source_id);


--	NEED to wrap trigger definitions in some type of delimiter
/*

	sql server -> mysql syntax differences
	declares on separate lines.
	No @ symbol in variable names? Docs say should?
	Use sets rather than selects
	User "for each row" rather than "AS"
	while loop starts with "DO" and not "BEGIN"
	and ends with "END WHILE" and not just "END"

	SQL Server doesn't do Triggers BEFORE?

	SQL Server REQUIRES a GO before creating triggers
		and after them can flush commands so good there too.

	ENDs need ; suffix

	Each PROCEDURE or TRIGGER needs to be defined "on a single line".
	That line ends with the current delimiter, which by default is ";".
	To fix this, redefine the delimiter with the DELIMITER command
	to something that IS NOT USED in your code.
	"DELIMITER |" or "DELIMITER &&" are common.
	More than one PROCEDURE or TRIGGER can be defined on a single line
	but can be separated by this newly defined delimiter.
	After these are defined, reset the delimiter to ";".
	DELIMITER ;
	I'm rather surprised that mysql doesn't recognize
	that the PROCEDURE or TRIGGER is incomplete.

*/

DELIMITER |

CREATE TRIGGER identifiers_before_insert
	BEFORE INSERT
	ON  identifiers
FOR EACH ROW
	SET NEW.created_at = CURRENT_TIMESTAMP();
|
CREATE TRIGGER renowns_before_insert
	BEFORE INSERT
	ON  renowns
FOR EACH ROW
	SET NEW.imported_at = CURRENT_TIMESTAMP();
|
CREATE TRIGGER births_before_insert
	BEFORE INSERT
	ON  births
FOR EACH ROW
	SET NEW.imported_at = CURRENT_TIMESTAMP();
|
CREATE TRIGGER deaths_before_insert
	BEFORE INSERT
	ON  deaths
FOR EACH ROW
	SET NEW.imported_at = CURRENT_TIMESTAMP();
|

CREATE TRIGGER births_after_insert
	AFTER INSERT
	ON  births
FOR EACH ROW BEGIN
	DECLARE MINID INT DEFAULT 1e9;
	DECLARE MAXID INT DEFAULT POWER(2.,31)-1;
	DECLARE TEMPID INT DEFAULT 0;

	WHILE ((TEMPID = 0) OR 
		EXISTS (SELECT * FROM identifiers WHERE chirp_id=TEMPID)) 
	DO
		CALL log( CONCAT("Setting unique CHIRP_ID for identifier id ",NEW.id) );
		-- By using a min of 1e9, no need for leading zeroes.
		SET TEMPID = CAST(
			(MINID + (RAND() * (MAXID-MINID))) 
		AS INTEGER);
	END WHILE;

	INSERT INTO identifiers 
		( chirp_id, source_name, source_id )
		VALUES ( TEMPID, 'chirp', TEMPID );
	INSERT INTO identifiers 
		( chirp_id, source_name, source_id )
		VALUES ( TEMPID, 'birth', NEW.number );
END;
|

CREATE PROCEDURE populate()
BEGIN
	DECLARE count INT DEFAULT 0;

	WHILE count < 10 DO
		SET count = count + 1;
		INSERT INTO births ( number, state_file_number ) 
			VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), count*4 );
	END WHILE;

	SET count = 0;
	WHILE count < 10 DO
		SET count = count + 1;
		INSERT INTO deaths ( number, state_file_number ) 
			VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), count*3 );
	END WHILE;


	-- Multiple matching renown records will only be linked to the first birth record.

	INSERT INTO births ( number, dob, last_name, sex ) 
		VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), '1971-12-5', 'Wendt', 'M' );
	INSERT INTO renowns ( number, dob, last_name, sex ) 
		VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), '1971-12-5', 'Wendt', 'm' );
	INSERT INTO renowns ( number, dob, last_name, sex ) 
		VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), '1971-12-4', 'Wendt', 'm' );
	INSERT INTO renowns ( number, dob, last_name, sex ) 
		VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), '1971-12-5', 'Wend', 'm' );
	INSERT INTO renowns ( number, dob, last_name, sex ) 
		VALUES ( CAST(RAND()*1e18 AS UNSIGNED INTEGER), '1971-12-5', 'Wendt', 'f' );

END;
|


CREATE PROCEDURE linkrenowns()
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE cid, rnum, rlname VARCHAR(255);
	DECLARE rsex VARCHAR(1);
	DECLARE rdob DATE;
	DECLARE rid INT;

	--	Only those renowns without a matching identifier record.
	DECLARE unlinked_renown_record CURSOR FOR SELECT r.id,number,last_name,dob,sex
		FROM renowns r
		LEFT JOIN identifiers i 
		ON i.source_id = r.number AND i.source_name = 'renown'
		WHERE i.id IS NULL;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN unlinked_renown_record;

	read_renown_record: LOOP
		-- My SELECT below could trigger this to be true.
		-- Need to reset it or rethink the logic.
		-- Without it, the loop ends after the first miss.
		SET done = FALSE;		
		FETCH unlinked_renown_record INTO rid,rnum,rlname,rdob,rsex;
		IF done THEN
			LEAVE read_renown_record;
		END IF;

		SET cid = NULL;	--	this will remember the last loop?
		--	If 'NOT FOUND' trips handler to say done.  Need to reset above.
		--	This seems cleaner than using the EXISTS() and then requerying.
		SELECT chirp_id INTO cid 
			FROM identifiers i JOIN births b
			ON i.source_name = 'birth' AND i.source_id = b.number 
			WHERE b.last_name = rlname 
				AND b.dob = rdob
				AND b.sex = rsex 
				LIMIT 1;
		-- Currently, this seems to be case insensitive.  M = m
		IF ( cid IS NOT NULL ) THEN
			INSERT INTO identifiers ( chirp_id, source_name, source_id )
				VALUES ( cid, 'renown', rnum );
		END IF;
	END LOOP read_renown_record;
	CLOSE unlinked_renown_record;
END;
|


CREATE PROCEDURE linkdeaths()
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE cid, dn VARCHAR(255);
	DECLARE ds VARCHAR(11);
	DECLARE di INT;

	--	Only those deaths without a matching identifier record.
	DECLARE unlinked_death_record CURSOR FOR SELECT d.id,number,state_file_number 
		FROM deaths d
		LEFT JOIN identifiers i 
		ON i.source_id = d.number AND i.source_name = 'death'
		WHERE i.id IS NULL;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN unlinked_death_record;

	read_death_record: LOOP
		-- My SELECT below could trigger this to be true.
		-- Need to reset it or rethink the logic.
		-- Without it, the loop ends after the first miss.
		SET done = FALSE;		
		FETCH unlinked_death_record INTO di,dn,ds;
		IF done THEN
			LEAVE read_death_record;
		END IF;

		SET cid = NULL;	--	this will remember the last loop?
		--	If 'NOT FOUND' trips handler to say done.  Need to reset above.
		--	This seems cleaner than using the EXISTS() and then requerying.
		SELECT chirp_id INTO cid 
			FROM identifiers i JOIN births b
			ON i.source_name = 'birth' AND i.source_id = b.number 
			WHERE b.state_file_number = ds
			LIMIT 1;
		IF ( cid IS NOT NULL ) THEN
			INSERT INTO identifiers ( chirp_id, source_name, source_id )
				VALUES ( cid, 'death', dn );
		END IF;
	END LOOP read_death_record;
	CLOSE unlinked_death_record;
END;
|
CREATE PROCEDURE log(IN msg TEXT)
BEGIN
	INSERT INTO debug_log ( message, logged_at ) 
		VALUES( msg, CURRENT_TIMESTAMP() );
END;

|
DELIMITER ;


CALL populate();
CALL linkdeaths();
CALL linkdeaths();	--	This should do nothing if previous call worked.
CALL linkrenowns();
CALL linkrenowns();	--	This should do nothing if previous call worked.


