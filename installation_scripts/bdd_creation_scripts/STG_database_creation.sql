.LOGON localhost/dbc,dbc;

-- Check that the db exists
SELECT * FROM DBC.Databases WHERE DatabaseName = 'STG';

-- If not exist, create it
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_DATABASE;

-- Creation of the STG DB 
CREATE DATABASE STG AS PERMANENT = 60e6,
SPOOL = 120e6;

.LABEL LABEL_SKIP_CREATE_DATABASE

-- Closing 
.LOGOFF;
.EXIT;

