.LOGON localhost/dbc,dbc;

-- Initialize tracking for TCH
INSERT INTO TCH.T_SUIVI_TRMT (RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES ((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'stg_to_work_chambre.sql', NOW(), 'ENC');

-- Create a volatile table to store current EXEC_ID
CREATE VOLATILE TABLE CURRENT_EXEC_ID (
    current_exec_id INT
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

-- Insert the current EXEC_ID into the volatile table
INSERT INTO CURRENT_EXEC_ID (current_exec_id)
SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- Transfer data from STG.CHAMBRE to WRK.WRK_CHAMBRE
INSERT INTO WRK.WRK_CHAMBRE (
    NO_CHAMBRE,
    NOM_CHAMBRE, 
    NO_ETAGE, 
    NOM_BATIMENT,
    TYPE_CHAMBRE, 
    PRIX_JOUR, 
    DT_CREATION, 
    EXEC_ID
)
SELECT
    NO_CHAMBRE,
    NOM_CHAMBRE, 
    NO_ETAGE, 
    NOM_BATIMENT,
    TYPE_CHAMBRE, 
    PRIX_JOUR, 
    DT_CREATION,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM STG.CHAMBRE;

-- Update script status and end time in TCH tracking
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(),
    EXEC_STTS_CD = 'OK'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS;

.LABEL LABEL_UPDATE_WITH_ERROR
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(),
    EXEC_STTS_CD = 'KO'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;

.LABEL LABEL_UPDATE_SUCCESS
.LOGOFF;
.EXIT;
