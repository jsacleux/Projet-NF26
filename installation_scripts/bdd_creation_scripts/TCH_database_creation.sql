.LOGON localhost/dbc,dbc;

-- Check that the db exists
SELECT * FROM DBC.Databases WHERE DatabaseName = 'TCH';

-- Check that the db exists
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_DATABASE;

-- Creation of the TCH DB 
CREATE DATABASE TCH AS PERMANENT = 60e6,
SPOOL = 120e6;

.LABEL LABEL_SKIP_CREATE_DATABASE

-- Closing 
.LOGOFF;
.EXIT;

