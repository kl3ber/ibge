

library("readxl")
source('config.R')

i = 1
indicador = '1_1'
col = c(
  'CIDADE', 
  'Total', 'Homens', 'Mulheres', 
  'Urbano_Total', 'Urbano_Homens', 'Urbano_Mulheres',
  'Rural_Total', 'Rural_Homens', 'Rural_Mulheres',
  'COD_IBGE'
)
col_final = c(
  'COD_IBGE', 'UF', 'CIDADE',
  'Total', 'Homens', 'Mulheres'
)

FINAL = data.frame(matrix(NA, nrow = 1, ncol = 0))


for (i in seq(1, nrow(uf))) {
  estado = uf[uf$ID_UF == i, 'UF']
  arquivo = paste('data/ibge/Tabela 4', i, gsub('_', '.', indicador), 'xls', sep='.')
  ceps = read_xls(arquivo, col_names = col)
  
  
  # Filtrar apenas municípios
  corte_superior = c('Municípios e Distritos', 'Municípios, Distritos e Subdistritos')
  corte_inferior = c('Municípios e Bairros')
  
  linha_corte = match(corte_superior[1], ceps$CIDADE) + 1
  if (is.na(linha_corte)) {linha_corte = match(corte_superior[2], ceps$CIDADE) + 1}
  ceps = ceps[linha_corte:nrow(ceps),]
  
  linha_corte = match(corte_inferior[1], ceps$CIDADE) - 1
  if (is.na(linha_corte) == F) {ceps = ceps[1:linha_corte,]}
  
  
  # Tratamento das colunas
  ceps = na.omit(ceps)
  ceps$UF = estado
  ceps = ceps[, c((ncol(ceps) - 1):ncol(ceps), rep(1:(ncol(ceps) - 2)))]
  ceps = ceps[nchar(ceps$COD_IBGE) == 9, ]
  
  ceps[,4:ncol(ceps)] = apply(ceps[,4:ncol(ceps)], 2, function(x) gsub("-", 0, x))
  ceps[,4:ncol(ceps)] = apply(ceps[,4:ncol(ceps)], 2, function(x) gsub("x", 0, x))
  ceps[,4:ncol(ceps)] = sapply(ceps[,4:ncol(ceps)], as.integer)
  
  ceps$CIDADE = toupper(iconv(ceps$CIDADE, from='UTF-8' , to='ASCII//TRANSLIT'))
  
  FINAL = rbind(FINAL, ceps)
}

FINAL = FINAL[, col_final]
write.csv(FINAL, file=paste('data/extract/e_ibge_indicador_', indicador, '.csv',sep=''), row.names=F)



