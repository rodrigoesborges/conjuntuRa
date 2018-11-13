require(microdadosBrasil)
require(data.table)
require(readr)
require(readxl)
require(dplyr)
require(plotly)

anos <- seq(1995,2015,1)
sempnad <- c(2000,2001,2009,2010)

for (s in sempnad) {
anos <- anos[anos != s]
}


nomescols <- c("ano","uf","divisao","percentual","vinculos")

proxysuper <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(proxysuper) <-nomescols

teste <- read_PNAD("pessoas", i = 1995, root_path = "~/RLocalData/PNAD/1995/DADOS
                   ")

for (ano in anos) {
    #pnad <- read_PNAD("pessoas", i = ano, root_path = "~/RLocalData/PNAD"))
    # pnadocupas <- pnad
    # pnadocupas$"Faixa Remun M\xe9dia (SM)" <- as.numeric(pnadocupas$"Faixa Remun M\xe9dia (SM)")
    # seden <- nrow(pnadocupas)
    # if (nrow(pnadocupas) == 0) { seden = 1 }
    # pnadsuper <- pnadocupas[ pnadocupas$"Faixa Remun M\xe9dia (SM)" <= 3]
    # senum <- nrow(pnadsuper)
    # superexp <- senum/seden
    # novovalor <- data.frame(ano, uf, divisao,superexp,nrow(pnadocupas))
    # names(novovalor) <- nomescols
    # proxysuper <- rbind(proxysuper,novovalor)
    # write.csv2(proxysuper,paste0("data/serie2sm",anos[1],"-",ano,".csv"))
    # gc()
}

write.csv2(proxysuper,paste0("data/serie2smPNAD",anos[1],"-",ano,".csv"))

