.LOGON localhost/dbc,dbc;

-- Step 1: Update existing records with new information
UPDATE SOC.R_MEDC tgt
SET
    tgt.MEDC_CD = src.CD_MEDICAMENT,
    tgt.MEDC_NAME = src.NOM_MEDICAMENT,
    tgt.MEDC_COND = src.CONDIT_MEDICAMENT,
    tgt.MEDC_CATG = src.CATG_MEDICAMENT,
    tgt.MANF_BRND = src.MARQUE_FABRI,
    tgt.EXEC_ID = 1
FROM WRK.WRK_MEDICAMENT src
WHERE tgt.MEDC_ID = src.MEDC_ID
  AND (
       src.CD_MEDICAMENT <> tgt.MEDC_CD
    OR src.NOM_MEDICAMENT <> tgt.MEDC_NAME
    OR src.CONDIT_MEDICAMENT <> tgt.MEDC_COND
    OR src.CATG_MEDICAMENT <> tgt.MEDC_CATG
    OR src.MARQUE_FABRI <> tgt.MANF_BRND
  );

.IF ERRORCODE <> 0 THEN .QUIT 100;

-- Step 2: Insert new records
INSERT INTO SOC.R_MEDC (
    MEDC_ID, 
    MEDC_CD, 
    MEDC_NAME, 
    MEDC_COND, 
    MEDC_CATG, 
    MANF_BRND, 
    EXEC_ID
)
SELECT
    src.MEDC_ID,
    src.CD_MEDICAMENT,
    src.NOM_MEDICAMENT,
    src.CONDIT_MEDICAMENT,
    src.CATG_MEDICAMENT,
    src.MARQUE_FABRI,
    1
FROM WRK.WRK_MEDICAMENT src
WHERE NOT EXISTS (
    SELECT 1 
    FROM SOC.R_MEDC tgt
    WHERE tgt.MEDC_ID = src.MEDC_ID
);

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
