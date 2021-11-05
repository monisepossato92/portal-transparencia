*** Settings ***
### Library  Selenium
Resource        ../../../resources/Resource.robot
Resource        ../../../resources/ResourceDB.robot
Resource        ../../../resources/Conexao.robot
Suite Setup     Run Keywords  Abrir navegador
...             AND           Conectar base ${BANCO}
...             AND           Definir diretório database
...             AND           Inserir massa de dados
Suite Teardown  Run Keywords  Deletar os registros
...             AND           Desconectar Base
...             AND           Fechar navegador

*** Variables ***
${URL}                        procedimentoinvestigatorio
${MENSAGEM_TOTALIZADOR}       Procedimento(s) Investigatório(s) Criminal(is)
${INSERT}                     insertProcessoPIC
${DIR_INSERT_DELETE}          ../tests/QUERYS/database${BANCO}
${DELETE}                     deleteProcessoPIC
${DIR}                        ../tests/QUERYS/database${BANCO}

*** Test Case ***
Test case 01: PESQUISA SEM FILTRO
#[Setup]   Abrir navegador
#Solicitar relatório de Registros de Procedimentos de Investigação Criminal sem informar nenhum filtro
      Dado que a página inicial do portal seja acessada
      E o recaptcha seja validado
      Quando o botão 'Consultar' for clicado
      Então devem ser apresentados todos os registros que o tipo seja '0602' com sigilo 'P' aptos para demonstração no Portal da Transparência
#[Teardown]  Fechar navegador  -- EXEMPLO DE Teardown

Test case 02: PESQUISA NÚMERO MP
#Solicitar relatório de Registros de Procedimentos de Investigação Criminal informando o número MP válido
      Dado que a página inicial do portal seja acessada
      E seja informado o '062019000009999' no campo 'Número MP'
      Então o sistema deve bloquear os demais campos
      Quando o botão 'Consultar' for clicado
      Então devem ser apresentadas as informações do processo consultado
      E exibir a situação 'Aguardando Portaria' na cor azul
      E exibir a informação 'Servidores sem Vínculo Efetivo, Cedidos e Requisitados' no campo assunto
      E exibir a informação '29ª Promotoria de Justiça da Comarca da Capital' no campo órgão
      E exibir a informação 'Fabiana Helena Batista' no campo parte interessada

Test case 03: PESQUISA NP INVÁLIDO
#Solicitar relatório de Registros de Procedimentos de Investigação Criminal informando o número MP inválido
      Dado que a página inicial do portal seja acessada
      E seja informado o '5646545' no campo 'Número MP'
      Então o sistema deve bloquear os demais campos
      Quando o botão 'Consultar' for clicado
      Então o sistema deve apresentar a mensagem 'Número MP inválido.'
      E sinalizar no campo

Test case 04: PESQUISA POR PARTES INTERESSADAS COM PROCEDIMENTOS COM DIFERENTES NÍVEIS DE SIGILO
#Solicitar relatório de Registros de Procedimentos de Investigação Criminal filtrando por parte interessada
      Dado que a página inicial do portal seja acessada
      E seja informada 'Fabiana Helena Batista' no campo 'Parte interessada'
      Quando o botão 'Consultar' for clicado
      Então o sistema deve apresentar somente os processos com tipo '0602' e sigilo 'P' vinculados a parte interessada

Test case 05: PESQUISA POR ÓRGÃOS EM USO VINCULADOS A PROCEDIMENTOS COM DIFERENTES NÍVEIS DE SIGILO
#Solicitar relatório de Registros de Procedimentos de Investigação Criminal filtrando por órgão vinculado a procedimentos com qualquer tipo de sigilo
      Dado que a página inicial do portal seja acessada
      E seja informado '29ª Promotoria de Justiça da Comarca da Capital' no campo 'Órgão'
      Quando o botão 'Consultar' for clicado
      Então o sistema deve apresentar somente os registros com o tipo '0602' e sigilo 'P' vinculados ao órgão informado