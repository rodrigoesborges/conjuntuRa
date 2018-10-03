library(RSIDRA)
library(tidyverse)

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

