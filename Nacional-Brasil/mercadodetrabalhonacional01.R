# indicadores básicos de Mercado de Trabalho - Brasil
# fontes - Dieese e IBGE
# http://www.dieese.org.br/analiseped/mensalTabela/mensalpedmettab02.xls
library('sidrar')
library('ggplot2')
library('tidyverse')

# copiado da analisemacro
tabela = get_sidra(api='/t/6381/n1/all/v/4099/p/all/d/v4099%201')

times = seq(as.Date('2016-01-01'), as.Date('2018-06-01'), 
            by='month')

desemprego = data.frame(time=times, desemprego=tail(tabela$Valor, 20))

ggplot(desemprego, aes(x=time, y=desemprego))+
  geom_line(size=.8, colour='darkblue')+
  scale_x_date(breaks = date_breaks("1 months"),
               labels = date_format("%b/%Y"))+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  geom_point(size=9, shape=21, colour="#1a476f", fill="white")+
  geom_text(aes(label=round(desemprego,1)), size=3, 
            hjust=0.5, vjust=0.5, shape=21, colour="#1a476f")+
  xlab('')+ylab('%')+
  labs(title='Taxa de Desocupação PNAD Contínua',
       subtitle='População desocupada em relação à PEA',
       caption='Fonte: conjuntuRa com dados do IBGE.')