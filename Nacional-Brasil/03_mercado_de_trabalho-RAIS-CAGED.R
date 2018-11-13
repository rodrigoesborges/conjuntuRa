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

#DESAGREGAR POR SETORES
#Específico para projeto de Camilla
#CNAE95 <-read_xlsx("~/RLocalData/CNAE 95 _div.xlsx", col_names = TRUE)
#divisões específicas solicitadas por seu projeto - levaram a incluir um loop adicional
# e coluna a mais nos resultados compilados
#divisoes <- sprintf("%02d",CNAE95$"Código")

# for (ano in anos) {
#   for (uf in ufs) {
#     rais <- read_RAIS("vinculos", i = ano, UF = uf, root_path = "~/RLocalData/", vars_subset = c("CNAE 95 Classe","Faixa Remun M\xe9dia (SM)"))
#     rais$"CNAE 95 Classe" <- sprintf("%05d",parse_number(rais$"CNAE 95 Classe"))
#     for (divisao in divisoes){
#       linhas <- substr(rais$"CNAE 95 Classe",1,2) == divisao
#       raisocupas <- rais[linhas,]
#       raisocupas$"Faixa Remun M\xe9dia (SM)" <- as.numeric(raisocupas$"Faixa Remun M\xe9dia (SM)")
#       seden <- nrow(raisocupas)
#       if (nrow(raisocupas) == 0) { seden = 1 }
#       raissuper <- raisocupas[ raisocupas$"Faixa Remun M\xe9dia (SM)" <= 3]
#       senum <- nrow(raissuper)
#       superexp <- senum/seden
#       novovalor <- data.frame(ano, uf, divisao,superexp,nrow(raisocupas))
#       names(novovalor) <- nomescols
#       proxysuper <- rbind(proxysuper,novovalor)
#     }
#     write.csv2(proxysuper,paste0("data/seriesuperexp",anos[1],"-",ano,".csv"))
#     gc()
#   }
# }

#############ROTATIVIDADE

rotatproxy <- data.frame(matrix(ncol = 5, nrow = 0))

for (ano in anos) {
  for (uf in ufs) {
    rais <- read_RAIS("vinculos", i = ano, UF = uf, root_path = "~/RLocalData/RAIS", vars_subset = c("M\xeas Desligamento","Tempo Emprego"))
    names(rais) <- c("desligadoem","tempo_emprego")
    rais$tempo_emprego <- as.numeric(gsub(",",".",rais$tempo_emprego))
    vtotais <- nrow(rais)
    rodaram <- rais[rais$desligadoem > 0]
    numrod <- nrow(rodaram)
    rodano <- nrow(rodaram[rodaram$tempo_emprego < 12])
    novovalor <- data.frame(ano, uf, rodano,numrod,vtotais)
    names(novovalor) <- c("ano","uf","desligateum","desligados","vinculostotais")
    rotatproxy <- rbind(rotatproxy,novovalor)
  }
  write.csv2(rotatproxy,paste0("data/rotatividade",anos[1],"-",ano,".csv"))
  gc()
}

rotatproxysum <- rotatproxy %>% 
  group_by (ano) %>%
  summarise(desligateum = sum(desligateum)*100/sum(desligados),desligados = sum(desligados)*100/sum(vinculostotais), vinculostotais = sum(vinculostotais))

rotatproxysum$ano <- as.Date(paste(rotatproxysum$ano,"1231"),"%Y%m%d") 

######tentativa de gráfico com plotly

ay <- list(
  tickfont = list(color = "tomato4"),
  overlaying = "y",
  side = "right",
  title = "(%)"
)

graficorotatividade <- plot_ly() %>%
  add_lines(x = rotatproxysum$ano, y = rotatproxysum$desligados, name = "Desligamentos/Total Vínculos", color = "tomato" ) %>%
  add_lines(x = rotatproxysum$ano, y = rotatproxysum$desligateum, name = "Desligamentos até 1 ano (% Desl.)", yaxis = "y2", color = "tomato4") %>%
  layout(
   # title = "Indicadores de Rotatividade\n Mercado Formal de Trabalho\nBrasil - 1994 a 2017 (%)",
    yaxis = list(title = "(%)"),
    yaxis2 = ay,
    xaxis = list(title="Ano")
  )

###########CAGED

cagedanos <- paste0("2018","-",sprintf("%02d",seq(1,09,1)),"m")

for (anocg in cagedanos) {
download_sourceData("CAGED", i = anocg, replace = T, root_path = "~/RLocalData/CAGED/")
}
# download.file("https://raw.githubusercontent.com/guilhermejacob/guilhermejacob.github.io/master/scripts/mtps.R", "Nacional-Brasil/mtps.R")

cagedb <- datavault_mtps(catalog)

###DIEESE
###https://www.dieese.org.br/canal/autenticaUsuario.do?login=internet&senha=gujeihee&sistema=xserve3
