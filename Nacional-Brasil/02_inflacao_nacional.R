library(RSIDRA)
library(tidyverse)
library(stringr)
# ----- IPCA (geral) -----------------------------------------------------------
ipca_cheio_mes <- API_SIDRA(1419, 315, 7169, periodo = "last4", variavel = "63") %>% 
  select(mes = Mês, Valor) %>% 
  mutate(indice = "IPCA", mes = str_extract(mes, "\\w+")) %>% 
  spread(mes, Valor)

ipca_cheio_ano <- API_SIDRA(1419, 315, 7169, periodo = "last", variavel = "69") %>% 
  mutate(indice = "IPCA") %>% 
  select(indice, `No ano` = Valor)

# Reproduz a parte do IPCA da tabela VIII.1
left_join(ipca_cheio_mes, ipca_cheio_ano, "indice")


# ----- IPCA (componentes) -----------------------------------------------------
ipca_componentes_mes <- API_SIDRA(
  1419, 315, "7169,7170,7445,7486,7558,7625,7660,7712,7766,7786", 
  periodo = "last4", variavel = "63"
  ) %>% select(
    componente = `Geral, grupo, subgrupo, item e subitem`, mes = Mês, Valor
  ) %>% 
  mutate(componente = str_remove(componente, "^\\d\\."),
         mes = str_extract(mes, "\\w+")) %>% 
  spread(mes, Valor)

ipca_componentes_ano <- API_SIDRA(
  1419, 315, "7169,7170,7445,7486,7558,7625,7660,7712,7766,7786", 
  periodo = "last", variavel = "69"
  ) %>% select(
  componente = `Geral, grupo, subgrupo, item e subitem`, `No ano` = Valor
  ) %>% 
  mutate(componente = str_remove(componente, "^\\d\\."))

ipca_componentes_12m <- API_SIDRA(
  1419, 315, "7169,7170,7445,7486,7558,7625,7660,7712,7766,7786", 
  periodo = "last", variavel = "2265"
) %>% select(
  componente = `Geral, grupo, subgrupo, item e subitem`, `12 Meses` = Valor
) %>% 
  mutate(componente = str_remove(componente, "^\\d\\."))

# Reproduz a tabela VIII.2
left_join(ipca_componentes_mes, ipca_componentes_ano, "componente") %>% 
  left_join(ipca_componentes_12m, "componente")

