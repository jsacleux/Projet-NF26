DATE="$1" 

TargetTdpId           = '127.0.0.1'
TargetUserName        = 'dbc'
TargetUserPassword    = 'dbc'

FileReaderDirectoryPath = "/root/Data_Hospital/BDD_HOSPITAL_${DATE}/"
FileReaderFileName      = "CHAMBRE_\$DATE.txt"
FileReaderFormat        = 'Delimited'
FileReaderOpenMode      = 'Read'
FileReaderTextDelimiter = ';'
FileReaderSkipRows      = 1

DDLErrorList = '3807'

LoadTargetTable = 'STG.CHAMBRE'
