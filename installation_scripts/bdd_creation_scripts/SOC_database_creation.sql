.LOGON localhost/dbc,dbc;

-- Check that the db exists
SELECT * FROM DBC.Databases WHERE DatabaseName = 'SOC';

-- If not exist, create it
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_DATABASE;

-- Creation of the SOC DB 
CREATE DATABASE SOC AS PERMANENT = 60e6,
SPOOL = 120e6;

.LABEL LABEL_SKIP_CREATE_DATABASE

-- Closing 
.LOGOFF;
.EXIT;

