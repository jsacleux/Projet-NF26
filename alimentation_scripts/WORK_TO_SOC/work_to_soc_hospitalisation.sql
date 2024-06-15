LOGON localhost/dbc,dbc;

-- Initialisation suivi TCH
INSERT INTO TCH.T_SUIVI_TRMT(RUN_ID, SCRPT_NAME, EXEC_STRT_DTTM, EXEC_STTS_CD)
VALUES((SELECT MAX(RUN_ID) FROM TCH.T_SUIVI_RUN), 'work_to_soc_hospitalisation.sql', NOW(), 'Running');

CREATE VOLATILE TABLE CURRENT_EXEC_ID
(
current_exec_id int
) PRIMARY INDEX (current_exec_id)
ON COMMIT PRESERVE ROWS;

INSERT INTO CURRENT_EXEC_ID(current_exec_id) SELECT MAX(EXEC_ID) FROM TCH.T_SUIVI_TRMT;

INSERT INTO SOC.O_HOSP (
    HOSP_ID,
    CONS_ID, 
    ROOM_NUM, 
    HOSP_STRT_DTTM, 
    HOSP_END_DTTM, 
    HOSP_FINL_RATE, 
    STFF_ID, 
    EXEC_ID
)
SELECT
    WRK_HOSPITALISATION.ID_HOSPI,
    WRK_HOSPITALISATION.ID_CONSULT,
    WRK_HOSPITALISATION.NO_CHAMBRE, 
    WRK_HOSPITALISATION.TS_DEBUT_HOSPI, 
    WRK_HOSPITALISATION.TS_FIN_HOSPI, 
    WRK_HOSPITALISATION.COUT_HOSPI,
    WRK_HOSPITALISATION.ID_PERSONNEL_RESP,
    (SELECT current_exec_id FROM CURRENT_EXEC_ID)
FROM WRK.WRK_HOSPITALISATION;

-- MAJ etat et date de fin du script dans suivi TCH
.IF ERRORCODE <> 0 THEN .GOTO LABEL_UPDATE_WITH_ERROR;
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='Success'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.GOTO LABEL_UPDATE_SUCCESS

.LABEL LABEL_UPDATE_WITH_ERROR
UPDATE TCH.T_SUIVI_TRMT
SET EXEC_END_DTTM=NOW(), EXEC_STTS_CD='Error'
WHERE EXEC_ID = (SELECT current_exec_id FROM CURRENT_EXEC_ID);
.QUIT 100;

.LABEL LABEL_UPDATE_SUCCESS

.LOGOFF;
.EXIT;