library(RSIDRA)
library(tidyverse)

# ----- PIB --------------------------------------------------------------------

nomes_variaveis <- function(x) {
  switch (as.character(x), 
          "6564" = "Em relação ao trimestre anterior",
          "6563" = "Em relação ao ano anterior",
          "6561" = "Acumulado no ano",
          NA_character_
          
  )
}

nomes_setores <- function(x) {
  switch (as.character(x),
          "90707" = "PIB a preços de mercado",
          "90687" = "AGROPEC",
          "90691" = "INDUS",
          "90696" = "SERV",
          "93406" = "FBCF",
          "93404" = "CONS. FAM",
          "93405" = "CONS. GOV",
          "93407" = "EXPORT",
          "93408" = "IMPORT",
          NA_character_
  )
}

pib_variacao <- API_SIDRA(
  5932, 11255, periodo = "last", variavel = c("6564,6563,6561"),
  cod_cat = "90707,90687,90691,90696,93406,93404,93405,93407,93408"
  ) %>% 
  as_data_frame() %>% 
  select(periodo = 3, setor = 7, valor = 11) %>% 
  mutate(periodo = purrr::map_chr(periodo, nomes_variaveis),
         setor = purrr::map_chr(setor, nomes_setores)) %>% 
  spread(setor, valor) %>% 
  select(`Período de Comparação` = periodo, `PIB a preços de mercado`, AGROPEC, 
         INDUS, SERV, FBCF, `CONS. FAM`, `CONS. GOV`, EXPORT, IMPORT)

pib_corrente <- API_SIDRA(
  1846, 11255, periodo = "last", variavel = 585,
  cod_cat = "90707,90687,90691,90696,93406,93404,93405,93407,93408"
) %>% 
  as_data_frame() %>% 
  select(periodo = 4, setor = 7, valor = 11) %>% 
  mutate(setor = purrr::map_chr(setor, nomes_setores)) %>% 
  spread(setor, valor) %>% 
  select(`Período de Comparação` = periodo, `PIB a preços de mercado`, AGROPEC,
         INDUS, SERV, FBCF, `CONS. FAM`, `CONS. GOV`, EXPORT, IMPORT)

# Reproduz tabela VII.1 do boletim nº 11 UFMS/UEMS
bind_rows(pib_variacao, pib_corrente)

# ----- Produção Industrial ----------------------------------------------------
pi_setores_mes <- API_SIDRA(
  3653, 544, "129314,129315,129316,129337,129338,129340", variavel = "3139", 
  periodo = "last4") %>% 
  select(categoria = `Seções e atividades industriais (CNAE 2.0)`, 
         mes = Mês, Valor) %>% 
  mutate(categoria = str_remove(categoria, "^\\d+(\\.\\d+)? "),
         mes = str_extract(mes, "\\w+")) %>% 
  spread(mes, Valor)

pi_setores_ano <- API_SIDRA(
  3653, 544, "129314,129315,129316,129337,129338,129340", variavel = "3140", 
  periodo = "last") %>% 
  select(categoria = `Seções e atividades industriais (CNAE 2.0)`, 
         `No Ano` = Valor) %>% 
  mutate(categoria = str_remove(categoria, "^\\d+(\\.\\d+)? "))

pi_setores <- left_join(pi_setores_mes, pi_setores_ano, "categoria")

pi_categorias_mes <- API_SIDRA(
  3651, 543, "129278,129283,129300,129301,129305", variavel = "3139", 
  periodo = "last4") %>% 
  select(categoria = `Grandes categorias econômicas`, mes = Mês, Valor) %>% 
  mutate(categoria = str_remove(categoria, "^\\d+ "),
         mes = str_extract(mes, "\\w+")) %>% 
  spread(mes, Valor)
pi_categorias_ano <- API_SIDRA(
  3651, 543, "129278,129283,129300,129301,129305", variavel = "3140", 
  periodo = "last") %>% 
  select(categoria = `Grandes categorias econômicas`, `No Ano` = Valor) %>% 
  mutate(categoria = str_remove(categoria, "^\\d+ "))

pi_categorias <- left_join(pi_categorias_mes, pi_categorias_ano, "categoria")

# Reproduz tabela VII.2 do boletim nº 11 UFMS/UEMS
bind_rows(pi_setores, pi_categorias)

