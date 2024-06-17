LOGON localhost/dbc,dbc;

-- Initialization of TCH.T_SUIVI_TRMT table
INSERT INTO TCH.T_SUIVI_TRMT (RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES ((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'stg_to_work_telephone.sql', NOW(), 'Running');

-- Create a volatile table to store the current EXEC_ID
CREATE VOLATILE TABLE CURRENT_EXEC_ID (
    current_exec_id INT
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

-- Insert the current EXEC_ID into the volatile table
INSERT INTO CURRENT_EXEC_ID (current_exec_id)
SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- STG to work for telephone
INSERT INTO WRK.WRK_TELP (
    PART_ID,
    INDIVIDU_ID,
    FONCTION_INDIVIDU,
    IND_PAYS_NUM_TELP,
    NUM_TELEPHONE,
    TS_CREATION_PATIENT,
    TS_MAJ_PATIENT,
    EXEC_ID
) 
SELECT
    ROW_NUMBER() OVER (PARTITION BY 'Patient' ORDER BY ID_PATIENT) AS PART_ID,
    ID_PATIENT,
    'Patient' AS FONCTION_INDIVIDU,
    IND_PAYS_NUM_TELP,
    NUM_TELEPHONE,
    TS_CREATION_PATIENT,
    TS_MAJ_PERSONNEL,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID) AS current_exec_id
FROM STG.PATIENT;

-- Error handling and update TCH.T_SUIVI_TRMT with state and end date
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(), EXEC_STTS_CD = 'Success'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);

.GOTO LABEL_UPDATE_SUCCESS;

.LABEL LABEL_UPDATE_WITH_ERROR
-- Error occurred, update status to 'Error'
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(), EXEC_STTS_CD = 'Error'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);

.QUIT 100;  -- Quit with exit code 100 on error

.LABEL LABEL_UPDATE_SUCCESS
-- Success, logoff from session
.LOGOFF;
.EXIT;
