LOGON localhost/dbc,dbc;

INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'chambre.sql', NOW(), 'Running');

UPDATE SOC.R_ROOM
FROM WRK.WRK_CHAMBRE
SET
    ROOM_NAME = WRK.WRK_CHAMBRE.NOM_CHAMBRE,
    FLOR_NUM = WRK.WRK_CHAMBRE.NO_ETAGE,
    BULD_NAME = WRK.WRK_CHAMBRE.NOM_BATIMENT,
    ROOM_TYP = WRK.WRK_CHAMBRE.TYPE_CHAMBRE,
    ROOM_DAY_RATE = WRK.WRK_CHAMBRE.PRIX_JOUR,
    CRTN_DT = WRK.WRK_CHAMBRE.DT_CREATION,
    EXEC_ID = (SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT)
WHERE R_ROOM.ROOM_NUM = WRK.WRK_CHAMBRE.NO_CHAMBRE;


INSERT INTO SOC.R_ROOM (
    ROOM_NUM,
    ROOM_NAME, 
    FLOR_NUM, 
    BULD_NAME, 
    ROOM_TYP, 
    ROOM_DAY_RATE, 
    CRTN_DT, 
    EXEC_ID
)
SELECT
    NO_CHAMBRE,
    NOM_CHAMBRE, 
    NO_ETAGE, 
    NOM_BATIMENT,
    TYPE_CHAMBRE, 
    PRIX_JOUR, 
    DT_CREATION,
    (SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT)
FROM WRK.WRK_CHAMBRE
WHERE NOT EXISTS (
    SELECT 1 FROM SOC.R_ROOM
    WHERE SOC.R_ROOM.ROOM_NUM = WRK.WRK_CHAMBRE.NO_CHAMBRE
);

.IF ERRORCODE <> 0 THEN .QUIT 100;

UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='Ended'
WHERE EXEC_ID = (SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT);

.LOGOFF;
.EXIT;
