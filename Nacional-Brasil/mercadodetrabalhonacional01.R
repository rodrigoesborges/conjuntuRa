library(dplyr)
library(RSIDRA)
library(ggplot2)
library(scales)
library(dynlm)
library(tidyverse)

#idioma portugues
Sys.setlocale(category = "LC_TIME", locale = "pt_BR.UTF-8")

#coleta tabela da PNAD Contínua, variáveis Taxa de desocupação e subutilização - trim 4118
desemprego <- API_SIDRA(6381,variavel = "4099" )

#transforma data para formato data com lubridate
desemprego$data <- lubridate::as_date(paste(desemprego$`Trimestre Móvel (Código)`,"01"),"%Y%m%d")

desemprego <- select(desemprego, data, Variável, Valor)
colnames(desemprego) <- c("data","indicador","valor")
desemprego$indicador <- gsub("^Taxa composta .*$","Taxa de subutilização",desemprego$indicador)
desemprego$indicador <- gsub("^Taxa de d.*$","Taxa de desocupação",desemprego$indicador)

#plota em um gráfico básico com bolas, 
# adaptado de https://analisemacro.com.br/economia/dados-macroeconomicos/baixando-dados-do-sidra-com-o-r-o-pacote-sidrar/

ggplot(desemprego, aes(x = data, y = valor, color = indicador))+
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

