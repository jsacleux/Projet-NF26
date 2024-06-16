.LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'work_to_soc_telephone.sql', NOW(), 'Running');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id) SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- Step 1: Update existing records with new information
UPDATE SOC.O_TELP 
FROM WRK.WRK_TELP
SET
    PART_ID = WRK.WRK_TELP.PART_ID,
    CNTR_IND = WRK.WRK_TELP.IND_PAYS_NUM_TELP,
    TELP_NUM = WRK.WRK_TELP.NUM_TELEPHONE,
    STRT_VALD_DTTM = WRK.WRK_TELP.TS_CREATION_PATIENT,
    END_VALD_DTTM = WRK.WRK_TELP.TS_MAJ_PATIENT,
    EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID)
WHERE (
    WRK.WRK_TELP.PART_ID = SOC.O_TELP.PART_ID AND
    WRK.WRK_TELP.TS_CREATION_PATIENT = SOC.O_TELP.STRT_VALD_DTTM
);

.IF ERRORCODE <> 0 THEN .QUIT 100;

-- Step 2: Insert new records from the source table
INSERT INTO SOC.O_TELP (
    PART_ID,
    CNTR_IND,
    TELP_NUM,
    STRT_VALD_DTTM, 
    END_VALD_DTTM, 
    EXEC_ID
)
SELECT
    PART_ID,
    IND_PAYS_NUM_TELP,
    NUM_TELEPHONE,
    TS_CREATION_PATIENT,
    TS_MAJ_PATIENT,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM WRK.WRK_TELP
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.O_TELP
    WHERE WRK.WRK_TELP.PART_ID = SOC.O_TELP.PART_ID
    AND WRK.WRK_TELP.TS_CREATION_PATIENT = SOC.O_TELP.STRT_VALD_DTTM
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
