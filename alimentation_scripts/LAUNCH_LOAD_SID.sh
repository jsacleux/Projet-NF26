#!/bin/bash

### TODO ADD 
## In jobvars.txt :
# LoadLogTable    = 'irs.irs_returns_lg' 
# LoadErrorTable1 = 'irs.irs_returns_et'
# LoadErrorTable2 = 'irs.irs_returns_uv'
# REPEAT FOR ALL STG TABLES (CHAMBRE, CONSULTATION...)

## In load.txt :
# ('DROP TABLE ' || @LoadLogTable || ';'),
# ('DROP TABLE ' || @LoadErrorTable1 || ';'),
# ('DROP TABLE ' || @LoadErrorTable2 || ';'),
# REPEAT FOR ALL STG TABLES (CHAMBRE, CONSULTATION...)

# TODO execution of TPT scripts TO READ ALL DATABASES FROM A GIVEN INPUT DAY

tbuild -f load.txt -v jobvars.txt -j file_load
