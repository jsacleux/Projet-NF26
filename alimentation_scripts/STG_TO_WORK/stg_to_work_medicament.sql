LOGON localhost/dbc,dbc;

-- Initialization of TCH.T_SUIVI_TRMT table
INSERT INTO TCH.T_SUIVI_TRMT (RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES ((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'stg_to_work_medicament.sql', NOW(), 'ENC');

-- Create a volatile table to store the current EXEC_ID
CREATE VOLATILE TABLE CURRENT_EXEC_ID (
    current_exec_id INT
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

-- Insert the current EXEC_ID into the volatile table
INSERT INTO CURRENT_EXEC_ID (current_exec_id)
SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

CREATE VOLATILE TABLE MAX_MEDIC_ID
(
max_medic_id int
) PRIMARY INDEX (max_medic_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO MAX_MEDIC_ID(max_medic_id) SELECT MAX(MEDC_ID) FROM SOC.R_MEDC;
INSERT INTO MAX_MEDIC_ID(max_medic_id) VALUES(0);

-- STG to work for MEDICAMENT
INSERT INTO WRK.WRK_MEDICAMENT (
    MEDC_ID,
    CD_MEDICAMENT,
    NOM_MEDICAMENT,
    CONDIT_MEDICAMENT,
    CATG_MEDICAMENT,
    MARQUE_FABRI,
    EXEC_ID
)
SELECT
    (SELECT MAX(max_medic_id) FROM MAX_MEDIC_ID) + (ROW_NUMBER() OVER (ORDER BY CD_MEDICAMENT, CATG_MEDICAMENT, MARQUE_FABRI)) AS MEDC_ID,
    CD_MEDICAMENT,
    NOM_MEDICAMENT,
    CONDIT_MEDICAMENT,
    CATG_MEDICAMENT,
    MARQUE_FABRI,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID) AS current_exec_id
FROM STG.MEDICAMENT;

.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;

-- If (cd_medicament, catg_medicament, marque_fabri) is found in rpart, then we want to conserve the same medc id 
MERGE WRK.WRK_MEDICAMENT AS WRKMED
USING(SELECT * FROM SOC.R_MEDC) AS RMED   
ON WRKMED.CD_MEDICAMENT = RMED.MEDC_CD AND WRKMED.CATG_MEDICAMENT = RMED.MEDC_CATG AND WRKMED.MARQUE_FABRI = RMED.MANF_BRND
WHEN MATCHED THEN
UPDATE SET 
MEDC_ID = RMED.MEDC_ID;

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