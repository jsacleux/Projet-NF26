.LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'work_to_soc_adresse.sql', NOW(), 'Running');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id) SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- Step 1: Update existing records' end date with the new start date from the source
UPDATE SOC.O_ADDR tgt
SET
    tgt.END_VALD_DTTM = (SELECT src.TS_CREATION_PATIENT 
                         FROM WRK.WRK_ADRESSE src 
                         WHERE src.PART_ID = tgt.PART_ID),
    tgt.EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID)
WHERE EXISTS (
    SELECT 1 
    FROM WRK.WRK_ADRESSE src
    WHERE src.PART_ID = tgt.PART_ID
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
    src.PART_ID,
    src.STRT_NUM,
    src.STRT_DSC,
    src.COMP_STRT,
    src.POST_CD,
    src.CITY_NAME,
    src.CNTR_NAME,
    src.TS_CREATION_PATIENT,
    src.TS_MAJ_PATIENT,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM WRK.WRK_ADRESSE src
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.O_ADDR tgt
    WHERE tgt.PART_ID = src.PART_ID
    AND tgt.STRT_VALD_DTTM = src.TS_CREATION_PATIENT
);

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
