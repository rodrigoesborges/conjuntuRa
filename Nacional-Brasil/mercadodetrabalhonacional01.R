library(dplyr)
library(RSIDRA)
library(ggplot2)
library(scales)
library(dynlm)
library(tidyverse)
library(zoo)
library(tempdisagg)

#idioma portugues
Sys.setlocale(category = "LC_TIME", locale = "pt_BR.UTF-8")

#coleta tabela da PNAD Contínua, variáveis Taxa de desocupação e subutilização - trim 4118
desemprego <- API_SIDRA(6381,variavel = "4099" )

#transforma data para formato data com lubridate
desemprego$data <- as.Date(paste(desemprego$`Trimestre Móvel (Código)`,"01"),"%Y%m%d")

desemprego <- select(desemprego, data, Variável, Valor)
colnames(desemprego) <- c("data","indicador","desocupacao")
desemprego$indicador <- gsub("^Taxa de d.*$","Taxa de desocupação",desemprego$indicador)

desempregots <- ts(desemprego$desocupacao, start = c(2012,03), frequency = 12)

#baixa estimativas de desemprego total, ou taxa composta de subutilização, e desagrega mês a mês
subutilizacao <- API_SIDRA(4099, variavel = "4118")
subutilizacao$data <- as.Date(as.yearqtr(subutilizacao$Trimestre, format = "%qº trimestre %Y"))
subutilizacao <- select(subutilizacao, data, Variável, Valor)
subutilizacao$Variável <- gsub("^Taxa composta .*$","Taxa de subutilização",subutilizacao$Variável)
colnames(subutilizacao) <- c("data","indicador","subutilizacao")



submensal <- predict(td(subutilizacao$subutilizacao ~ 1, method = "denton-cholette", conversion = "average", to = 3))

subutilizacaom <- ts(submensal,start = c(2012,01), freq = 12)

desempregos <- ts.intersect(desempregots,subutilizacaom)
desempregos <- data.frame(valores = (as.matrix(desempregos)), data = as.Date(time(desempregos)))


#plota em um gráfico básico com bolas, 
# adaptado de https://analisemacro.com.br/economia/dados-macroeconomicos/baixando-dados-do-sidra-com-o-r-o-pacote-sidrar/

ggplot(desempregos, aes(x = data, y = valor, color = indicador))+
  theme_classic()+
  geom_line(mapping = aes(x = data, y = valor, color = indicador))+
  scale_fill_discrete (name="indicador")+
  scale_x_date(breaks = date_breaks("1 months"),
               labels = date_format("%b/%Y"))+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  geom_point(size=9, shape=21, colour="#1a476f", fill="white")+
  geom_text(aes(label=round(valor,1)), size=3, 
            hjust=0.5, vjust=0.5, shape=21, colour="#1a476f")+
  xlab('')+ylab('%')+
  labs(title='Taxa de Desocupação PNAD Contínua',
       subtitle='População desocupada em relação à PEA',
       caption='Fonte: conjuntuRa com dados do IBGE via pacote RSIDRA.')

