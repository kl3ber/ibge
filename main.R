
library("readxl")

# Processar base de Faixa de CEPs por cidade
source('scripts/t_ceps_correios_2014.R')


# Processar dados do IBGE
source('config.R', encoding = 'UTF-8')
for (ind in indicadores){processar_ibge(ind)}
remove(uf, col, col_final, ind, processar_ibge)


# Gerar base de Indicadores IBGE por CEP
for (ind in indicadores) {
  gerar_base_cep_indicador(ind)
}

gerar_base_cep_indicador(indicadores[5])



