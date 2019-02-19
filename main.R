
library("readxl")

# Processar base de Faixa de CEPs por cidade
source('scripts/e_ceps_correios_2014.R')


# Processar dados do IBGE
source('config.R', encoding = 'UTF-8')
for (ind in indicadores){processar_ibge(ind)}



# Tabela 4.24.4.3.xls
# Tabela 4.24.5.1.xls
# Tabela 4.3.7.2.xls