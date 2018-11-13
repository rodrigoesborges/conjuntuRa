require(microdadosBrasil)
require(data.table)
require(readr)
require(readxl)
require(dplyr)
require(plotly)

anos <- seq(1994,2017,1)
ufs <- c("AC","AL","AM","AP","BA","CE", "DF", "ES", "GO", "MA","MG","MS","MT","PA","PB","PE","PI","PR","RN","RJ","RO","RR","RS","SC","SE","SOP","TO")

nomescols <- c("ano","uf","divisao","percentual","vinculos")

proxysuper <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(proxysuper) <-nomescols

for (ano in anos) {
  for (uf in ufs) {
    rais <- read_RAIS("vinculos", i = ano, UF = uf, root_path = "~/RLocalData/RAIS", vars_subset = c("CNAE 95 Classe","Faixa Remun M\xe9dia (SM)"))
    raisocupas <- rais
    raisocupas$"Faixa Remun M\xe9dia (SM)" <- as.numeric(raisocupas$"Faixa Remun M\xe9dia (SM)")
    seden <- nrow(raisocupas)
    if (nrow(raisocupas) == 0) { seden = 1 }
    raissuper <- raisocupas[ raisocupas$"Faixa Remun M\xe9dia (SM)" <= 3]
    senum <- nrow(raissuper)
    superexp <- senum/seden
    novovalor <- data.frame(ano, uf, divisao,superexp,nrow(raisocupas))
    names(novovalor) <- nomescols
    proxysuper <- rbind(proxysuper,novovalor)
    write.csv2(proxysuper,paste0("data/serie2sm",anos[1],"-",ano,".csv"))
    gc()
  }
}

write.csv2(proxysuper,paste0("data/serie2sm",anos[1],"-",ano,".csv"))

