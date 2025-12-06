#-- Non-ADMIN Work MUST be completed by logging in as non-root account, like 'skotam'@'localhost'
#-- This script be executed after fully and successfully executing the ADMIN Work ABCcompany schema script as root
drop schema ABCcompany; #-- will give an error
SHOW GRANTS FOR 'skotam'@'localhost';
drop table PERSON; #-- will give an error
select * from information_schema.tables where table_schema = 'ABCcompany'; #-- result screenshotted
select * from information_schema.columns where table_schema = 'ABCcompany'; #-- result screenshotted
SELECT Table_name, TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'ABCcompany'; #-- result screenshotted
SELECT u.table_name, u.constraint_name, u.column_name, c.constraint_type 
FROM information_schema.KEY_COLUMN_USAGE U,
     information_schema.TABLE_CONSTRAINTS C
WHERE U.TABLE_SCHEMA = 'ABCcompany'
  AND U.TABLE_SCHEMA = C.TABLE_SCHEMA
  AND U.TABLE_NAME = C.TABLE_NAME
  AND U.CONSTRAINT_NAME = C.CONSTRAINT_NAME; #-- result screenshotted
