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

pnad2001 <- read_rds("~/RLocalData/PNAD/2001 main.rds")

# library(lodown)
# # examine all available PNAD microdata files
# pnad_cat <-
#   get_catalog( "pnad" ,
#                output_dir = file.path( path.expand( "~" ) , "PNAD" ) )
# 
# # 2011 only
# pnad_cat <- subset( pnad_cat , year == 2011 )
# # download the microdata to your local computer
# pnad_cat <- lodown( "pnad" , pnad_cat )





####teste leitura

# dirbase <- "~/RLocalData/PNAD"
# anoteste <- 1976
# download_sourceData("PNAD",anoteste, root_path = dirbase, unzip = T)
# 
# teste <- read_PNAD("pessoas", root_path = dirbase, anoteste)
#                    

#for (ano in anos) {
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
#}

#write.csv2(proxysuper,paste0("data/serie2smPNAD",anos[1],"-",ano,".csv"))

###########PNAD CONTINUA COM microdadosbrasil

### se não houver sido baixado localmente
microdadosBrasil::get_available_datasets(
  
)
download_sourceData("PnadContinua","2017-1q",root_path = "~/RLocalData/PNADc/")
