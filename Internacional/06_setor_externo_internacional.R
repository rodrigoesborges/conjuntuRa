library(rbcb)
library(tidyverse)
library(lubridate)
library(alfred)
library(zoo)

#### taxas de juros reais - Libor . Prime, FED Funds rate

#### função de anualizar taxas de juros, precisa de dados
# de origem da série em duas colunas: data e valor



anualizar <- function(serie,anos) {
  txy <- data.frame(matrix(ncol = 2, nrow = 0))
  for (ano in anos) {
    txjuros <- 1
    itaxa <- serie[ year(serie[,1]) == ano,]
    for (taxa in itaxa[,2]) {
      txjuros <-  txjuros * (1+taxa/100)
      }
    txjuros <- round(100*(txjuros -1),2)
    nv <- data.frame(ano,txjuros)
    txy <- rbind(txy, nv)
  
  }
  txy
}

anos <- seq(1995,2017,1)
datast <- c("1995-01-01","2017-12-31")

## FED funds rate
ifed <- get_fred_series("FEDFUNDS", "Taxa Efetiva dos FED Funds (overnight?)", datast[1],datast[2])
ifedm <- data.frame(libordolar[,1],100*((1+(libordolar[,2]/100))**(1/12) -1))

## prime rate
prime <- get_fred_series("MPRIME", "Prime Rate", datast[1],datast[2])


## deflator implícito do PIB - EUA
pibdeua <- get_fred_series("A191RI1A225NBEA", "Deflator do PIB EUA", datast[1],datast[2])

## Libor em dólares

libordolar <- get_fred_series("USD12MD156N","Libor 12M USD",datast[1],datast[2] )
libordolar <- na.locf(libordolar)
libordiaria <- data.frame(libordolar[,1],100*((1+(libordolar[,2]/100))**(1/252) -1))


### a mover depois para parte de política monetária
## taxa de juros Selic real - Brasil

selicbrasil <- get_series("4189",datast[1],datast[2] )
selicbrasilm <- data.frame(selicbrasil[,2],100*((1+(selicbrasil[,2]/100))**(1/12) -1))
colnames(selicbrasilm) <- colnames(selicbrasil)
##deflator implícito do PIB - Brasil
brasilpibd <- get_series("1211",datast[1],datast[2])

## IGP-M - Brasil
brasiligpm <- get_series("189",datast[1],datast[2])

### SELIC DEFLACIONADA PELO DEFLATOR IMPLÍCITO

selicanual <- anualizar(selicbrasilm,anos)

selicreal <- ((1+selicanual[,2]/100)/(1+brasilpibd[,2]/100)-1)*100

selicanual <- cbind(selicanual,selicreal,brasilpibd[,2])

write.csv2(selicanual, "data/selicreal.csv")


##### Libor

liboranual <- anualizar(libordiaria,anos)

libordolareal <- ((1+liboranual[,2]/100)/(1+pibdeua[,2]/100)-1)*100

liboranual <- cbind(liboranual,libordolareal,pibdeua[,2])

write.csv2(liboranual,"data/liboranual.csv")

##### ifed - fed funds rate

ifedanual <- anualizar(ifedm,anos)

ifedreal <- ((1+ifedanual[,2]/100)/(1+pibdeua[,2]/100)-1)*100

ifedanual <- cbind(ifedanual,ifedreal,pibdeua[,2])

write.csv2(ifedanual,"data/ifedanual.csv")

### prime rate

primeanual <- anualizar(prime,anos)
primereal <- ((1+primeanual[,2]/100/1+pibdeua[,2]/100)-1)*

primeanual <- cbind(primeanual,primereal,pibdeua[,2])  

write.csv2(primeanual,"data/primeanual.csv")
