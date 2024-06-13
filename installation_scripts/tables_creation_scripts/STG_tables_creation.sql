.LOGON localhost/dbc,dbc;

-- Les tables STG sont recréées à chaque exécution

--Table CHAMBRE
-- Verification si table Chambre existe
SELECT * FROM dbc.tables where tablename='CHAMBRE';

-- Suppression de la table Chambre si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CHAMBRE;
DROP TABLE STG.CHAMBRE;

.LABEL LABEL_SKIP_DELETE_CHAMBRE

-- Suppression des tables Chambre RL, ET et UV 
-- pas sensé les faire (script TPT)

SELECT * FROM dbc.tables where tablename='CHAMBRE_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CHAMBRE_RL;
DROP TABLE STG.CHAMBRE_RL;
.LABEL LABEL_SKIP_DELETE_CHAMBRE_RL

SELECT * FROM dbc.tables where tablename='CHAMBRE_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CHAMBRE_ET;
DROP TABLE STG.CHAMBRE_ET;
.LABEL LABEL_SKIP_DELETE_CHAMBRE_ET

SELECT * FROM dbc.tables where tablename='CHAMBRE_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CHAMBRE_UV;
DROP TABLE STG.CHAMBRE_UV;
.LABEL LABEL_SKIP_DELETE_CHAMBRE_UV

-- Creation de la table Chambre

CREATE TABLE STG.CHAMBRE (
    NO_CHAMBRE INTEGER NOT NULL PRIMARY KEY,
    NOM_CHAMBRE VARCHAR(20) NOT NULL,
    NO_ETAGE BYTEINT,
    NOM_BATIMENT VARCHAR(20),
    TYPE_CHAMBRE VARCHAR(20),
    PRIX_JOUR SMALLINT NOT NULL,
    DT_CREATION DATE NOT NULL
);

--Table TRAITEMENT
-- Verification si table Traitement existe
SELECT * FROM dbc.tables where tablename='TRAITEMENT';

-- Suppression de la table Traitement si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_TRAITEMENT;
DROP TABLE STG.TRAITEMENT;

.LABEL LABEL_SKIP_DELETE_TRAITEMENT

-- Suppression des tables Traitement RL, ET et UV 

SELECT * FROM dbc.tables where tablename='TRAITEMENT_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_TRAITEMENT_RL;
DROP TABLE STG.TRAITEMENT_RL;
.LABEL LABEL_SKIP_DELETE_TRAITEMENT_RL

SELECT * FROM dbc.tables where tablename='TRAITEMENT_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_TRAITEMENT_ET;
DROP TABLE STG.TRAITEMENT_ET;
.LABEL LABEL_SKIP_DELETE_TRAITEMENT_ET

SELECT * FROM dbc.tables where tablename='TRAITEMENT_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_TRAITEMENT_UV;
DROP TABLE STG.TRAITEMENT_UV;
.LABEL LABEL_SKIP_DELETE_TRAITEMENT_UV

-- Creation de la table Traitement

CREATE TABLE STG.TRAITEMENT (
    ID_TRAITEMENT BIGINT NOT NULL PRIMARY KEY,
    CD_MEDICAMENT INTEGER NOT NULL,
    CATG_MEDICAMENT VARCHAR(100) NOT NULL,
    MARQUE_FABRI VARCHAR(100) NOT NULL,
    QTE_MEDICAMENT SMALLINT,
    DSC_POSOLOGIE VARCHAR(100) NOT NULL,
    ID_CONSULT BIGINT NOT NULL,
    TS_CREATION_TRAITEMENT TIMESTAMP(0) NOT NULL
);

--Table PERSONNEL
-- Verification si table PERSONNEL existe
SELECT * FROM dbc.tables where tablename='PERSONNEL';

-- Suppression de la table PERSONNEL si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PERSONNEL;
DROP TABLE STG.PERSONNEL;

.LABEL LABEL_SKIP_DELETE_PERSONNEL

-- Suppression des tables Consultation RL, ET et UV 

SELECT * FROM dbc.tables where tablename='PERSONNEL_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PERSONNEL_RL;
DROP TABLE STG.PERSONNEL_RL;
.LABEL LABEL_SKIP_DELETE_PERSONNEL_RL

SELECT * FROM dbc.tables where tablename='PERSONNEL_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PERSONNEL_ET;
DROP TABLE STG.PERSONNEL_ET;
.LABEL LABEL_SKIP_DELETE_PERSONNEL_ET

SELECT * FROM dbc.tables where tablename='PERSONNEL_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PERSONNEL_UV;
DROP TABLE STG.PERSONNEL_UV;
.LABEL LABEL_SKIP_DELETE_PERSONNEL_UV

-- Creation de la table Consultation

CREATE TABLE STG.PERSONNEL (
    ID_PERSONNEL INTEGER NOT NULL PRIMARY KEY,
    NOM_PERSONNEL VARCHAR(100) NOT NULL,
    PRENOM_PERSONNEL VARCHAR(100) NOT NULL,
    FONCTION_PERSONNEL VARCHAR(50) NOT NULL,
    TS_DEBUT_ACTIVITE TIMESTAMP(0) NOT NULL,
    TS_FIN_ACTIVITE TIMESTAMP(0),
    RAISON_FIN_ACTIVITE  VARCHAR(100),
    TS_CREATION_PERSONNEL TIMESTAMP(0) NOT NULL,
    TS_MAJ_PERSONNEL TIMESTAMP(0) NOT NULL,
    CD_STATUT_PERSONNEL  VARCHAR(10) NOT NULL
);

--Table PATIENT
-- Verification si table PATIENT existe
SELECT * FROM dbc.tables where tablename='PATIENT';

