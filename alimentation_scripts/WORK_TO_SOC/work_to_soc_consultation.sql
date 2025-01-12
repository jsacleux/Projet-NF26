.LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'work_to_soc_consultation.sql', NOW(), 'ENC');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
    current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id)
SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- Step 1: Update existing records with new information
UPDATE SOC.O_CONS
FROM WRK.WRK_CONSULTATION
SET
    CONS_ID = WRK.WRK_CONSULTATION.ID_CONSULT,
    STFF_ID = WRK.WRK_CONSULTATION.ID_PERSONNEL,
    PATN_ID = WRK.WRK_CONSULTATION.ID_PATIENT,
    CONS_STRT_DTTM = WRK.WRK_CONSULTATION.TS_DEBUT_CONSULT,
    CONS_END_DTTM = WRK.WRK_CONSULTATION.TS_FIN_CONSULT,
    PATN_WEGH = WRK.WRK_CONSULTATION.POIDS_PATIENT,
    PATN_TEMP = WRK.WRK_CONSULTATION.TEMP_PATIENT,
    TEMP_UNIT = WRK.WRK_CONSULTATION.UNIT_TEMP,
    BLD_PRSS = WRK.WRK_CONSULTATION.TENSION_PATIENT,
    PATH_DSC = WRK.WRK_CONSULTATION.DSC_PATHO,
    DIBT_IND = CAST(WRK.WRK_CONSULTATION.INDIC_DIABETE AS BYTEINT),
    TRET_ID = WRK.WRK_CONSULTATION.ID_TRAITEMENT,
    HOSP_IND = CAST(WRK.WRK_CONSULTATION.INDIC_HOSPI AS BYTEINT),
    EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID)
WHERE WRK.WRK_CONSULTATION.ID_CONSULT = SOC.O_CONS.CONS_ID;

.IF ERRORCODE <> 0 THEN .QUIT 100;

-- Step 2: Insert new records from the source table
INSERT INTO SOC.O_CONS (
    CONS_ID,
    STFF_ID,
    PATN_ID,
    CONS_STRT_DTTM,
    CONS_END_DTTM,
    PATN_WEGH,
    PATN_TEMP,
    TEMP_UNIT,
    BLD_PRSS,
    PATH_DSC,
    DIBT_IND,
    TRET_ID,
    HOSP_IND,
    EXEC_ID
)
SELECT
    ID_CONSULT,
    ID_PERSONNEL,
    ID_PATIENT,
    TS_DEBUT_CONSULT,
    TS_FIN_CONSULT,
    POIDS_PATIENT,
    TEMP_PATIENT,
    UNIT_TEMP,
    TENSION_PATIENT,
    DSC_PATHO,
    CAST(INDIC_DIABETE AS BYTEINT),
    ID_TRAITEMENT,
    CAST(INDIC_HOSPI AS BYTEINT),
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM WRK.WRK_CONSULTATION
WHERE NOT EXISTS (
    SELECT 1
    FROM SOC.O_CONS
    WHERE SOC.O_CONS.CONS_ID = WRK.WRK_CONSULTATION.ID_CONSULT
);

-- MAJ etat et date de fin du script dans suivi TCH
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(), EXEC_STTS_CD = 'OK'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS;

.LABEL LABEL_UPDATE_WITH_ERROR
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM = NOW(), EXEC_STTS_CD = 'KO'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;

.LABEL LABEL_UPDATE_SUCCESS

.LOGOFF;
.EXIT;
