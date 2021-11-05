*** Settings ***
Library   DatabaseLibrary
Library   BuiltIn

*** Variables ***
${DBHost}         172.23.70.39
${DBName}         sigtint
${DBPass}         agesune1
${DBPort}         5432
${DBUser}         saj
${DATABASE_IP}    172.23.70.18
${DATABASE_URL}        jdbc:oracle:thin:@172.23.70.18:1521:sigtint
${ORACLE_DRIVER}       oracle.jdbc.driver.OracleDriver

*** Keywords ***
Conectar base Postgres
    Connect To Database    psycopg2    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    #${BANCO}   Set Variable    POST
    #Set Global Variable   ${BANCO}   ${BANCO}
    #Connect To Database     ${ORACLE_DRIVER}    ${DATABASE_URL}   ${DBUser}   ${DBPass}

Conectar base Oracle
    Connect To Database Using Custom Params    cx_Oracle     '${DBUser}/${DBPass}@${DATABASE_IP}:1521/${DBName}'
    #${BANCO}   Set Variable    ORACLE
    #Set Global Variable   ${BANCO}   ${BANCO}
    #Connect To Database Using Custom Params    cx_Oracle     '${DATABASE_USER}/${DATABASE_PASSWORD}@${DATABASE_IP}:1521/${ORACLE_SYSTEM_ID}'

Inserir massa de dados
    ${QUERY}    Execute Sql Script   ${CURDIR}/${DIR_INSERT_DELETE}/${INSERT}.txt

Deletar os registros
    Run Keyword If    '${isPipeline}'=='False'    Execução deletes


Execução deletes
    ${QUERY}=  Run Keyword If    '${BANCO}'=='Postgres'    Execute Sql Script   ${CURDIR}/${DIR_INSERT_DELETE}/${DELETE}${BANCO}.txt
    ${QUERY}=  Run Keyword If    '${BANCO}'=='Oracle'      Execute Sql Script   ${CURDIR}/${DIR_INSERT_DELETE}/${DELETE}${BANCO}.txt

Desconectar Base
    Disconnect From Database
    #OracleDB.Close All Oracle Connections
