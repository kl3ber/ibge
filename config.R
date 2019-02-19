
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

