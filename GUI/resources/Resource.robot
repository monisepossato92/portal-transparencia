*** Settings ***
Library  SeleniumLibrary
Library  DateTime

*** Variables ***
${BROWSER}                      chrome
#${URL_POSTGRES}                 http://172.23.70.47:90
${CAMPO_ORGAO}                  xpath=//*[@id='idOrgao']/div/div/div[1]/div[2]/div/input
#xpath=//*[@id='react-select-5-input']
${CAMPO_NUMERO_MP}              id=numeroMPInput
${CAMPO_SITUACAO}               xpath=//*[@id='idSituacao']/div/div/div[1]/div[2]/div/input
${CAMPO_PARTE_INTERESSADA}      id=parteInteressada
${COMBO_ORGAO}                  xpath=//*[@id='idOrgao']/div/div/div[1]/div[1]
${CAMPO_DATA_INICIAL}           id=dataInicial
${CAMPO_DATA_FINAL}             id=dataFinal
${HINT_NUMERO_MP}               xpath=//*[@id="mui-tooltip-83103"]
${CAMPO_TIPO_PROCESSO}          //*[@id="root"]/div[2]/div/div[2]/div[1]/div[1]/div/div/div/div/div/div/div[1]/div[2]/div/input
${CAMPO_ANO}                    //*[@id="ano"]/div/div//input
#${RECAPTCHA}                    xpath=//*[@id="recaptcha-anchor"]/div[4]


*** Keywords ***
#Keywords genéricas
Abrir navegador
    Run Keyword If    '${isPipeline}'=='False'    Open Browser    about:blank  ${BROWSER}
    Run Keyword If    '${isPipeline}'=='True'     Open Browser    about:blank  ${BROWSER}  remote_url=http://${URL_PIPELINE}:4444/wd/hub
    Maximize Browser Window

Fechar navegador
    Close Browser

Abrir URL Postgres
    Go To     http://172.23.70.47:90/portaltransparencia/${URL}

Abrir URL Oracle
    Go To     http://172.23.70.47:91/portaltransparencia/${URL}


### BDD GENÉRICOS
### CONDICAO DADO QUE
Dado que a página inicial do portal seja acessada
    Run Keyword If    '${BANCO}'=='Postgres'   Abrir URL Postgres
    Run Keyword If    '${BANCO}'=='Oracle'     Abrir URL Oracle

### CONDICAO QUANDO
Quando o botão 'Consultar' for clicado
    Click Element    id=btnConsultar

### CONDICAO ENTÃO
Então o sistema deve bloquear os demais campos
    Wait Until Element Is Visible   ${CAMPO_ORGAO}
    Element Should Be Disabled      ${CAMPO_ORGAO}
    Element Should Be Disabled      ${CAMPO_PARTE_INTERESSADA}
    Element Should Be Disabled      ${CAMPO_DATA_INICIAL}
    Element Should Be Disabled      ${CAMPO_DATA_FINAL}

Então o sistema deve apresentar a mensagem '${MENSAGEM}'
    Wait Until Page Contains      ${MENSAGEM}
    #${MENSAGEM}  Set Variable    0 Procedimento(s) Investigatório(s) Criminal(is)
    #${MENS_ESPERADA}  Get Text  xpath=//*[@id='root']/div[1]/div[1]/div[1]
    #Should Be Equal  ${MENS_ESPERADA}  ${MENSAGEM}

### CONDICAO E
E seja informado o '${NUMERO_MP}' no campo 'Número MP'
    Input Text    ${CAMPO_NUMERO_MP}  ${NUMERO_MP}
    Set Test Variable     ${NUMERO_MP}   ${NUMERO_MP}

### C01
Então devem ser apresentados todos os registros que o tipo seja '${TIPO_PROCEDIMENTO}' com sigilo '${SIGILO}' aptos para demonstração no Portal da Transparência
    Verifica no banco os registros do tipo '${TIPO_PROCEDIMENTO}' e sigilo '${SIGILO}' aptos para visualização na WEB
    ${CONCAT_MENSAGEM}  Set Variable  ${TODOS[0][0]} ${MENSAGEM_TOTALIZADOR}
    Wait Until Page Contains    ${CONCAT_MENSAGEM}

