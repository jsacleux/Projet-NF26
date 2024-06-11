LOGON localhost/dbc,dbc;

MERGE INTO SOC.R_ROOM AS R_ROOM
USING WRK.WRK_CHAMBRE AS WRK_CHAMBRE
ON R_ROOM.ROOM_NUM = WRK_CHAMBRE.NO_CHAMBRE
WHEN MATCHED THEN
    UPDATE SET
        ROOM_NAME = WRK_CHAMBRE.NOM_CHAMBRE,
        FLOR_NUM = WRK_CHAMBRE.NO_ETAGE,
        BULD_NAME = WRK_CHAMBRE.NOM_BATIMENT,
        ROOM_TYP = WRK_CHAMBRE.TYPE_CHAMBRE,
        ROOM_DAY_RATE = WRK_CHAMBRE.PRIX_JOUR,
        CRTN_DT = WRK_CHAMBRE.DT_CREATION,
        EXEC_ID = 1
WHEN NOT MATCHED THEN
    INSERT (ROOM_NAME, FLOR_NUM, BULD_NAME, ROOM_TYP, ROOM_DAY_RATE, CRTN_DT, EXEC_ID)
    VALUES (WRK_CHAMBRE.NOM_CHAMBRE, WRK_CHAMBRE.NO_ETAGE, WRK_CHAMBRE.NOM_BATIMENT, WRK_CHAMBRE.TYPE_CHAMBRE, WRK_CHAMBRE.PRIX_JOUR, WRK_CHAMBRE.DT_CREATION, 1);

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;


