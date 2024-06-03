.LOGON localhost/dbc,dbc;

-- Les tables de TCH ne sont pas recréées si elles existent déjà

-- Vérification si la table T_SUIVI_RUN existe dans la base TCH
SELECT * FROM dbc.tables WHERE tablename='T_SUIVI_RUN' AND databasename='TCH';

-- Si la table existe, passer à la prochaine table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_T_SUIVI_RUN;

-- Création de la table T_SUIVI_RUN
CREATE SET TABLE TCH.T_SUIVI_RUN (
    RUN_ID INTEGER NOT NULL,
    RUN_STRT_DTTM TIMESTAMP(0) NOT NULL,
    RUN_ED_DTTM TIMESTAMP(0),
    RUN_STTS_CD VARCHAR(10) NOT NULL
) UNIQUE PRIMARY INDEX (RUN_ID);

.LABEL LABEL_SKIP_CREATE_T_SUIVI_RUN

-- Vérification si la table T_SUIVI_TRMT existe dans la base TCH
SELECT * FROM dbc.tables WHERE tablename='T_SUIVI_TRMT' AND databasename='TCH';

-- Si la table existe, passer à la fin
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_T_SUIVI_TRMT;

-- Création de la table T_SUIVI_TRMT
CREATE SET TABLE TCH.T_SUIVI_TRMT (
    RUN_ID INTEGER NOT NULL,
    SCRPT_NAME VARCHAR(250) NOT NULL,
    EXEC_STRT_DTTM TIMESTAMP(0) NOT NULL,
    EXEC_END_DTTM TIMESTAMP(0), 
    EXEC_STTS_CD VARCHAR(10) NOT NULL, 
    EXEC_ID INTEGER NOT NULL 
) UNIQUE PRIMARY INDEX (EXEC_ID);

.LABEL LABEL_SKIP_CREATE_T_SUIVI_TRMT

-- Fermeture
.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
