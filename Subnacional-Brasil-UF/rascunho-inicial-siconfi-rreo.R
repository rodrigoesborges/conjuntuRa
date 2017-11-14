---
title: "resultadoprimarioUFS"
author: "Rodrigo Borges & Tomás Barcellos"
date: "13 de novembro de 2017"
output: html_document
---
# SICONFI:
#   https://siconfi.tesouro.gov.br/siconfi/pages/public/consulta_finbra_rreo/finbra_rreo_list.jsf
#   Exercício: último
#   Periodicidade: bimestral
#   Período: último
#   Escopo: Estados/DF
#   Anexo: Anexo 06
#
#   Tabela:
#   1. Receitas
#   2. Despesas
#
#   Captcha
#
#   Consultar

## baixar e processar tabelas de resultado primário para todas as UFs
## fonte de dados - SICONFI

library(RSelenium)
chrome <- RSelenium::rsDriver(browser = 'chrome')
chrome

url <- 'https://siconfi.tesouro.gov.br/siconfi/pages/public/consulta_finbra_rreo/finbra_rreo_list.jsf'

remDr <- chrome[['client']]
remDr$navigate(url)
remDr$screenshot(file = tf <- tempfile(fileext = ".png"))

input_exercicio <- remDr$findElement(using = 'id', value = "formFinbra:exercicio_focus")
input_exercicio$sendKeysToElement(list(key = 'down_arrow', key = 'down_arrow', key = 'down_arrow'))

input_periodicidade <- remDr$findElement(using = 'id', value = "formFinbra:periodicidade_focus")
input_periodicidade$sendKeysToElement(list(key = 'down_arrow', key = 'down_arrow', key = 'down_arrow'))

input_periodo <- remDr$findElement(using = 'id', value = "formFinbra:periodo_focus")
input_periodo$sendKeysToElement(list(key = 'down_arrow', key = 'down_arrow', key = 'down_arrow', key = 'down_arrow'))

input_escopo <- remDr$findElement(using = 'id', value = "formFinbra:escopo_focus")
input_escopo$sendKeysToElement(list(key = 'down_arrow')) 
                                     
                                     
#input_poderSelect <- remDr$findElement(using = 'id', value = "formFinbra:poderSelect_focus")

#

input_anexo <- remDr$findElement(using = 'id', value = "formFinbra:anexo_focus")
input_anexo$sendKeysToElement(list(key = 'down_arrow', key = 'down_arrow', key = 'down_arrow', key = 'down_arrow', key = 'down_arrow', key = 'down_arrow'))

input_tabela <- remDr$findElement(using = 'id', value = "formFinbra:tabela_focus")
#Seleciona Receitas Primária
input_tabela$sendKeysToElement(list(key = 'down_arrow')) 


captcha <- remDr$findElement(using = 'id', value = "formFinbra:captcha:captchaImage")

