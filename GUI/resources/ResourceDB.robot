*** Settings ***
Library   DatabaseLibrary
Library   Collections
Library   String
Library   OperatingSystem
Library   BuiltIn
#Library   cx_Oracle

*** Variables ***
${isPipeline}      False
#${DBHost}         172.23.70.39
#${DBName}         sigtint
#${DBPass}         agesune1
#${DBPort}         5432
#${DBUser}         saj
#${DATABASE_IP}    172.23.70.18
#${DATABASE_URL}        jdbc:oracle:thin:@172.23.70.18:1521:sigtint
#${ORACLE_DRIVER}       oracle.jdbc.driver.OracleDriver

*** Keywords ***
### C01
Verifica no banco os registros do tipo '${TIPO_PROCEDIMENTO}' e sigilo '${SIGILO}' aptos para visualização na WEB
    ${QUERY}    Get File    ${CURDIR}/${DIR}/TODOS${BANCO}.txt
    ${QUERY}    Replace Variables    ${QUERY}
    ${TODOS}=  QUERY    ${QUERY}
    Set Test Variable    ${TODOS[0][0]}  ${TODOS[0][0]}
    [Return]             ${TODOS[0][0]}

### C04
Verifica a quantidade dos processos com tipo '${TIPO_PROCEDIMENTO}' e sigilo '${SIGILO}' vinculados a parte interessada
    ${QUERY}    Get File    ${CURDIR}/${DIR}/QuantidadeParte${BANCO}.txt
    ${QUERY}    Replace Variables    ${QUERY}
    ${COUNT_PARTE_SIGILO_TODOS}=  QUERY    ${QUERY}
    Set Test Variable    ${COUNT_PARTE_SIGILO_TODOS[0][0]}      ${COUNT_PARTE_SIGILO_TODOS[0][0]}
    [Return]               ${COUNT_PARTE_SIGILO_TODOS[0][0]}

### C05
Verifica os procedimentos com sigilo '${SIGILO}' e tipo '${TIPO_PROCEDIMENTO}' vinculados ao órgão
    ${QUERY}    Get File    ${CURDIR}/${DIR}/QuantidadeOrgaoEmUso${BANCO}.txt
    ${QUERY}    Replace Variables    ${QUERY}
    ${COUNT_ORGAO_EM_USO}=  QUERY    ${QUERY}
    Set Test Variable    ${COUNT_ORGAO_EM_USO[0][0]}   ${COUNT_ORGAO_EM_USO[0][0]}
    [Return]   ${COUNT_ORGAO_EM_USO[0][0]}