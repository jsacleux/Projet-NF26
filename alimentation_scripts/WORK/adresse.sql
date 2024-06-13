.LOGON localhost/dbc,dbc;

MERGE INTO WRK.WRK_ADRESSE AS WRK_ADRESSE
USING (
    SELECT
        CURRENT_TIMESTAMP AS TS_CREATION_PATIENT, -- historisation
        CURRENT_TIMESTAMP AS TS_MAJ_PATIENT
) AS source (TS_CREATION_PATIENT, TS_MAJ_PATIENT)
ON WRK_ADRESSE.PART_ID =   -- Remplacez ? par la valeur appropriée pour la clé primaire PART_ID
WHEN MATCHED THEN
    UPDATE SET
        TS_MAJ_PATIENT = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        TS_CREATION_PATIENT,
        TS_MAJ_PATIENT
    ) VALUES (
        source.TS_CREATION_PATIENT,
        source.TS_MAJ_PATIENT
    );

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
