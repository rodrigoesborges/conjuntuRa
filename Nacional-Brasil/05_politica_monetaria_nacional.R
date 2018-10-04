library(rbcb)
library(tidyverse)

# ----- Base Monetária, Meio de pagamento (M1 a M4) e componentes --------------
meios_pag <- get_series(
  c(emitido = 1786, reservas = 1787, base = 1788,
    poder_publico = 27789, dep_vista = 27790, M1 = 27791,
    dep_poupanca = 1835, tit_privados = 27809, M2 = 27810,
    quotas = 27811, ope_compromisso = 27812, M3 = 27813,
    titulo_fed = 27814, M4 = 27815), last = 13
  )
incluir_indicador <- function(df) {
  df$indicador <- names(df)[2]
  names(df)[2] <- "valor"
  df[ , c(1, 3, 2)]
}

tabela_mp <- map_df(meios_pag, incluir_indicador)

meses <- tabela_mp %>% 
  filter(date %in% sort(unique(date))[c(1, 10:13)]) %>% 
  mutate(date = format(date, "%b %Y")) %>% 
  spread(date, valor)

var_mes <- tabela_mp %>% group_by(indicador) %>% 
  summarise(`No mês` = (valor[13] - valor[12]) * 100 / valor[12])

var_ano <- tabela_mp %>% group_by(indicador) %>% 
  summarise(`No ano` = (last(valor) - first(valor)) * 100 / first(valor))

# Reproduz a tabela XI.1
left_join(meses, var_mes, "indicador") %>% 
  left_join(var_ano, "indicador")


# ----- Taxa Over/SELIC --------------------------------------------------------
selic <- get_series(c(SELIC = 1178), last = 252)

# reproduz o gráfico XI-A
ggplot(selic, aes(date, SELIC)) +
  geom_line(col = "purple4", size = 2) +
  scale_x_date("", date_breaks = "1 month", date_labels = "%b / %Y") +
  scale_y_continuous("", limits = range(selic$SELIC) + c(-0.3, 0.1), 
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
  last = 13
)

tabela_cond <- map_df(condicionantes, incluir_indicador) %>% 
  filter(date %in% sort(unique(date))[c(1, 10:13)]) %>% 
  mutate(date = format(date, "%b %Y")) %>% 
  spread(date, valor)

# Reproduz a tabela XI.2
tabela_cond

# ----- Saldo das Operações de Crédito no Sistema Financeiro -------------------


# ----- Endividamento por setor Institucional ----------------------------------




