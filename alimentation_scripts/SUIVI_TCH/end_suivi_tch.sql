.LOGON localhost/dbc,dbc;

-- Update the end time and status of this run

-- Check if there was an error
SELECT *
FROM TCH.T_SUIVI_TRMT
WHERE RUN_ID = (SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN)
AND EXEC_STTS_CD = 'KO';

.IF ACTIVITYCOUNT > 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;


-- End status is a success : 'OK'
UPDATE TCH.T_SUIVI_RUN
SET RUN_END_DTTM = NOW(),
    RUN_STTS_CD = 'OK'
WHERE RUN_ID = (SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN);

.GOTO LABEL_UPDATE_SUCCESS;

.LABEL LABEL_UPDATE_WITH_ERROR

-- End status is an error : 'KO'
UPDATE TCH.T_SUIVI_RUN
SET RUN_END_DTTM = NOW(),
    RUN_STTS_CD = 'KO'
WHERE RUN_ID = (SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN);

.LABEL LABEL_UPDATE_SUCCESS

-- Check for error and quit the program
.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
