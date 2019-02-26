

ceps = read.csv('tests/sample.csv', stringsAsFactors = F)
colnames(ceps) = c('CEP',' UF', 'CIDADE')

indicador = '1_1'
ibge = read.csv('data/extract/e_ibge_indicador_1_1.csv', stringsAsFactors = F)



ind_1_1 = merge(x=ceps, y=ibge, by=c('UF', 'CIDADE'), all.x = T)

str(ceps)
str(ibge)
