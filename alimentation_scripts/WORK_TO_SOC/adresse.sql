.LOGON localhost/dbc,dbc;

-- Step 1: Update existing records' end date with the new start date from the source
UPDATE SOC.O_ADDR tgt
SET
    tgt.END_VALD_DTTM = (SELECT src.TS_CREATION_PATIENT 
                         FROM WRK.WRK_ADRESSE src 
                         WHERE src.PART_ID = tgt.PART_ID)
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
    1
FROM WRK.WRK_ADRESSE src
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.O_ADDR tgt
    WHERE tgt.PART_ID = src.PART_ID
    AND tgt.STRT_VALD_DTTM = src.TS_CREATION_PATIENT
);

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