### C02
Então devem ser apresentadas as informações do processo consultado
    Wait Until Page Contains    1 ${MENSAGEM_TOTALIZADOR}

E exibir a situação '${SITUACAO_PROCESSO}' na cor azul
    Page Should Contain    ${SITUACAO_PROCESSO}
    Sleep       1s
    ${STYLE}=   Get Element Attribute     //*[@id="root"]/div/div[1]/div[3]/div[1]/div[1]/div[1]/div   style
    ${STYLE}    ${BGCOLOR}    Split String    ${STYLE}    background-color:
    ${BGCOLOR}=  Remove String   ${BGCOLOR}   ;
    Should Be Equal   ' rgb(91, 143, 199)'   '${BGCOLOR}'

E exibir a informação '${ASSUNTO}' no campo assunto
    Element Text Should Be    xpath=//*[@id="root"]/div/div[1]/div[3]/div[1]/div[2]/div[2]    ${ASSUNTO}

E exibir a informação '${ORGAO_USO}' no campo órgão
    Element Text Should Be    xpath=//*[@id="root"]/div/div[1]/div[3]/div[1]/div[3]/div[2]    ${ORGAO_USO}

E exibir a informação '${PARTE_INTERESSADA}' no campo parte interessada
    Element Text Should Be    xpath=//*[@id="root"]/div/div[1]/div[3]/div[1]/div[4]/div[2]    ${PARTE_INTERESSADA}

### C03
Então o sistema deve apresentar a mensagem 'Número MP inválido.'
    Wait Until Element Is Visible  xpath=//*[@id='root']/div[1]/div/div/div[2]

E sinalizar no campo
    Wait Until Element Is Visible  xpath=//*[@id='numeroMPInput-text']

### C04
E seja informada '${PARTE_INTERESSADA}' no campo 'Parte interessada'
    Input Text    ${CAMPO_PARTE_INTERESSADA}   ${PARTE_INTERESSADA}
    Set Test Variable     ${PARTE_INTERESSADA}   ${PARTE_INTERESSADA}

Então o sistema deve apresentar somente os processos com tipo '${TIPO_PROCEDIMENTO}' e sigilo '${SIGILO}' vinculados a parte interessada
    Verifica a quantidade dos processos com tipo '${TIPO_PROCEDIMENTO}' e sigilo '${SIGILO}' vinculados a parte interessada
    ${CONCAT_MENSAGEM}  Set Variable    ${COUNT_PARTE_SIGILO_TODOS[0][0]} ${MENSAGEM_TOTALIZADOR}
    Wait Until Page Contains    ${CONCAT_MENSAGEM}

### C05
E seja informado '${ORGAO_USO}' no campo 'Órgão'
    Input Text              ${CAMPO_ORGAO}    ${ORGAO_USO}
    Wait Until Element Is Visible    //*[contains(@class,"css-") and contains(@class,"-option") and text()="${ORGAO_USO}"]
    #Click Element                    //*[contains(@class,"css-") and contains(@class,"-option") and text()="${ORGAO_USO}"]
    Press Keys    None    RETURN
    Sleep    1s
    Set Test Variable     ${ORGAO_USO}    ${ORGAO_USO}

Então o sistema deve apresentar somente os registros com o tipo '${TIPO_PROCEDIMENTO}' e sigilo '${SIGILO}' vinculados ao órgão informado
    Verifica os procedimentos com sigilo '${SIGILO}' e tipo '${TIPO_PROCEDIMENTO}' vinculados ao órgão
    ${CONCAT_MENSAGEM}  Set Variable        ${COUNT_ORGAO_EM_USO[0][0]} ${MENSAGEM_TOTALIZADOR}
    Wait Until Page Contains                ${CONCAT_MENSAGEM}