-- Suppression de la table PATIENT si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PATIENT;
DROP TABLE STG.PATIENT;

.LABEL LABEL_SKIP_DELETE_PATIENT

-- Suppression des tables Patient RL, ET et UV 

SELECT * FROM dbc.tables where tablename='PATIENT_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PATIENT_RL;
DROP TABLE STG.PATIENT_RL;
.LABEL LABEL_SKIP_DELETE_PATIENT_RL

SELECT * FROM dbc.tables where tablename='PATIENT_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PATIENT_ET;
DROP TABLE STG.PATIENT_ET;
.LABEL LABEL_SKIP_DELETE_PATIENT_ET

SELECT * FROM dbc.tables where tablename='PATIENT_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_PATIENT_UV;
DROP TABLE STG.PATIENT_UV;
.LABEL LABEL_SKIP_DELETE_PATIENT_UV

-- Creation de la table Patient

CREATE TABLE STG.PATIENT (
    ID_PATIENT INTEGER NOT NULL PRIMARY KEY,
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

--Table CONSULTATION
-- Verification si table CONSULTATION existe
SELECT * FROM dbc.tables where tablename='CONSULTATION';

-- Suppression de la table CONSULTATION si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CONSULTATION;
DROP TABLE STG.CONSULTATION;

.LABEL LABEL_SKIP_DELETE_CONSULTATION

-- Suppression des tables Consultation RL, ET et UV 

SELECT * FROM dbc.tables where tablename='CONSULTATION_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CONSULTATION_RL;
DROP TABLE STG.CONSULTATION_RL;
.LABEL LABEL_SKIP_DELETE_CONSULTATION_RL

SELECT * FROM dbc.tables where tablename='CONSULTATION_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CONSULTATION_ET;
DROP TABLE STG.CONSULTATION_ET;
.LABEL LABEL_SKIP_DELETE_CONSULTATION_ET

SELECT * FROM dbc.tables where tablename='CONSULTATION_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_CONSULTATION_UV;
DROP TABLE STG.CONSULTATION_UV;
.LABEL LABEL_SKIP_DELETE_CONSULTATION_UV

-- Creation de la table Consultation

CREATE TABLE STG.CONSULTATION (
    ID_CONSULT BIGINT NOT NULL PRIMARY KEY,
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

--Table HOSPITALISATION
-- Verification si table HOSPITALISATION existe
SELECT * FROM dbc.tables where tablename='HOSPITALISATION';

-- Suppression de la table HOSPITALISATION si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_HOSPITALISATION;
DROP TABLE STG.HOSPITALISATION;

.LABEL LABEL_SKIP_DELETE_HOSPITALISATION

-- Suppression des tables Hospitalisation RL, ET et UV 

SELECT * FROM dbc.tables where tablename='HOSPITALISATION_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_HOSPITALISATION_RL;
DROP TABLE STG.HOSPITALISATION_RL;
.LABEL LABEL_SKIP_DELETE_HOSPITALISATION_RL

SELECT * FROM dbc.tables where tablename='HOSPITALISATION_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_HOSPITALISATION_ET;
DROP TABLE STG.HOSPITALISATION_ET;
.LABEL LABEL_SKIP_DELETE_HOSPITALISATION_ET

SELECT * FROM dbc.tables where tablename='HOSPITALISATION_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_HOSPITALISATION_UV;
DROP TABLE STG.HOSPITALISATION_UV;
.LABEL LABEL_SKIP_DELETE_HOSPITALISATION_UV

-- Creation de la table Hospitalisation

CREATE TABLE STG.HOSPITALISATION (
    ID_HOSPI BIGINT NOT NULL PRIMARY KEY,
    ID_CONSULT BIGINT NOT NULL,
    NO_CHAMBRE SMALLINT NOT NULL,
    TS_DEBUT_HOSPI TIMESTAMP(0) NOT NULL,
    TS_FIN_HOSPI TIMESTAMP(0),
    COUT_HOSPI INTEGER,
    ID_PERSONNEL_RESP INTEGER NOT NULL
);

--Table MEDICAMENT
-- Verification si table MEDICAMENT existe
SELECT * FROM dbc.tables where tablename='MEDICAMENT';

-- Suppression de la table MEDICAMENT si elle existe
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_MEDICAMENT;
DROP TABLE STG.MEDICAMENT;

.LABEL LABEL_SKIP_DELETE_MEDICAMENT

-- Suppression des tables Medicament RL, ET et UV 

SELECT * FROM dbc.tables where tablename='MEDICAMENT_RL';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_MEDICAMENT_RL;
DROP TABLE STG.MEDICAMENT_RL;
.LABEL LABEL_SKIP_DELETE_MEDICAMENT_RL

SELECT * FROM dbc.tables where tablename='MEDICAMENT_ET';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_MEDICAMENT_ET;
DROP TABLE STG.MEDICAMENT_ET;
.LABEL LABEL_SKIP_DELETE_MEDICAMENT_ET

SELECT * FROM dbc.tables where tablename='MEDICAMENT_UV';
.IF ACTIVITYCOUNT=0 THEN .GOTO LABEL_SKIP_DELETE_MEDICAMENT_UV;
DROP TABLE STG.MEDICAMENT_UV;
.LABEL LABEL_SKIP_DELETE_MEDICAMENT_UV

-- Creation de la table Medicament

CREATE TABLE STG.MEDICAMENT (
    CD_MEDICAMENT VARCHAR(10) NOT NULL PRIMARY KEY,
    NOM_MEDICAMENT VARCHAR(250),
    CONDIT_MEDICAMENT VARCHAR(100),
    CATG_MEDICAMENT VARCHAR(100) NOT NULL,
    MARQUE_FABRI VARCHAR(100) NOT NULL
);


.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
