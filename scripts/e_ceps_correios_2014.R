
### Extrair dados do txt de Ceps  do Correios

ceps = read.csv('data/ceps_correios/consulta.cep.correios.gpbe.2014.txt', 
                header=F, 
                sep=';', 
                col.names= c('ID_CIDADE', 'CIDADE', 'UF', 'CEP_INICIO', 'CEP_FINAL'),
                colClasses=c("numeric",rep("character",4))
                )

ceps$CIDADE = toupper(iconv(ceps$CIDADE, to='ASCII//TRANSLIT'))
write.csv(ceps, file='data/extract/ceps_correios.csv', row.names=F)

