library(tidyverse)
library(shiny)
library(shinyjs)
library(shinydashboard)
library(plotly)
#Adicionado pacote de temas para shinydashboard
library(dashboardthemes)

condicionantes <- read_csv("data/condicionantes.csv")
endividamento <- read_csv("data/endividamento.csv")
meio_pagamento <- read_csv("data/meio_pagamento.csv")
selic <- read_csv("data/selic.csv")
creditosetorial <- read_csv("data/creditosetorial.csv")
desempregoibge <- read_csv("data/03-01-desemprego-IBGE.csv")

theme_set(
  theme_minimal() +
    theme(axis.text.x = element_text(angle = 30, size = 10),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          axis.ticks.x.bottom = element_line())
)

