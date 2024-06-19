.LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'work_to_soc_adresse.sql', NOW(), 'ENC');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id) SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- Step 1: Update existing records with new information
UPDATE SOC.O_ADDR
FROM WRK.WRK_ADRESSE
SET
    PART_ID = WRK.WRK_ADRESSE.PART_ID,
    STRT_NUM = WRK.WRK_ADRESSE.STRT_NUM,
    STRT_DSC = WRK.WRK_ADRESSE.STRT_DSC,
    COMP_STRT = WRK.WRK_ADRESSE.COMP_STRT,
    POST_CD = WRK.WRK_ADRESSE.POST_CD,
    CITY_NAME = WRK.WRK_ADRESSE.CITY_NAME,
    CNTR_NAME = WRK.WRK_ADRESSE.CNTR_NAME,
    STRT_VALD_DTTM = WRK.WRK_ADRESSE.TS_CREATION_PATIENT,
    END_VALD_DTTM = WRK.WRK_ADRESSE.TS_MAJ_PATIENT,
    EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID)
WHERE (
    WRK.WRK_ADRESSE.PART_ID = SOC.O_ADDR.PART_ID AND
    WRK.WRK_ADRESSE.TS_CREATION_PATIENT = SOC.O_ADDR.STRT_VALD_DTTM
); 

.IF ERRORCODE <> 0 THEN .QUIT 100;

-- Step 2: Insert new records from the source table
INSERT INTO SOC.O_ADDR (
    PART_ID,
    STRT_NUM, 
    STRT_DSC, 
    COMP_STRT, 
    POST_CD, 
    CITY_NAME, 
    CNTR_NAME, 
    STRT_VALD_DTTM, 
    END_VALD_DTTM, 
    EXEC_ID
)
SELECT
    PART_ID,
    STRT_NUM,
    STRT_DSC,
    COMP_STRT,
    POST_CD,
    CITY_NAME,
    CNTR_NAME,
    TS_CREATION_PATIENT,
    TS_MAJ_PATIENT,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM WRK.WRK_ADRESSE
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.O_ADDR
    WHERE SOC.O_ADDR.PART_ID = WRK.WRK_ADRESSE.PART_ID
    AND SOC.O_ADDR.STRT_VALD_DTTM = WRK.WRK_ADRESSE.TS_CREATION_PATIENT
);

-- MAJ etat et date de fin du script dans suivi TCH
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='Success'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS

.LABEL LABEL_UPDATE_WITH_ERROR
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='KO'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;

.LABEL LABEL_UPDATE_SUCCESS

.LOGOFF;
.EXIT;
