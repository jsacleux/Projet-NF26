.LOGON localhost/dbc,dbc;

-- Check that the db exists
SELECT * FROM DBC.Databases WHERE DatabaseName = 'WRK';

-- Si la base n'existe pas, la creer
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_DATABASE;

-- Creation of the WRK DB 
CREATE DATABASE WRK AS PERMANENT = 60e6,
SPOOL = 120e6;

.LABEL LABEL_SKIP_CREATE_DATABASE

-- Closing 
.LOGOFF;
.EXIT;

