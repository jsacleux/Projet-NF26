.LOGON localhost/dbc,dbc;

-- Step 1: Update existing records' end date with the new start date from the source
UPDATE SOC.O_TELP tgt
SET
    tgt.END_VALD_DTTM = (SELECT src.STRT_VALD_DTTM 
                         FROM WRK.WRK_TELP src 
                         WHERE src.PART_ID = tgt.PART_ID)
WHERE EXISTS (
    SELECT 1 
    FROM WRK.WRK_TELP src
    WHERE src.PART_ID = tgt.PART_ID
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
    src.PART_ID,
    src.IND_PAYS_NUM_TELP,
    src.NUM_TELEPHONE,
    src.TS_CREATION_PATIENT,
    src.TS_MAJ_PATIENT,
    1
FROM WRK.WRK_TELP src
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.O_TELP tgt
    WHERE tgt.PART_ID = src.PART_ID
);

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
