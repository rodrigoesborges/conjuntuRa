library(scales)
library(RSIDRA)
library(tidyverse)
library(zoo)
library(dynlm)
library(tempdisagg)

# coleta tabela da PNAD Contínua, variáveis Taxa de desocupação e subutilização - trim 4118
desemprego <- API_SIDRA(6381, variavel = "4099") %>% 
  transmute(data = as.Date(paste(`Trimestre Móvel (Código)`,"01"),"%Y%m%d"),
            indicador = "Taxa de desocupação",
            valor = Valor) %>% 
  as_data_frame()

write.csv(desemprego,"data/03-01-desemprego-IBGE.csv")

# baixa estimativas de desemprego total, ou taxa composta de subutilização, e desagrega mês a mês
tab4099 <- API_SIDRA(4099, variavel = "4118") %>% 
  transmute(data = as.Date(as.yearqtr(Trimestre, format = "%qº trimestre %Y")),
            valor = Valor)

subutilizacao <- tibble(
  valor = predict(td(tab4099$valor ~ 1, "average", 3, "denton-cholette")),
  indicador = "Taxa de subutilização"
) %>% 
  mutate(data = seq(min(tab4099$data), along.with = valor, by = "1 month"))

write.csv(subutilizacao,"data/03-02-subutilizacao.csv")
dados <- bind_rows(subutilizacao, desemprego)


# plota em um gráfico básico com bolas, 
# adaptado de https://analisemacro.com.br/economia/dados-macroeconomicos/baixando-dados-do-sidra-com-o-r-o-pacote-sidrar/

ggplot(dados, aes(data, valor, color = indicador))+
  theme_classic()+
  geom_line(size = 1) +
  geom_point(size = 9, shape = 21,fill = "white") +
  geom_text(aes(label = round(valor, 1)), size = 3, color = "#1a476f",
            hjust = 0.5, vjust = 0.5) +
  scale_fill_discrete (name="indicador")+
  scale_x_date(breaks = date_breaks("1 months"),
               labels = date_format("%b/%Y")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "", y = "%", title='Taxa de Desocupação PNAD Contínua',
       subtitle='População desocupada em relação à PEA',
       caption='Fonte: conjuntuRa com dados do IBGE via pacote RSIDRA.')

