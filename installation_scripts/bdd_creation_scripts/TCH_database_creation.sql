.LOGON localhost/dbc,dbc;

-- Verification si la base de donnees existe
SELECT * FROM DBC.Databases WHERE DatabaseName = 'TCH';

-- Si la base n'existe pas, la creer
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_DATABASE;

-- Creation BDD TCH
CREATE DATABASE TCH AS PERMANENT = 60e6,
SPOOL = 120e6;

.LABEL LABEL_SKIP_CREATE_DATABASE

-- Closing 
.LOGOFF;
.EXIT;

