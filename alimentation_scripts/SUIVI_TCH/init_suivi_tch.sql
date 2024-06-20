.LOGON localhost/dbc,dbc;

-- Insert new line in TCH.T_SUIVI_RUN to monitor this run
INSERT INTO TCH.T_SUIVI_RUN (RUN_STRT_DTTM, RUN_STTS_CD)
VALUES (NOW(), 'ENC');

-- Check for error and quit the program
.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
