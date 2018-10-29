library(microdadosBrasil)
library(readr)
setwd("~/RLocalData")

anos <- seq(2008,2017,1)
ufs <- c("AC","AL","AM","AP","BA","CE", "DF", "ES", "GO", "MA","MG","MS","MT","PA","PB","PE","PR","RJ","RO","RR","RS","SC","SE","SP","TO")
nomescols <- c("ano","uf","percentual","vinculos")

proxysuper <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(proxysuper) <-nomescols

for (ano in anos) {
for (uf in ufs) {
  rais <- read_RAIS("vinculos", i = ano, UF = uf)
  if (ano < 2015) { 
    raisocupas <- rais[rais$"CNAE 95 Classe" < 36994]
  }
    else {
      raisocupas <- rais[rais$"CNAE 2.0 Subclasse" < 3299099]
  }
  seden <- nrow(raisocupas)
  if (nrow(raisocupas) == 0) { seden = 1 }
  raissuper <- raisocupas[parse_number(raisocupas$"Vl Remun M\xe9dia (SM)", locale = locale("br", decimal_mark = ",")) < 2]
  senum <- nrow(raissuper)
  superexp <- senum/seden
  novovalor <- data.frame(ano, uf, superexp,nrow(raisocupas))
  names(novovalor) <- nomescols
  proxysuper <- rbind(proxysuper,novovalor)
}
}

write.csv2(proxysuper,"seriesuperexp.csv")



