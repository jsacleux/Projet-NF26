.LOGON localhost/dbc,dbc;

UPDATE WRK.WRK_TRAITEMENT
SET MEDC_ID = CD_MEDICAMENT || CATG_MEDICAMENT || MARQUE_FABRI

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
-- doit être un int => row number partition by (a partir des 3 colonnes) (doit prendre la dernière val existante)
-- sélect valeurs uniques puis ajouter le max de l'id du dernier traitement