
library("readxl")

# Processar base de Faixa de CEPs por cidade
source('scripts/e_ceps_correios_2014.R')


# Processar dados do IBGE
source('config.R', encoding = 'UTF-8')
for (ind in indicadores){processar_ibge(ind)}
remove(uf, col, col_final, ind, processar_ibge)


# Gerar base de Indicadores IBGE por CEP
for (ind in indicadores) {
  
  
}

ind='1_1'
ceps = read.csv('data/extract/ceps_correios.csv', colClasses=c("numeric",rep("character",4)))
ibge = read.csv(paste('data/extract/e_ibge_indicador_', ind,'.csv', sep=''), stringsAsFactors = F)
FINAL = merge(x=ceps, y=ibge, by=c('UF', 'CIDADE'), all.x = T)
remove(ceps, ibge)

sample = read.csv('tests/sample.csv', stringsAsFactors = F, col.names=c('CEP', 'UF', 'CIDADE'))
sample$cep_char = sapply(sample, nchar)[,'CEP']
sample[sample$cep_char < 7, 'CEP'] = '0'
sample[sample$cep_char == 7, 'CEP'] = paste('0', sample[sample$cep_char == 7, 'CEP'], sep='')

#sample = sample[sample$CEP != '0',]
sample$CEP = substr(sample$CEP, 1, 5)
sample$ID_CIDADE = sapply(sample$CEP, function(x) FINAL$ID_CIDADE[which(x >= FINAL$CEP_INICIO & x <= FINAL$CEP_FINAL)])

merge(x=sample, y=FINAL, by='ID_CIDADE', all.x = T)





write.csv(sample, '')



