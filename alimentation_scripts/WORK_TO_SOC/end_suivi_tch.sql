LOGON localhost/dbc,dbc;

UPDATE TCH.T_SUIVI_RUN
SET RUN_END_DTTM=NOW(), RUN_STTS_CD='Ended' 
WHERE RUN_ID = (SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN);

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;