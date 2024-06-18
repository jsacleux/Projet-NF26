.LOGON localhost/dbc,dbc;

-- Tables in SOC are not recreated if they already exist

-- Check if table R_ROOM exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='R_ROOM' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_R_ROOM;

-- Creation of table R_ROOM
CREATE TABLE SOC.R_ROOM(
    ROOM_NUM        INTEGER NOT NULL,
    ROOM_NAME       VARCHAR(20) NOT NULL,
    FLOR_NUM        VARCHAR(10),
    BULD_NAME       VARCHAR(20),
    ROOM_TYP        VARCHAR(10),
    ROOM_DAY_RATE   SMALLINT NOT NULL,
    CRTN_DT         DATE NOT NULL,
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX (ROOM_NUM);

.LABEL LABEL_SKIP_CREATE_R_ROOM

-- Check if table O_TRET exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_TRET' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_TRET;

-- Creation of table O_TRET
CREATE TABLE SOC.O_TRET(
    TRET_ID         BIGINT NOT NULL,
    MEDC_ID         INTEGER,
    MEDC_QTY        SMALLINT,
    DOSG_DSC        VARCHAR(100) NOT NULL,
    CONS_ID         BIGINT NOT NULL,
    TRET_CRTN_DTTM  TIMESTAMP(0) NOT NULL,
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX (TRET_ID);

.LABEL LABEL_SKIP_CREATE_O_TRET

-- Check if table R_PART exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='R_PART' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_R_PART;

-- Creation of table R_PART
CREATE TABLE SOC.R_PART(
    PART_ID BIGINT NOT NULL,
    SRC_ID INTEGER NOT NULL,
    SRC_TYP VARCHAR(50) NOT NULL
) PRIMARY INDEX(PART_ID);

.LABEL LABEL_SKIP_CREATE_R_PART

-- Check if table O_STFF exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_STFF' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_STFF;

-- Creation of table O_STFF
CREATE TABLE SOC.O_STFF(
    PART_ID         BIGINT NOT NULL,
    WORK_STRT_DTTM  TIMESTAMP(0) NOT NULL,
    WORK_END_DTTM   TIMESTAMP(0),
    WORK_END_RESN   VARCHAR(100),
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX(PART_ID);

.LABEL LABEL_SKIP_CREATE_O_STFF

-- Check if table O_INDV exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_INDV' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_INDV;

-- Creation of table O_INDV
CREATE TABLE SOC.O_INDV(
    PART_ID         BIGINT NOT NULL,
    INDV_NAME       VARCHAR(100) NOT NULL,
    INDV_FIRS_NAME  VARCHAR(100) NOT NULL,
    INDV_STTS_CD    VARCHAR(10) NOT NULL,
    CRTN_DTTM       TIMESTAMP(0) NOT NULL,
    UPDT_DTTM       TIMESTAMP(0) NOT NULL,
    BIRT_DT         DATE,
    BIRT_CITY       VARCHAR(100),
    BIRT_CNTR       VARCHAR(100),
    SOCL_NUM        VARCHAR(15),
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX(PART_ID);

.LABEL LABEL_SKIP_CREATE_O_INDV

-- Check if table O_TELP exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_TELP' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_TELP;

-- Creation of table O_TELP
CREATE TABLE SOC.O_TELP (
    PART_ID         BIGINT NOT NULL,
    CNTR_IND        VARCHAR(5),
    TELP_NUM        VARCHAR(20) NOT NULL,
    STRT_VALD_DTTM  TIMESTAMP(0) NOT NULL,
    END_VALD_DTTM   TIMESTAMP(0) NOT NULL,
    EXEC_ID         INTEGER NOT NULL,
    UNIQUE (PART_ID, STRT_VALD_DTTM)
) PRIMARY INDEX (PART_ID);

.LABEL LABEL_SKIP_CREATE_O_TELP

-- Check if table O_ADDR exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_ADDR' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_ADDR;

-- Creation of table O_ADDR
CREATE TABLE SOC.O_ADDR(
    PART_ID         BIGINT NOT NULL,
    STRT_NUM        VARCHAR(10) NOT NULL,
    STRT_DSC        VARCHAR(250) NOT NULL,
    COMP_STRT       VARCHAR(250),
    POST_CD         VARCHAR(10) NOT NULL,
    CITY_NAME       VARCHAR(100),
    CNTR_NAME       VARCHAR(100),
    STRT_VALD_DTTM  TIMESTAMP(0) NOT NULL,
    END_VALD_DTTM   TIMESTAMP(0) NOT NULL,
    EXEC_ID         INTEGER,
    UNIQUE(PART_ID, STRT_VALD_DTTM)
) PRIMARY INDEX (PART_ID);

.LABEL LABEL_SKIP_CREATE_O_ADDR

-- Check if table O_CONS exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_CONS' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_CONS;

-- Creation of table O_CONS
CREATE TABLE SOC.O_CONS(
    CONS_ID         BIGINT NOT NULL,
    STFF_ID         INTEGER NOT NULL,
    PATN_ID         INTEGER NOT NULL,
    CONS_STRT_DTTM  TIMESTAMP(0) NOT NULL,
    CONS_END_DTTM   TIMESTAMP(0) NOT NULL,
    PATN_WEGH       INTEGER NOT NULL,
    PATN_TEMP       INTEGER,
    TEMP_UNIT       VARCHAR(15),
    BLD_PRSS        INTEGER,
    PATH_DSC        VARCHAR(250),
    DIBT_IND        BYTEINT, -- BOOLEAN 0 or 1 
    TRET_ID         BIGINT,
    HOSP_IND        BYTEINT, -- BOOLEAN 0 or 1 
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX (PATN_ID);

.LABEL LABEL_SKIP_CREATE_O_CONS

-- Check if table O_HOSP exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='O_HOSP' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_O_HOSP;

-- Creation of table O_HOSP
CREATE TABLE SOC.O_HOSP(
    HOSP_ID         BIGINT NOT NULL,
    CONS_ID         BIGINT NOT NULL,
    ROOM_NUM        SMALLINT NOT NULL,
    HOSP_STRT_DTTM  TIMESTAMP(0) NOT NULL,
    HOSP_END_DTTM   TIMESTAMP(0) NOT NULL,
    HOSP_FINL_RATE  INTEGER NOT NULL,
    STFF_ID         INTEGER NOT NULL,
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX (CONS_ID);

.LABEL LABEL_SKIP_CREATE_O_HOSP

-- Check if table R_MEDC exists in database SOC
SELECT * FROM dbc.tables WHERE tablename='R_MEDC' AND databasename='SOC';

-- If the table exists, skip to the next table
.IF ACTIVITYCOUNT>0 THEN .GOTO LABEL_SKIP_CREATE_R_MEDC;

-- Creation of table R_MEDC
CREATE TABLE SOC.R_MEDC(
    MEDC_ID         INTEGER NOT NULL,
    MEDC_CD         VARCHAR(10) NOT NULL,
    MEDC_NAME       VARCHAR(250),
    MEDC_COND       VARCHAR(100),
    MEDC_CATG       VARCHAR(100) NOT NULL,
    MANF_BRND       VARCHAR(100) NOT NULL,
    EXEC_ID         INTEGER NOT NULL
) PRIMARY INDEX (MEDC_ID);

.LABEL LABEL_SKIP_CREATE_R_MEDC

-- Closure
.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
