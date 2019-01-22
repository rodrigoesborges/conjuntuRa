library(rbcb)
library(tidyverse)
library(lubridate)
library(alfred)
#### taxas de juros reais - Libor . Prime, FED Funds rate

datast <- c("1995-01-01","2017-01-01")
## FED funds rate
serieifed <- get_fred_series("FEDFUNDS", datast[1],datast[2])

seriepibdeua <- get_fred_series("A191RI1A225NBEA", "Deflator do PIB EUA", datast[1],datast[2])


## Libor

serieilibordolar <- get_fred_series("USD12MD156N","Libor 12M USD",datast[1],datast[2] )

### a mover depois para parte de política monetária
# taxa de juros Selic real - Brasil