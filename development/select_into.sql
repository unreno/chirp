

-- SELECT * INTO tablename FROM someothertable
-- is for creating a table

-- This is actually nice for copying the structure of a table. 
-- Just add a false condition like WHERE 1 = 0 so it won't copy any data.

-- Use INSERT INTO tablename SELECT * FROM someothertable
-- when said target table already exists.

