
### Tratar faixas de CEPs faltantes

ceps = read.csv('data/input/ceps_correios/ceps_correios.csv', colClasses=c("numeric",rep("character",4)))
ceps = ceps[order(ceps$CEP_INICIO),]

for (i in seq(1:(nrow(ceps) - 1))) {
  if (as.integer(ceps[i, 'CEP_FINAL']) + 1 != as.integer(ceps[i+1, 'CEP_INICIO'])) {
    ceps[i, 'CEP_FINAL'] = ceps[i+1, 'CEP_INICIO']
  }
}
  
write.csv(ceps, file='data/transform/t_ceps_correios.csv', row.names=F)
remove(ceps)




