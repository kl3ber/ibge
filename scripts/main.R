
library("readxl")

# Processar base de Faixa de CEPs por cidade
source('scripts/ceps_correios_2014.R')


# Processar dados do IBGE
source('scripts/config.R', encoding = 'UTF-8')
for (ind in indicadores) {
  processar_ibge(ind)
  print(paste(strftime(Sys.time(), '%H:%M:%S'), ind, sep = ' - '))
}
remove(uf, col, col_comuns, col_final, ind, processar_ibge)S

