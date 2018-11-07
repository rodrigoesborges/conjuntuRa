library(microdadosBrasil)
library(readr)
library(readxl)
library(dplyr)

#Específico para projeto de Camilla
CNAE95 <-read_xlsx("~/RLocalData/CNAE 95 _div.xlsx", col_names = TRUE)
#divisões específicas solicitadas por seu projeto - levaram a incluir um loop adicional
# e coluna a mais nos resultados compilados
divisoes <- sprintf("%02d",CNAE95$"Código")


anos <- seq(1994,2017,1)
ufs <- c("AC","AL","AM","AP","BA","CE", "DF", "ES", "GO", "MA","MG","MS","MT","PA","PB","PE","PI","PR","RN","RJ","RO","RR","RS","SC","SE","SP","TO")

nomescols <- c("ano","uf","divisao","percentual","vinculos")

proxysuper <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(proxysuper) <-nomescols

for (ano in anos) {
  for (uf in ufs) {
    rais <- read_RAIS("vinculos", i = ano, UF = uf, root_path = "~/RLocalData/", vars_subset = c("CNAE 95 Classe","Faixa Remun M\xe9dia (SM)"))
    rais$"CNAE 95 Classe" <- sprintf("%05d",parse_number(rais$"CNAE 95 Classe"))
    for (divisao in divisoes){
      linhas <- substr(rais$"CNAE 95 Classe",1,2) == divisao
      raisocupas <- rais[linhas,]
      raisocupas$"Faixa Remun M\xe9dia (SM)" <- as.numeric(raisocupas$"Faixa Remun M\xe9dia (SM)")
      seden <- nrow(raisocupas)
      if (nrow(raisocupas) == 0) { seden = 1 }
      raissuper <- raisocupas[ raisocupas$"Faixa Remun M\xe9dia (SM)" <= 3]
      senum <- nrow(raissuper)
      superexp <- senum/seden
      novovalor <- data.frame(ano, uf, divisao,superexp,nrow(raisocupas))
      names(novovalor) <- nomescols
      proxysuper <- rbind(proxysuper,novovalor)
    }
    write.csv2(proxysuper,paste0("data/seriesuperexp",anos[1],"-",ano,".csv"))
    gc()
  }
}


write.csv2(proxysuper,paste0("data/seriesuperexp",anos[1],"-",ano,".csv"))

