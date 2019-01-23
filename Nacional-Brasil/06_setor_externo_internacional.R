library(rbcb)
library(tidyverse)
library(lubridate)
library(alfred)

#### taxas de juros reais - Libor . Prime, FED Funds rate

#### função de anualizar taxas de juros, precisa de dados
# de origem da série em duas colunas: data e valor



anualizar <- function(serie,anos) {
  txy <- data.frame(matrix(ncol = 2, nrow = 0))
  for (ano in anos) {
    anu <- 1
    itaxa <- serie[ year(serie[,1]) == ano,]
    for (taxa in itaxa[,2]) {
      anu <-  anu * (1+taxa/100)
      }
    anu <- round(100*(anu -1),2)
    nv <- data.frame(ano,anu)
    txy <- rbind(txy, nv)
  
  }
  txy
}

anos <- seq(1995,2017,1)
datast <- c("1995-01-01","2017-12-01")
## FED funds rate
serieifed <- get_fred_series("FEDFUNDS", "Taxa Efetiva dos FED Funds (overnight?)", datast[1],datast[2])

## deflator implícito do PIB - EUA
seriepibdeua <- get_fred_series("A191RI1A225NBEA", "Deflator do PIB EUA", datast[1],datast[2])


## Libor

serieilibordolar <- get_fred_series("USD12MD156N","Libor 12M USD",datast[1],datast[2] )

### a mover depois para parte de política monetária
## taxa de juros Selic real - Brasil

selicbrasil <- get_series("4189",datast[1],datast[2] )
selicbrasilm <- data.frame(selicbrasil$date,100*((1+(selicbrasil$`4189`/100))**(1/12) -1))
colnames(selicbrasilm) <- colnames(selicbrasil)
##deflator implícito do PIB - Brasil
brasilpibd <- get_series("1211",datast[1],datast[2])

## IGP-M - Brasil
brasiligpm <- get_series("189",datast[1],datast[2])

### SELIC DEFLACIONADA PELO DEFLATOR IMPLÍCITO

selicanual <- anualizar( selicbrasilm,anos)

selicreal <- ((1+selicanual$`Taxa de Juros`/100)/(1+brasilpibd$`1211`/100)-1)*100

selicanual <- cbind(selicanual,selicreal,brasilpibd$`1211`)

write.csv2(selicanual, "data/selicreal.csv")


##### Libor


