library(shiny)
library(shinyjs)
library(shinydashboard)
library(plotly)

condicionantes <- read_csv("data/condicionantes.csv")
endividamento <- read_csv("data/endividamento.csv")
meio_pagamento <- read_csv("data/meio_pagamento.csv")
selic <- read_csv("data/selic.csv")

theme_set(
  theme_minimal() +
    theme(axis.text.x = element_text(angle = 30, size = 10),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          axis.ticks.x.bottom = element_line())
)

