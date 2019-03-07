# IBGE - Censo Demográfico - 2010
Esse projeto tem como objetivo processar as bases de dados do Censo Demográfico realizado no ano de 2010 pelo IBGE, e disponibilizar o resultado com informações de CEP, Código do IBGE e Nome da Cidade com os indicadores levandos no censo.

## Indicadores
Todos os arquivos mencionados abaixo estão separados por UF. Todos eles possuem 4 seções: `mesorregiões`, `microrregiões`, `municípios, distritos e subdistritos` e `municípios e bairros`
| Arquivo   | Descrição do Indicador |
| :-------------: | ------------- | 
| Tabela 4.x.1.1 | População residente, por situação do domicílio e sexo |
| Tabela 4.x.1.2 | População residente, por grupos de idade |
| Tabela 4.x.1.3 | Pessoas residentes em domicílios particulares, por condição no domicílio e compartilhamento da responsabilidade pelo domicílio |
| Tabela 4.x.2.1 | População residente, por cor ou raça |
| Tabela 4.x.3.1 | Pessoas de até 10 anos de idade, por existência e tipo de registro de nascimento |
| Tabela 4.x.4.1 | Pessoas de 10 anos ou mais de idade, total e alfabetizadas, e taxa de alfabetização das pessoas de 10 anos ou mais de idade, por sexo |
| Tabela 4.x.4.2 | Pessoas de 5 anos ou mais de idade, alfabetizadas, por grupos de idade |
| Tabela 4.x.4.3 | Taxa de alfabetização das pessoas de 5 anos ou mais de idade, por grupos de idade |
| Tabela 4.x.5.1 | Domicílios particulares permanentes, moradores em domicílios particulares permanentes e média de moradores em domicílios particulares permanentes, por situação do domicílio |
| Tabela 4.x.5.2 | Domicílios particulares permanentes, por condição de ocupação do domicílio, existência de energia elétrica e de medidor de consumo de energia elétrica |
| Tabela 4.x.5.3 | Domicílios particulares permanentes, por existência de banheiro ou sanitário e tipo de esgotamento sanitário |
| Tabela 4.x.5.4 | Domicílios particulares permanentes, por forma de abastecimento de água e destino do lixo |
| Tabela 4.x.5.5 | Domicílios particulares permanentes e moradores em domicílios particulares permanentes, por espécie de unidade doméstica |
## Arquivos 
### Pré-requisitos
Baixar os dados do Censo diretamente do site do IBGE. Para este projeto, foi utulizados os dados em `.xls` da url abaixo:
```sh
https://ww2.ibge.gov.br/home/estatistica/populacao/censo2010/caracteristicas_da_populacao/caracteristicas_da_populacao_tab_municipios_zip_xls.shtm
```
### Arquivos corrompidos
O arquivo `error-files.txt` contém o nome de arquivos que estão corrompidos. Necessários abrir esses arquivos e salvá-los novamente, sobrescrevendo os arquivos com erro e mantendo seu formato de `.xls`.

### Executar
Execute o arquivo `main.R` na pasta `scripts` para processar todos os arquivos da pasta input. O resultado estará disponível na pasta output

~~~~
source('~/ibge/scripts/main.R')
~~~~

## To Do
 - Adicionar novos indicadores, de outros censos ou de outras fontes.
 - Automatizar extração dos dados direto de sua URL de origem
 - Tratar automaticamente os arquivos com erros.

## Licença
Livre