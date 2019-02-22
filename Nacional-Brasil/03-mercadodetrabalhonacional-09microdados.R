library('microdadosBrasil')
library('Rilostat')
  #download_sourceData("RAIS", 2017) possivel com fork rodrigoesborges/microdadosBrasil
#necessários praticamente 24gb de RAm para esta etapa, não possivel juntar todo o ano, 
# portanto, salvo em condicoes de trabalho especiais

##PNAD
## DESCOMPACTADO MANUALMENTE, ESPECIFICADO ARQUIVO
PNAD2004 <- read_PNAD(
  'domicilios', i = "2004", 
  root_path = "~/RLocalData/PNAD")

unzip("~/RLocalData/PNAD/2014/Dicionarios_e_input_20170323.zip", unzip = "7z")

download_sourceData("PNAD","2004",
"F","~/RLocalData/PNAD")

dadosilohoras <- Rilostat::get_ilostat(
  id = "EES_3548_NOC_RT_A",
  lang = "es",
  filters = list(ref_area = "BRA"),
  detail = 'dataonly'
)

dadosilohorasm <- Rilostat::get_ilostat(
  id = "EES_TG48_NOC_RT_A",
  lang = "es",
  filters = list(ref_area = "BRA"),
  detail = 'dataonly'
)

horasmuitas <-  data.frame(dadosilohoras$time,dadosilohoras$obs_value+dadosilohorasm$obs_value)
# para saber os nomes dos indicadores
# dadosilo <- get_ilostat_toc(
#   segment = "indicator",
#   lang = "en",
#   search = "hours.*",
#   fixed = "FALSE"
# )

write.csv2(horasmuitas,"data/horasmaisque35.csv")

pnadhoras <- read.csv2("data/pnadhorastrabalhadas.csv")
