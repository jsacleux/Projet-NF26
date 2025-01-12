.LOGON localhost/dbc,dbc;

-- STG tables are recreated each execution

-- Table CHAMBRE
-- Check if CHAMBRE table exists
SELECT * FROM dbc.tables WHERE tablename='CHAMBRE';

-- Drop CHAMBRE table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CHAMBRE;
DROP TABLE STG.CHAMBRE;

.LABEL LABEL_SKIP_DELETE_CHAMBRE

-- Create CHAMBRE table
CREATE TABLE STG.CHAMBRE (
    NO_CHAMBRE INTEGER UNIQUE NOT NULL,
    NOM_CHAMBRE VARCHAR(20) NOT NULL,
    NO_ETAGE BYTEINT,
    NOM_BATIMENT VARCHAR(20),
    TYPE_CHAMBRE VARCHAR(20),
    PRIX_JOUR SMALLINT NOT NULL,
    DT_CREATION DATE NOT NULL
);

-- Table TRAITEMENT
-- Check if TRAITEMENT table exists
SELECT * FROM dbc.tables WHERE tablename='TRAITEMENT';

-- Drop TRAITEMENT table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_TRAITEMENT;
DROP TABLE STG.TRAITEMENT;

.LABEL LABEL_SKIP_DELETE_TRAITEMENT

-- Create TRAITEMENT table
CREATE TABLE STG.TRAITEMENT (
    ID_TRAITEMENT BIGINT UNIQUE NOT NULL,
    CD_MEDICAMENT INTEGER NOT NULL,
    CATG_MEDICAMENT VARCHAR(100) NOT NULL,
    MARQUE_FABRI VARCHAR(100) NOT NULL,
    QTE_MEDICAMENT SMALLINT,
    DSC_POSOLOGIE VARCHAR(100) NOT NULL,
    ID_CONSULT BIGINT NOT NULL,
    TS_CREATION_TRAITEMENT TIMESTAMP(0) NOT NULL
);

-- Table PERSONNEL
-- Check if PERSONNEL table exists
SELECT * FROM dbc.tables WHERE tablename='PERSONNEL';

-- Drop PERSONNEL table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PERSONNEL;
DROP TABLE STG.PERSONNEL;

.LABEL LABEL_SKIP_DELETE_PERSONNEL

-- Create PERSONNEL table
CREATE TABLE STG.PERSONNEL (
    ID_PERSONNEL INTEGER UNIQUE NOT NULL,
    NOM_PERSONNEL VARCHAR(100) NOT NULL,
    PRENOM_PERSONNEL VARCHAR(100) NOT NULL,
    FONCTION_PERSONNEL VARCHAR(50) NOT NULL,
    TS_DEBUT_ACTIVITE TIMESTAMP(0) NOT NULL,
    TS_FIN_ACTIVITE TIMESTAMP(0),
    RAISON_FIN_ACTIVITE VARCHAR(100),
    TS_CREATION_PERSONNEL TIMESTAMP(0) NOT NULL,
    TS_MAJ_PERSONNEL TIMESTAMP(0) NOT NULL,
    CD_STATUT_PERSONNEL VARCHAR(10) NOT NULL
);

-- Table PATIENT
-- Check if PATIENT table exists
SELECT * FROM dbc.tables WHERE tablename='PATIENT';

-- Drop PATIENT table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PATIENT;
DROP TABLE STG.PATIENT;

.LABEL LABEL_SKIP_DELETE_PATIENT

-- Create PATIENT table
CREATE TABLE STG.PATIENT (
    ID_PATIENT INTEGER UNIQUE NOT NULL,
    NOM_PATIENT VARCHAR(100) NOT NULL,
    PRENOM_PATIENT VARCHAR(100) NOT NULL,
    DT_NAISS DATE,
    VILLE_NAISS VARCHAR(100),
    PAYS_NAISS VARCHAR(100),
    NUM_SECU VARCHAR(15),
    IND_PAYS_NUM_TELP VARCHAR(5),
    NUM_TELEPHONE VARCHAR(20),
    NUM_VOIE VARCHAR(10),
    DSC_VOIE VARCHAR(250),
    CMPL_VOIE VARCHAR(250),
    CD_POSTAL VARCHAR(10),
    VILLE VARCHAR(100),
    PAYS VARCHAR(100),
    TS_CREATION_PATIENT TIMESTAMP(0) NOT NULL,
    TS_MAJ_PERSONNEL TIMESTAMP(0) NOT NULL
);

-- Table CONSULTATION
-- Check if CONSULTATION table exists
SELECT * FROM dbc.tables WHERE tablename='CONSULTATION';

-- Drop CONSULTATION table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CONSULTATION;
DROP TABLE STG.CONSULTATION;

.LABEL LABEL_SKIP_DELETE_CONSULTATION

-- Create CONSULTATION table
CREATE TABLE STG.CONSULTATION (
    ID_CONSULT BIGINT UNIQUE NOT NULL,
    ID_PERSONNEL INTEGER NOT NULL,
    ID_PATIENT INTEGER NOT NULL,
    TS_DEBUT_CONSULT TIMESTAMP(0) NOT NULL,
    TS_FIN_CONSULT TIMESTAMP(0) NOT NULL,
    POIDS_PATIENT INTEGER NOT NULL,
    TEMP_PATIENT INTEGER,
    UNIT_TEMP VARCHAR(15),
    TENSION_PATIENT INTEGER,
    DSC_PATHO VARCHAR(250),
    INDIC_DIABETE VARCHAR(10),
    ID_TRAITEMENT BIGINT,
    INDIC_HOSPI VARCHAR(10)
);

-- Table HOSPITALISATION
-- Check if HOSPITALISATION table exists
SELECT * FROM dbc.tables WHERE tablename='HOSPITALISATION';

-- Drop HOSPITALISATION table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_HOSPITALISATION;
DROP TABLE STG.HOSPITALISATION;

.LABEL LABEL_SKIP_DELETE_HOSPITALISATION

-- Create HOSPITALISATION table
CREATE TABLE STG.HOSPITALISATION (
    ID_HOSPI BIGINT UNIQUE NOT NULL,
    ID_CONSULT BIGINT NOT NULL,
    NO_CHAMBRE SMALLINT NOT NULL,
    TS_DEBUT_HOSPI TIMESTAMP(0) NOT NULL,
    TS_FIN_HOSPI TIMESTAMP(0),
    COUT_HOSPI INTEGER,
    ID_PERSONNEL_RESP INTEGER NOT NULL
);

-- Table MEDICAMENT
-- Check if MEDICAMENT table exists
SELECT * FROM dbc.tables WHERE tablename='MEDICAMENT';

-- Drop MEDICAMENT table if it exists
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_MEDICAMENT;
DROP TABLE STG.MEDICAMENT;

.LABEL LABEL_SKIP_DELETE_MEDICAMENT

-- Create MEDICAMENT table
CREATE TABLE STG.MEDICAMENT (
    CD_MEDICAMENT VARCHAR(10) UNIQUE NOT NULL,
    NOM_MEDICAMENT VARCHAR(250),
    CONDIT_MEDICAMENT VARCHAR(100),
    CATG_MEDICAMENT VARCHAR(100) NOT NULL,
    MARQUE_FABRI VARCHAR(100) NOT NULL
);

-- Check for error and quit the program
.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
