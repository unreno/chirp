
DROP TABLE x;
DROP TABLE y;
CREATE TABLE x ( a INT, b INT );
CREATE TABLE y ( a INT, b INT );

INSERT INTO x VALUES ( 1, 10 ),( 2, 11 ),( 3, 12 );
INSERT INTO y VALUES ( 1, 10 ),( 1, 11 ),( 1, 12 );
INSERT INTO y VALUES ( 2, 10 ),( 2, 11 ),( 2, 12 );
INSERT INTO y VALUES ( 4, 10 ),( 4, 11 ),( 4, 12 );

SELECT * from x;
SELECT * from y;

SELECT * from x
JOIN y ON x.a = y.a;

SELECT * from x
INNER JOIN y ON x.a = y.a;

SELECT * from x
LEFT JOIN y ON x.a = y.a;

SELECT * from x
RIGHT JOIN y ON x.a = y.a;



