library(rbcb)
library(tidyverse)

incluir_indicador <- function(df) {
  df$indicador <- names(df)[2]
  names(df)[2] <- "valor"
  df[ , c(1, 3, 2)]
}

ultimos <- function(x, ids) {
  unicos <- unique(x)
  sort(unicos)[length(unicos) + ids - max(ids)]
}

# ----- Base Monetária, Meio de pagamento (M1 a M4) e componentes --------------
meios_pag <- get_series(
  c("Papel Moeda Emitido" = 1786, "Reservas Bancárias" = 1787, 
    "Base Monetária" = 1788, "Moeda em Poder do Público" = 27789, 
    "Depósitos à Vista" = 27790, "M1" = 27791,
    "Depósitos de poupança" = 1835, "Títulos privados" = 27809, "M2" = 27810,
    "Quotas dos fundos de renda fixa" = 27811,
    "Op. Compromisso c/ tit. Fed." = 27812, "M3" = 27813,
    "Título Fed. (SELIC)" = 27814, M4 = 27815),
  "1994-01-01"
  ) %>% 
  map_df(incluir_indicador)

write_csv(meios_pag, "data/meio_pagamento.csv")

meses <- meios_pag %>% 
  filter(date %in% ultimos(date, c(1, 10:13))) %>% 
  mutate(date = format(date, "%b %Y")) %>% 
  spread(date, valor)

var_mes <- meios_pag %>% 
  group_by(indicador) %>% 
  summarise(`No mês` = (valor[13] - valor[12]) * 100 / valor[12])

var_ano <- meios_pag %>% 
  group_by(indicador) %>% 
  summarise(`No ano` = (last(valor) - first(valor)) * 100 / first(valor))

# Reproduz a tabela XI.1
left_join(meses, var_mes, "indicador") %>% 
  left_join(var_ano, "indicador")

# ----- Taxa Over/SELIC --------------------------------------------------------
selic <- get_series(c(SELIC = 1178), start_date = "1999-01-01")

write_csv(selic, "data/selic.csv")

# reproduz o gráfico XI-A
selic2 <- filter(selic, date %in% ultimos(date, 1:252))
ggplot(selic2, aes(date, SELIC)) +
  geom_line(col = "purple4", size = 2) +
  scale_x_date("", date_breaks = "1 month", date_labels = "%b / %Y") +
  scale_y_continuous("", limits = range(selic2$SELIC) + c(-0.3, 0.1), 
                     labels = function(x) paste(x, "%") ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, size = 10),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.ticks.x.bottom = element_line()) +
  ggtitle("Gráfico XI-A: Taxa Over/SELIC (% anualizada)")

# ----- Condicionantes da Base Monetária ---------------------------------------
condicionantes <- get_series(
  c("Tesouro Nacional" = 1810, "Tít. púb. fed. - TN" = 7529,
    "Setor externo" = 1811, "Dep. de instituições financeiras" = 1815,
    "Tít. púb. fed. - BC" = 7528,
    "Redesconto" = 12484, "Derivativos" = 12487,
    "Outras contas" = 7537, "Variação da base ampliada" = 7541),
  "1994-01-01"
) %>% map_df(incluir_indicador) 

write_csv(condicionantes, "data/condicionantes.csv")

# Reproduz a tabela XI.2
condicionantes %>% 
  filter(date %in% ultimos(date, c(1, 10:13))) %>% 
  mutate(date = format(date, "%b %Y")) %>% 
  spread(date, valor)

# ----- Saldo das Operações de Crédito no Sistema Financeiro -------------------
creditosetorial <- get_series (
  c("Agropecuária" = 22027, "Indústria Extrativa" = 22028,
    "Indústria de Transformação" = 22029, "Indústria de construção" = 22030,
    "Serv. Ind. de Util. Púb." = 22034, "Comércio" = 22036, 
    "Transportes" = 22037, "Administração Pública" = 22039,
    "Outros serviços" = 22041, 
    "Outros" = 22042,
    "Indústria total" = 22043,
    "Serviços total" = 22044,
    "Ind. Química e farmacêutica" = 27722,
    "Ind. Bens de Capital" = 27723,
    "Ind. automobilística" = 27724,
    "Ind. de obras de infraestrutura" = 27725,
    "Ind. outros bens de cons. duráveis" = 27726,
    "Ind. de embalagens" = 27727,
    "Ind. bens de consumo não duráveis" = 27728,
    "Via terrestre - carga e passageiro" = 27729,
    "Aquaviário e aéreo" = 27730,
    "Dutoviário" = 27731,
    "Varejo - não duráveis" = 27732,
    "Varejo - duráveis" = 27734,
    "Com. Geral - veículos automotores" = 27735,
    "Com. Geral - bens intermediários" = 27736,
    "Com. Geral - bens de capital" = 27737,
    "Serviços imobiliários" = 27738,
    "Serv. Informação e Comunicação" = 27739,
    "Demais serviços às famílias" = 27740,
    "Demais serviços às empresas" = 27741,
    "Serviços financeiros" = 27742,
    "Ind. de Alimentos" = 27743,
    "Ind. de açúcar" = 27744,
    "Ind. têxtil, vestuário, couro e calçados" = 27745,
    "Ind. de papel e celulose" = 27746,
    "Ind. de petróleo, gás e álcool" = 27747,
    "Ind. de metalurgia e siderurgia" = 27748,
    "Ind. de mineração" = 27749), 
  "2012-01-01"
) %>% map_df(incluir_indicador) 

write_csv(creditosetorial, "data/creditosetorial.csv")

# Reproduz a tabela XI.3
creditosetorial %>% 
  filter(date %in% ultimos(date, c(1, 10:13))) %>% 
  mutate(date = format(date, "%b %Y")) %>% 
  spread(date, valor)


# ----- Endividamento por setor Institucional ----------------------------------
endividamento <- get_series(
  c("Ao Setor Público" = 17466, "Ao Setor Privado" = 17473,
    "Ao Setor Privado Industrial" = 17467, "Ao Setor de Habitação" = 21245,
    "Ao Setor rural" = 17469, "Ao Setor Comercial" = 17470, 
    "Pessoas Físicas" = 17471, "Crédito Total do Sist. Financeiro" = 20622,
    "Créd. do Sist. Fin. Privado Nacional" = 21301, 
    "Créd. do Sist. Fin. Estrangeiro" = 21302), 
  "1994-01-01"
) %>% map_df(incluir_indicador) 

write_csv(endividamento, "data/endividamento.csv")

# Reproduz a tabela XI.4
endividamento %>% 
  filter(date %in% ultimos(date, c(1, 4, 13:16))) %>% 
  mutate(date = format(date, "%b %Y")) %>% 
  spread(date, valor)

