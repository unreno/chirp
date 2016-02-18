
-- MUST be DROPped in the correct order.
-- DROPping concepts first is not allowed due to constraint.
-- (after having created, obviously)

DROP TABLE fkt_observations;
DROP TABLE fkt_concepts;
CREATE TABLE fkt_concepts (
	id int IDENTITY(1,1),
	code varchar(255) not null PRIMARY KEY,
	description varchar(MAX)
);


-- Foreign keys MUST by primary keys in the foreign table.
-- Foreign key values MUST exist in foreign table.


CREATE TABLE fkt_observations (
	id int IDENTITY(1,1) PRIMARY KEY,
	concept varchar(255) not null
	CONSTRAINT fk_concept
		FOREIGN KEY (concept) REFERENCES fkt_concepts(code)
);


INSERT INTO fkt_concepts(code) VALUES ('apple');
INSERT INTO fkt_concepts(code) VALUES ('orange');
INSERT INTO fkt_concepts(code) VALUES ('banana');

INSERT INTO fkt_observations(concept) VALUES ('banana');
INSERT INTO fkt_observations(concept) VALUES ('banana');
INSERT INTO fkt_observations(concept) VALUES ('banana');

SELECT * from fkt_concepts;
SELECT * from fkt_observations;


--	This will fail as this code does not exist.
INSERT INTO fkt_observations(concept) VALUES ('blah');
-- The INSERT statement conflicted with the FOREIGN KEY constraint "fk_concept". The conflict occurred in database "NewbornResearch", table "dbo.fkt_concepts", column 'code'.

-- This will fail as this code is currently being referenced.
DELETE FROM fkt_concepts WHERE code = 'banana';
-- The DELETE statement conflicted with the REFERENCE constraint "fk_concept". The conflict occurred in database "NewbornResearch", table "dbo.fkt_observations", column 'concept'.


-- This will work as no observation reference this concept code.
DELETE FROM fkt_concepts WHERE code = 'apple';


