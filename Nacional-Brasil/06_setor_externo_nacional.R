library(rbcb)
library(tidyverse)
library(lubridate)

incluir_indicador <- function(df) {
  df$indicador <- names(df)[2]
  names(df)[2] <- "valor"
  df[ , c(1, 3, 2)]
}

ultimos <- function(x, ids) {
  unicos <- unique(x)
  sort(unicos)[length(unicos) + ids - max(ids)]
}

# ---- Balanço de Pagamentos (BCB) ---------------------------------------------


bp <- get_series( # tudo mensal
  c("Transações Correntes" = 22701, 
    "Balança Comercial (FOB)" = 22707,
    "Exportação de bens" = 22708,
    "Importação de bens" = 22709,
    "Serviços" = 22719,
    "Conta de Capital" = 22851, 
    "Conta Financeira" = 22863,
    "Erros e Omissões" = 23060),
  # floor_date(Sys.Date(), "year") - dyears(1), floor_date(Sys.Date(), "month")
  "2012-01-01", "2013-12-31"
) %>% 
  map_df(incluir_indicador) %>% 
  spread(indicador, valor) %>% 
  mutate(`Resultado do Balanço` = `Transações Correntes` + `Conta de Capital` +
           `Conta Financeira` + `Erros e Omissões`) %>% 
  gather(indicador, valor, -date)

# Reproduz a tabela XII.1
bp %>% 
  group_by(indicador) %>% 
  summarise(
    Dez = first(valor), "Jan-Dez" = sum(valor[1:12]),
    menos3 = valor[n()-3], menos2 = valor[n()- 2], menos1 = valor[n()-1], 
    ultimo = valor[n()], 
    "Acumulado no ano" = sum(valor[(n()- 11):(n())])
  ) %>% 
  magrittr::extract(c(9, 1, 5, 6, 8, 2, 3, 7), 1:8)

# ---- Transações Correntes por Componente (BCB) -------------------------------


# ---- Balança Comercial (BCB) -------------------------------------------------


# ---- Conta Cap. e Financeira por item (BCB) ----------------------------------


# ---- Dívida Externa Bruta (BCB) ----------------------------------------------


# ---- Reservas internacionais (BCB) -------------------------------------------


# ---- Dívida Externa Líquida (BCB) --------------------------------------------


# ---- Posição Internacional de Investimento - Passivo Externo (BCB) -----------