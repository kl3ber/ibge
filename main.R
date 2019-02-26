
library("readxl")

# Processar base de Faixa de CEPs por cidade
source('scripts/e_ceps_correios_2014.R')


# Processar dados do IBGE
source('config.R', encoding = 'UTF-8')
for (ind in indicadores){processar_ibge(ind)}
remove(uf, col, col_final, ind, processar_ibge)


# Gerar base de Indicadores IBGE por CEP
for (ind in indicadores) {
  gerar_base_cep_indicador(indicadores[5])
}


pesquisar_ceps = function(indicador) {
  ceps = read.csv('data/extract/ceps_correios.csv', colClasses=c("numeric",rep("character",4)))
  ibge = read.csv(paste('data/extract/e_ibge_indicador_', indicador,'.csv', sep=''), stringsAsFactors = F)
  INDICADOR = merge(x=ceps, y=ibge, by=c('UF', 'CIDADE'), all.x = T)
  remove(ceps, ibge)
  
  sample = read.csv('tests/sample.csv', stringsAsFactors = F, col.names=c('CEP', 'UF', 'CIDADE'))
  sample$cep_char = sapply(sample, nchar)[,'CEP']
  sample[sample$cep_char < 7, 'CEP'] = '0'
  sample[sample$cep_char == 7, 'CEP'] = paste('0', sample[sample$cep_char == 7, 'CEP'], sep='')
  sample$cep_char = NULL
  
  for (i in seq(nrow(sample))) {
    cep = sample$CEP[i]
    id_cidade = INDICADOR$ID_CIDADE[which(cep >= INDICADOR$CEP_INICIO & cep <= INDICADOR$CEP_FINAL)]
    if (length(id_cidade) == 0) {id_cidade = 0}
    sample$ID_CIDADE[i] = id_cidade
  }
  
  INDICADOR = INDICADOR[,c(3,6, 7:ncol(INDICADOR))]
  FINAL = merge(x=sample, y=INDICADOR, by='ID_CIDADE', all.x = T)
  
  arquivo = paste('data/output/',  gsub('\\D+','', Sys.time()), '_indicador_', indicador, '.csv', sep='')
  write.csv(FINAL, arquivo, row.names = F)
}



