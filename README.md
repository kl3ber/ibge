# IBGE - Censo Demográfico - 2010
Esse projeto tem como objetivo processar as bases de dados do Censo Demográfico realizado no ano de 2010 pelo IBGE, e disponibilizar o resultado com informações de CEP, Código do IBGE e Nome da Cidade com os indicadores levandos no censo.

## Indicadores
Todos os arquivos mencionados abaixo estão separados por UF.
| Arquivo        | Descrição do Indicador |
| :-------------: |:-------------:| 
| Tabela 4.x.1.1| População residente, por situação do domicílio e sexo |
| Tabela 4.x.1.2| População residente, por grupos de idade |
| Tabela 4.x.1.3| Pessoas residentes em domicílios particulares, por condição no domicílio e compartilhamento da responsabilidade pelo domicílio |
| Tabela 4.x.2.1| População residente, por cor ou raça |


## Arquivos 
### Pré-requisitos
Baixar os dados do Censo diretamente do site do IBGE. Para este projeto, foi utulizados os dados em .xls da url abaixo:
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