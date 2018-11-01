library(microdadosBrasil)
library(readr)
library(readxl)
library(dplyr)

#Específico para projeto de Camilla
CNAE95 <-read_xlsx("~/Nextcloud/Academia/Congressos e Revistas/2019-tese-camila/CNAE 95 _div.xlsx", col_names = TRUE)
#divisões específicas solicitadas por seu projeto - levaram a incluir um loop adicional
# e coluna a mais nos resultados compilados
divisoes <- sprintf("%02d",CNAE95$"Código")
diretoriodoprojeto <- getwd()
setwd("~/RLocalData")

#ideal em seguida: procurar no csv anos que faltem,
#do mais recente para trás, e só atualizar o csv com anos faltantes

anos <- seq(1994,2017,1)
ufs <- c("AC","AL","AM","AP","BA","CE", "DF", "ES", "GO", "MA","MG","MS","MT","PA","PB","PE","PR","RJ","RO","RR","RS","SC","SE","SP","TO")
nomescols <- c("ano","uf","divisao","percentual","vinculos")

proxysuper <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(proxysuper) <-nomescols

for (ano in anos) {
for (uf in ufs) {
  rais <- read_RAIS("vinculos", i = ano, UF = uf)
  for (divisao in divisoes){
  raisocupas <- rais[grep(paste("$",divisao),rais$"CNAE 95 Classe")]
  seden <- nrow(raisocupas)
  if (nrow(raisocupas) == 0) { seden = 1 }
  raissuper <- raisocupas[parse_number(raisocupas$"Vl Remun M\xe9dia (SM)", locale = locale("br", decimal_mark = ",")) < 2]
  senum <- nrow(raissuper)
  superexp <- senum/seden
  novovalor <- data.frame(ano, uf, divisao,superexp,nrow(raisocupas))
  names(novovalor) <- nomescols
  proxysuper <- rbind(proxysuper,novovalor)
}
}
}


setwd(diretoriodoprojeto)
write.csv2(proxysuper,paste0("data/seriesuperexp",anos[1],"- 2017.csv"))



