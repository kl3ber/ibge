
### Declarar códigos de UF usados pelo IBGE
uf = data.frame(rbind(
  c(01, 'RO', 'RONDONIA'),
  c(02, 'AC', 'ACRE'),
  c(03, 'AM', 'AMAZONAS'),
  c(04, 'RR', 'RORAIMA'),
  c(05, 'PA', 'PARA'),
  c(06, 'AP', 'AMAPA'),
  c(07, 'TO', 'TOCANTINS'),
  c(08, 'MA', 'MARANHAO'),
  c(09, 'PI', 'PIAUI'),
  c(10, 'CE', 'CEARA'),
  c(11, 'RN', 'RIO GRANDE DO NORTE'),
  c(12, 'PB', 'PARAIBA'),
  c(13, 'PE', 'PERNAMBUCO'),
  c(14, 'AL', 'ALAGOAS'),
  c(15, 'SE', 'SERGIPE'),
  c(16, 'BA', 'BAHIA'),
  c(17, 'MG', 'MINAS GERAIS'),
  c(18, 'ES', 'ESPIRITO SANTO'),
  c(19, 'RJ', 'RIO DE JANEIRO'),
  c(20, 'SP', 'SAO PAULO'),
  c(21, 'PR', 'PARANA'),
  c(22, 'SC', 'SANTA CATARINA'),
  c(23, 'RS', 'RIO GRANDE DO SUL'),
  c(24, 'MS', 'MATO GROSSO DO SUL'),
  c(25, 'MT', 'MATO GROSSO'),
  c(26, 'GO', 'GOAIS'),
  c(27, 'DF', 'DISTRITO FEDERAL')
), stringsAsFactors=FALSE)
colnames(uf) = c('ID_UF', 'UF', 'ESTADO')
uf$ID_UF = apply(as.matrix(uf$ID_UF), 2, as.integer)



### Indicadores à serem processados
indicadores = c('1_1', '1_2', '2_1', '4_3', '5_1', '7_1', '7_2')


### Colunas finais comuns à todos os indicadores
col_comuns = c('COD_IBGE', 'ID_CIDADE', 'UF', 'CIDADE', 'CEP_INICIO', 'CEP_FINAL')


### Processamento dos arquivos do ibge
processar_ibge = function(indicador) {
  source(paste('scripts/ibge_indicador_', indicador, '.R', sep=''), encoding='UTF-8')
  FINAL = data.frame(matrix(NA, nrow = 1, ncol = 0))
  
  for (i in seq(1, nrow(uf))) {
    estado = uf[uf$ID_UF == i, 'UF']
    arquivo = paste('data/input/ibge/Tabela 4', i, gsub('_', '.', indicador), 'xls', sep='.')
    ibge = read_xls(arquivo, col_names = col)
    for (j in seq(2,5)) {ibge[, paste('CIDADE', j, sep='_')] = NULL}
    remove(j)
    
    # Filtrar seções
    primeira_secao = c('Mesorregiões')
    segunda_secao = c('Microrregiões')
    terceira_secao = c('Municípios e Distritos', 'Municípios, Distritos e Subdistritos', 'Municípios')
    quarta_secao = c('Municípios e Bairros')

    linha_corte = match(terceira_secao[1], ibge$CIDADE) + 1
    if (is.na(linha_corte)) {linha_corte = match(terceira_secao[2], ibge$CIDADE) + 1}
    if (is.na(linha_corte)) {linha_corte = match(terceira_secao[3], ibge$CIDADE) + 1}
    ibge = ibge[linha_corte:nrow(ibge),]

    linha_corte = match(quarta_secao[1], ibge$CIDADE) - 1
    if (is.na(linha_corte) == F) {ibge = ibge[1:linha_corte,]}
    remove(primeira_secao, segunda_secao, terceira_secao, quarta_secao, linha_corte)
    
    # Tratamento e ordenação das colunas
    ibge = na.omit(ibge)
    ibge$UF = estado
    ibge = ibge[, c((ncol(ibge) - 1):ncol(ibge), rep(1:(ncol(ibge) - 2)))]
    ibge$CIDADE = toupper(iconv(ibge$CIDADE, from='UTF-8' , to='ASCII//TRANSLIT'))
    
    # Tratamento de excessões
    if (i == 20) {
      ibge[ibge$CIDADE == 'MOJI MIRIM', 'CIDADE'] = 'MOGI MIRIM'
      ibge = rbind(ibge[nchar(ibge$COD_IBGE) == 9, ], ibge[ibge$CIDADE == 'SAO PAULO',])
    } else if (i == 23) {
      ibge[ibge$CIDADE == "SANT'ANA DO LIVRAMENTO", 'CIDADE'] = 'SANTANA DO LIVRAMENTO'
      ibge = ibge[nchar(ibge$COD_IBGE) == 9, ]
    } else {
      ibge = ibge[nchar(ibge$COD_IBGE) == 9, ]
    }
  
    # Tratamento dos valores numéricos
    ibge[,4:ncol(ibge)] = apply(ibge[,4:ncol(ibge)], 2, function(x) gsub("-", 0, x))
    ibge[,4:ncol(ibge)] = apply(ibge[,4:ncol(ibge)], 2, function(x) gsub("x", 0, x))
    ibge[,4:ncol(ibge)] = apply(as.matrix(ibge[,4:ncol(ibge)]), 2, as.integer)
    
    FINAL = rbind(FINAL, ibge)
  }
  
  # Cruzamento com a base de CEPs
  ceps = read.csv('data/output/ceps_correios.csv', colClasses=c("numeric",rep("character",4)))
  
  FINAL = merge(x=ceps, y=FINAL, by=c('UF', 'CIDADE'), all.x = TRUE)
  FINAL = FINAL[-which(FINAL$COD_IBGE %in% c('350945215','412380825')),]
  FINAL = FINAL[, c(col_comuns, col_final)]
  
  write.csv(FINAL, file=paste('data/output/ibge_indicador_', indicador, '.csv',sep=''), row.names=F)
  remove(estado, arquivo, ibge, ceps)
}



### Pesquisar CEPs nos arquivos processados do IBGE
pesquisar_ceps = function(indicador) {
  ceps = read.csv('data/transform/t_ceps_correios.csv', colClasses=c("numeric",rep("character",4)))
  ibge = read.csv(paste('data/transform/t_ibge_indicador_', indicador,'.csv', sep=''), stringsAsFactors = F)
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

