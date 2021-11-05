# portal-transparencia
Testes automatizados em Robot Portal da Transparência


## Sobre o Projeto

O projeto portal-transparencia tem como objetivo oferecer um teste de regressão para melhora da qualidade das entregas feitas nos relatórios do Portal da Transparência.

Sobre as validações implementadas neste projeto:

## Sobre a tecnologia

A linguagem utilizada no projeto é python, o framework de testes é o RobotFramework e também utilizei a escrita BDD para deixar numa linguagem fácil para entendimento de todos.

### Sobre a estrutura do projeto

### RESOURCES

1 . Conexão.robot

Dispôe de todas as variáveis armazenando os dados para acesso aos bancos Postgres e Oracle. 
Nesse arquivo também é realizada a inserção da massa de dados, a qual é fixa e não variável, devido ser uma base de testes em que muitas pessoas utilizavam, para gerar maior confiabilidade nos testes, optei por inserir uma massa de dados que é deletada ao final da execução dos testes.

Caso os testes fossem rodados via Pipeline, algumas configurações eram startadas. Como exemplo: Tendo em vista que por meio da Pipeline uma máquina virtual é disparada os testes são rodados e logo em seguida ela é deletada, os scripts de deletes não precisam ser rodados nessa situação.

2 . Resource.robot

Nesse arquivo constarão as implementações das chaves inseridas no arquivo de descrição dos cenários (TestSuiteProcedimentoInvestigatorio.robot). São organizadas por chaves genéricas e por cenário.

Quando a chave necessitar de consulta/alteração via banco, então ela chamará uma chave secundária que será direcionada para o arquivo "ResourceDB.robot".

3 . ResouceDB.robot

Todas as chaves que necessitam de manipulação de banco de dados, serão listadas e programadas nesse arquivo. Nele, são lidos arquivos ".txt" responsáveis por conter as QUERYS de acordo com os valores das variáveis.

Com base no resultado das QUERYS, é retornado um valor que voltará a ser lido no arquivo "ResourceDB.robot" para então ser validada a saída conforme esperado.

### TESTS

1 . TestSuiteProcedimentoInvestigatorio.robot

Constarão nesse arquivo, além da descrição de todos os cenários que serão executados pela suite de teste, também serão definidos os Suite Setup, e Suite Teardown do teste, ou seja, tudo que será executado antes dos cenários e após a sua execução.

### QUERYS

Essa pasta foi dividida entre os arquivos comuns de inserção de massa de dados, tendo em vista que um mesmo script com sintaxe igual para Oracle e Postgres, porém para manipulação de dados, foi-se necessária a criação de duas vertentes, respectivamente para cada banco de dados.

São arquivos que serão utilizados para realização das consultas utilizadas no arquivo "ResourceDB.robot".

Pela pipeline é possível definir qual banco se deseja executar os testes ou manualmente via terminal no momento de rodar a suite.

Mesmo sendo obrigatória a utilização de dois bancos diferentes, consegui utilizar uma mesma suite, com algumas particularidades, mas muito reaproveitamento de código.
