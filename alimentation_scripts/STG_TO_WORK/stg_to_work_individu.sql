.LOGON localhost/dbc,dbc;

-- Initialize tracking for TCH
INSERT INTO TCH.T_SUIVI_TRMT (RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES ((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'stg_to_work_individu.sql', NOW(), 'ENC');

-- Create a volatile table to store current EXEC_ID
CREATE VOLATILE TABLE CURRENT_EXEC_ID (
    current_exec_id INT
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

-- Insert the current EXEC_ID into the volatile table
INSERT INTO CURRENT_EXEC_ID (current_exec_id)
SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- STG to work for individu - inserting from STG.PERSONNEL
INSERT INTO WRK.WRK_INDIVIDU (
    PART_ID,
    INDIVIDU_ID,
    FONCTION_INDIVIDU,
    INDV_NAME,
    INDV_FIRS_NAME,
    INDV_STTS_CD,
    TS_CREATION,
    TS_MAJ,
    EXEC_ID
) 
SELECT 
    (SELECT PART_ID FROM WRK.WRK_RPART WRKPER WHERE STGPER.ID_PERSONNEL = WRKPER.INDIVIDU_ID AND STGPER.FONCTION_PERSONNEL = WRKPER.FONCTION_INDIVIDU),
    ID_PERSONNEL,
    FONCTION_PERSONNEL,
    NOM_PERSONNEL,
    PRENOM_PERSONNEL,
    CD_STATUT_PERSONNEL,
    TS_CREATION_PERSONNEL,
    TS_MAJ_PERSONNEL,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID) AS current_exec_id
FROM STG.PERSONNEL STGPER;

-- Handling errors during insert from STG.PERSONNEL
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

-- STG to work for individu - inserting from STG.PATIENT
INSERT INTO WRK.WRK_INDIVIDU (
    PART_ID,
    INDIVIDU_ID,
    FONCTION_INDIVIDU,
    INDV_NAME, 
    INDV_FIRS_NAME,
    TS_CREATION,
    TS_MAJ,
    DT_NAISS,
    VILLE_NAISS,
    PAYS_NAISS,
    NUM_SECU,
    INDV_STTS_CD,
    EXEC_ID
)
SELECT
    (SELECT PART_ID FROM SOC.R_PART SOCPAT WHERE STGPAT.ID_PATIENT = SOCPAT.SRC_ID AND 'Patient' = SOCPAT.SRC_TYP),
    ID_PATIENT,
    'Patient' AS FONCTION_INDIVIDU, 
    NOM_PATIENT,
    PRENOM_PATIENT,
    TS_CREATION_PATIENT,
    TS_MAJ_PERSONNEL,
    DT_NAISS,
    VILLE_NAISS,
    PAYS_NAISS,
    NUM_SECU,
    'Actif' AS INDV_STTS_CD,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID) AS current_exec_id
FROM STG.PATIENT STGPAT;

-- Handling errors during insert from STG.PATIENT
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

UPDATE WRK.WRK_INDIVIDU WRKIND
SET PART_ID = (SELECT PART_ID FROM WRK.WRK_RPART WRKPAT WHERE WRKIND.INDIVIDU_ID = WRKPAT.INDIVIDU_ID AND 'Patient' = WRKPAT.FONCTION_INDIVIDU AND 'Patient' = WRKIND.FONCTION_INDIVIDU)
    WHERE PART_ID IS NULL;

-- Handling errors during UPDATE OF WRK.WRK_INDIVIDU
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

-- Update script status and end time in TCH tracking
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(),
    EXEC_STTS_CD = 'OK'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS;

.LABEL LABEL_UPDATE_WITH_ERROR
-- Error occurred, update status to 'KO'
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(),
    EXEC_STTS_CD = 'KO'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;  -- Quit with exit code 100 on error

.LABEL LABEL_UPDATE_SUCCESS
-- Success, logoff from session
.LOGOFF;
.EXIT;
