.LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'work_to_soc_staff.sql', NOW(), 'Running');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id) SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

-- Step 1: Update existing records' end date with the new start date from the source
UPDATE SOC.O_STFF
FROM WRK.WRK_STAFF
SET
    PART_ID = WRK.WRK_STAFF.PART_ID,
    WORK_STRT_DTTM = WRK.WRK_STAFF.WORK_STRT_DTTM,
    WORK_END_DTTM = WRK.WRK_STAFF.WORK_END_DTTM,
    WORK_END_RESN = WRK.WRK_STAFF.WORK_END_RESN,
    EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID)                    
WHERE (
    WRK.WRK_STAFF.PART_ID = SOC.O_STFF.PART_ID
);

.IF ERRORCODE <> 0 THEN .QUIT 100;

-- Step 2: Insert new records from the source table
INSERT INTO SOC.O_STFF (
    PART_ID,
    WORK_STRT_DTTM, 
    WORK_END_DTTM, 
    WORK_END_RESN, 
    EXEC_ID
)
SELECT
    WRK.WRK_STAFF.PART_ID,
    WRK.WRK_STAFF.WORK_STRT_DTTM,
    WRK.WRK_STAFF.WORK_END_DTTM,
    WRK.WRK_STAFF.WORK_END_RESN,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM WRK.WRK_STAFF
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.O_STFF
    WHERE SOC.O_STFF.PART_ID = WRK.WRK_STAFF.PART_ID
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
