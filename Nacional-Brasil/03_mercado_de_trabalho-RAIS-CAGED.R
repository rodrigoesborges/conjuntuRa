library(microdadosBrasil)
library(readr)
library(readxl)
library(dplyr)

#Específico para projeto de Camilla
CNAE95 <-read_xlsx("~/RLocalData/CNAE 95 _div.xlsx", col_names = TRUE)
#divisões específicas solicitadas por seu projeto - levaram a incluir um loop adicional
# e coluna a mais nos resultados compilados
divisoes <- sprintf("%02d",CNAE95$"Código")


#ideal em seguida: procurar no csv anos que faltem,
#do mais recente para trás, e só atualizar o csv com anos faltantes

anos <- seq(1994,2017,1)
ufs <- c("AC","AL","AM","AP","BA","CE", "DF", "ES", "GO", "MA","MG","MS","MT","PA","PB","PE","PR","RJ","RO","RR","RS","SC","SE","SP","TO")
nomescols <- c("ano","uf","divisao","percentual","vinculos")

proxysuper <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(proxysuper) <-nomescols

for (ano in anos) {
  for (uf in ufs) {
    rais <- read_RAIS("vinculos", i = ano, UF = uf, root_path = "~/RLocalData/")
    rais$"CNAE 95 Classe" <- sprintf("%05d",rais$"CNAE 95 Classe")
    for (divisao in divisoes){
      linhas <- substr(rais$"CNAE 95 Classe",1,2) == divisao
      raisocupas <- rais[linhas,]
      raisocupas$"Vl Remun M\xe9dia (SM)" <- parse_number(raisocupas$"Vl Remun M\xe9dia (SM)", locale = locale("br", decimal_mark = ","))
      seden <- nrow(raisocupas)
      if (nrow(raisocupas) == 0) { seden = 1 }
      raissuper <- raisocupas[ raisocupas$"Vl Remun M\xe9dia (SM)" < 2]
      senum <- nrow(raissuper)
      superexp <- senum/seden
      novovalor <- data.frame(ano, uf, divisao,superexp,nrow(raisocupas))
      names(novovalor) <- nomescols
      proxysuper <- rbind(proxysuper,novovalor)
    }
    write.csv(proxysuper,paste0("seriesuperexp",anos[1],ano,".csv"))
  }
}


setwd(diretoriodoprojeto)
write.csv(proxysuper,paste0("data/seriesuperexp",anos[1],"- 2017.csv"))



