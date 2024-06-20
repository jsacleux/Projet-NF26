LOGON localhost/dbc,dbc;

-- Initialization of TCH.T_SUIVI_TRMT table
INSERT INTO TCH.T_SUIVI_TRMT (RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES ((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'stg_to_work_rpart.sql', NOW(), 'ENC');

-- Create a volatile table to store the current EXEC_ID
CREATE VOLATILE TABLE CURRENT_EXEC_ID (
    current_exec_id INT
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

-- Insert the current EXEC_ID into the volatile table
INSERT INTO CURRENT_EXEC_ID (current_exec_id)
SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

CREATE VOLATILE TABLE MAX_PART_ID_PATIENT
(
max_part_id int
) PRIMARY INDEX (max_part_id)
ON COMMIT PRESERVE ROWS;

-- Retrieve current max part id.
INSERT INTO MAX_PART_ID_PATIENT(max_part_id) SELECT MAX(PART_ID) FROM SOC.R_PART WHERE SRC_TYP = 'Patient';
-- Insert 1000000 in case max returns null (for empty MAX_PART_ID Table)
-- We consider here that there won't be more than 1000000 personnel members stored in the hospital database
-- This solution is not great, but it enables to ensure that we won't generate the same id for "patient" or "personnel" members.
INSERT INTO MAX_PART_ID_PATIENT(max_part_id) VALUES(1000000);

CREATE VOLATILE TABLE MAX_PART_ID_PERSONNEL
(
max_part_id int
) PRIMARY INDEX (max_part_id)
ON COMMIT PRESERVE ROWS;

-- Retrieve current max part id.
INSERT INTO MAX_PART_ID_PERSONNEL(max_part_id) SELECT MAX(PART_ID) FROM SOC.R_PART WHERE SRC_TYP <> 'Patient';
-- Insert 0 in case max returns null (for empty MAX_PART_ID Table)
INSERT INTO MAX_PART_ID_PERSONNEL(max_part_id) VALUES(0);

-- STG to work for rpart (patient)
INSERT INTO WRK.WRK_RPART (
    PART_ID,
    INDIVIDU_ID,
    FONCTION_INDIVIDU,
    EXEC_ID
)
SELECT
    (SELECT MAX(max_part_id) FROM MAX_PART_ID_PATIENT) + (ROW_NUMBER() OVER (PARTITION BY 'Patient' ORDER BY ID_PATIENT)) AS PART_ID,
    ID_PATIENT,
    'Patient' AS FONCTION_INDIVIDU,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID) AS current_exec_id
FROM STG.PATIENT;

.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

-- STG to work for rpart (personnel)
INSERT INTO WRK.WRK_RPART (
    PART_ID,
    INDIVIDU_ID,
    FONCTION_INDIVIDU,
    EXEC_ID
)
SELECT
    (SELECT MAX(max_part_id) FROM MAX_PART_ID_PERSONNEL) + (ROW_NUMBER() OVER (ORDER BY ID_PERSONNEL, FONCTION_PERSONNEL)) AS PART_ID,
    ID_PERSONNEL,
    FONCTION_PERSONNEL,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID) AS current_exec_id
FROM STG.PERSONNEL;

.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

-- If (individu_id, fonction_individu) is found in rpart, then we want to conserve the same medc id 
MERGE WRK.WRK_RPART AS WRKRPART
USING(SELECT * FROM SOC.R_PART) AS SOCRPART   
ON WRKRPART.INDIVIDU_ID = SOCRPART.SRC_ID AND WRKRPART.FONCTION_INDIVIDU = SOCRPART.SRC_TYP
WHEN MATCHED THEN
UPDATE SET 
PART_ID = SOCRPART.PART_ID;

-- Update TCH.T_SUIVI_TRMT with state and end date
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(), EXEC_STTS_CD = 'OK'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS;

.LABEL LABEL_UPDATE_WITH_ERROR
-- Error occurred, update status to 'KO'
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(), EXEC_STTS_CD = 'KO'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;  -- Quit with exit code 100 on error

.LABEL LABEL_UPDATE_SUCCESS
-- Success, logoff from session
.LOGOFF;
.EXIT;
