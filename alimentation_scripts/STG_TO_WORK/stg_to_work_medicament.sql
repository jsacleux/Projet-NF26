LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'stg_to_work_medicament.sql', NOW(), 'Running');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id) SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- STG to work pour medicament
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
    ROW_NUMBER() OVER (PARTITION BY CATG_MEDICAMENT, MARQUE_FABRI ORDER BY CD_MEDICAMENT) AS MEDC_ID,
    CD_MEDICAMENT,
    NOM_MEDICAMENT,
    CONDIT_MEDICAMENT,
    CATG_MEDICAMENT,
    MARQUE_FABRI,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM STG.MEDICAMENT;

-- MAJ etat et date de fin du script dans suivi TCH
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='Success'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS

.LABEL LABEL_UPDATE_WITH_ERROR
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='Error'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;

.LABEL LABEL_UPDATE_SUCCESS
.LOGOFF;
.EXIT;