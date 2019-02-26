
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
uf$ID_UF = sapply(uf$ID_UF, as.integer)


### Indicadores à serem processados
indicadores = c('1_1', '1_2', '2_1', '4_3', '5_1', '7_1', '7_2')


### Processamento dos arquivos do ibge
processar_ibge = function(indicador) {
  source(paste('scripts/e_ibge_indicador_', indicador, '.R', sep=''), encoding='UTF-8')
  FINAL = data.frame(matrix(NA, nrow = 1, ncol = 0))
  
  for (i in seq(1, nrow(uf))) {
    estado = uf[uf$ID_UF == i, 'UF']
    arquivo = paste('data/input/ibge/Tabela 4', i, gsub('_', '.', indicador), 'xls', sep='.')
    ceps = read_xls(arquivo, col_names = col)
    for (j in seq(2,5)) {ceps[, paste('CIDADE', j, sep='_')] = NULL}
    remove(j)
    

    # Filtrar seções
    primeira_secao = c('Mesorregiões')
    segunda_secao = c('Microrregiões')
    terceira_secao = c('Municípios e Distritos', 'Municípios, Distritos e Subdistritos', 'Municípios')
    quarta_secao = c('Municípios e Bairros')

    linha_corte = match(terceira_secao[1], ceps$CIDADE) + 1
    if (is.na(linha_corte)) {linha_corte = match(terceira_secao[2], ceps$CIDADE) + 1}
    if (is.na(linha_corte)) {linha_corte = match(terceira_secao[3], ceps$CIDADE) + 1}
    ceps = ceps[linha_corte:nrow(ceps),]

    linha_corte = match(quarta_secao[1], ceps$CIDADE) - 1
    if (is.na(linha_corte) == F) {ceps = ceps[1:linha_corte,]}
    remove(primeira_secao, segunda_secao, terceira_secao, quarta_secao, linha_corte)
    

    # Tratamento e ordenação das colunas
    ceps = na.omit(ceps)
    ceps$UF = estado
    ceps = ceps[, c((ncol(ceps) - 1):ncol(ceps), rep(1:(ncol(ceps) - 2)))]
    ceps$CIDADE = toupper(iconv(ceps$CIDADE, from='UTF-8' , to='ASCII//TRANSLIT'))
    
    
    # Cidades que possuem código de IBGE de 7 digitos, porém não possuem um com 9 digitos
    add_excessoes = mapply(setdiff, 
                           ceps[nchar(ceps$COD_IBGE) == 7, c('CIDADE')], 
                           ceps[nchar(ceps$COD_IBGE) == 9, c('CIDADE')])
    
 
    teste = ceps[ceps$CIDADE %in% add_excessoes, ]
    ceps = ceps[nchar(ceps$COD_IBGE) == 9, ]
    ceps = rbind(ceps, teste)
    
  
    # Tratamento dos valores numéricos
    ceps[,4:ncol(ceps)] = apply(ceps[,4:ncol(ceps)], 2, function(x) gsub("-", 0, x))
    ceps[,4:ncol(ceps)] = apply(ceps[,4:ncol(ceps)], 2, function(x) gsub("x", 0, x))
    ceps[,4:ncol(ceps)] = sapply(ceps[,4:ncol(ceps)], as.integer)
    
    FINAL = rbind(FINAL, ceps)
  }
  
  FINAL = FINAL[, col_final]
  write.csv(FINAL, file=paste('data/processed/e_ibge_indicador_', indicador, '.csv',sep=''), row.names=F)
  remove(estado, arquivo, ceps)
}


