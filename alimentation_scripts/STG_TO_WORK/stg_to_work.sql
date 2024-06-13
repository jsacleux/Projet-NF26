LOGON localhost/dbc,dbc;

INSERT INTO WRK.WRK_CHAMBRE (NO_CHAMBRE, NOM_CHAMBRE, NO_ETAGE, 
    NOM_BATIMENT, TYPE_CHAMBRE, PRIX_JOUR, DT_CREATION) 
SELECT * FROM STG.CHAMBRE;


INSERT INTO WRK.WRK_TRAITEMENT (ID_TRAITEMENT, CD_MEDICAMENT, 
    CATG_MEDICAMENT, MARQUE_FABRI, QTE_MEDICAMENT,
    DSC_POSOLOGIE, ID_CONSULT, TS_CREATION_TRAITEMENT, MEDC_ID) 
SELECT ID_TRAITEMENT, CD_MEDICAMENT, CATG_MEDICAMENT, 
    MARQUE_FABRI, QTE_MEDICAMENT,
    DSC_POSOLOGIE, ID_CONSULT, TS_CREATION_TRAITEMENT , CONCAT(CD_MEDICAMENT, CATG_MEDICAMENT, MARQUE_FABRI) AS MEDC_ID
    FROM STG.TRAITEMENT;


INSERT INTO WRK.WRK_INDIVIDU (PART_ID, INDIVIDU_ID, FONCTION_INDIVIDU, INDV_NAME, 
    INDV_FIRS_NAME, INDV_STTS_CD, TS_CREATION, TS_MAJ) 
SELECT CONCAT(ID_PERSONNEL, FONCTION_PERSONNEL) AS PART_ID, ID_PERSONNEL, FONCTION_PERSONNEL, NOM_PERSONNEL, PRENOM_PERSONNEL, 
    CD_STATUT_PERSONNEL, TS_CREATION_PERSONNEL, TS_MAJ_PERSONNEL 
    FROM STG.PERSONNEL;

INSERT INTO WRK.WRK_INDIVIDU (PART_ID, INDIVIDU_ID, FONCTION_INDIVIDU, INDV_NAME, 
    INDV_FIRS_NAME, TS_CREATION, TS_MAJ, DT_NAISS, VILLE_NAISS, PAYS_NAISS, NUM_SECU, INDV_STTS_CD) 
SELECT CONCAT(ID_PATIENT, 'Patient') AS PART_ID, ID_PATIENT, 'Patient' AS FONCTION_INDIVIDU, 
    NOM_PATIENT, PRENOM_PATIENT, TS_CREATION_PATIENT, TS_MAJ_PERSONNEL, 
    DT_NAISS, VILLE_NAISS, PAYS_NAISS, NUM_SECU, 'Actif' AS INDV_STTS_CD
    FROM STG.PATIENT;



INSERT INTO WRK.WRK_CONSULTATION (ID_CONSULT, ID_PERSONNEL, ID_PATIENT, 
    TS_DEBUT_CONSULT, TS_FIN_CONSULT,
    POIDS_PATIENT, TEMP_PATIENT, UNIT_TEMP, TENSION_PATIENT, 
    DSC_PATHO, INDIC_DIABETE, ID_TRAITEMENT , INDIC_HOSPI) 
SELECT * FROM STG.CONSULTATION;


INSERT INTO WRK.WRK_HOSPITALISATION (ID_HOSPI, ID_CONSULT, NO_CHAMBRE, 
    TS_DEBUT_HOSPI, TS_FIN_HOSPI, COUT_HOSPI, ID_PERSONNEL_RESP) 
SELECT * FROM STG.HOSPITALISATION;


INSERT INTO WRK.WRK_MEDICAMENT (MEDC_ID, CD_MEDICAMENT, NOM_MEDICAMENT, CONDIT_MEDICAMENT,
    CATG_MEDICAMENT, MARQUE_FABRI) 
SELECT CONCAT(CD_MEDICAMENT, CATG_MEDICAMENT, MARQUE_FABRI) AS MEDC_ID, CD_MEDICAMENT, NOM_MEDICAMENT, CONDIT_MEDICAMENT,
    CATG_MEDICAMENT, MARQUE_FABRI FROM STG.MEDICAMENT;


INSERT INTO WRK.WRK_ADRESSE (PART_ID, INDIVIDU_ID, FONCTION_INDIVIDU, STRT_NUM, STRT_DSC, COMP_STRT, 
    POST_CD, CITY_NAME, CNTR_NAME, TS_CREATION_PATIENT, TS_MAJ_PATIENT) 
SELECT CONCAT(CAST(ID_PATIENT AS VARCHAR(20)), 'Patient') AS PART_ID, ID_PATIENT, 'Patient' AS FONCTION_INDIVIDU, NUM_VOIE, DSC_VOIE, CMPL_VOIE, CD_POSTAL, VILLE, 
    PAYS, TS_CREATION_PATIENT, TS_MAJ_PERSONNEL
    FROM STG.PATIENT;


INSERT INTO WRK.WRK_TELP (PART_ID, INDIVIDU_ID, FONCTION_INDIVIDU, IND_PAYS_NUM_TELP, NUM_TELEPHONE,
    TS_CREATION_PATIENT, TS_MAJ_PATIENT) 
SELECT CONCAT(ID_PATIENT, 'Patient') AS PART_ID, ID_PATIENT, 'Patient' AS FONCTION_INDIVIDU, 
    IND_PAYS_NUM_TELP, NUM_TELEPHONE,
    TS_CREATION_PATIENT, TS_MAJ_PERSONNEL
    FROM STG.PATIENT;

INSERT INTO WRK.WRK_RPART (PART_ID, INDIVIDU_ID, FONCTION_INDIVIDU) 
SELECT CONCAT(ID_PATIENT, 'Patient') AS PART_ID, ID_PATIENT, 'Patient' AS FONCTION_INDIVIDU FROM STG.PATIENT;

INSERT INTO WRK.WRK_RPART (PART_ID, INDIVIDU_ID, FONCTION_INDIVIDU) 
SELECT CONCAT(ID_PERSONNEL, FONCTION_PERSONNEL) AS PART_ID, ID_PERSONNEL, FONCTION_PERSONNEL FROM STG.PERSONNEL;

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;