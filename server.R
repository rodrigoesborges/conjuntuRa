function(input, output, session) {
  observeEvent(input$ir_atividade, {
    shiny::updateTabsetPanel(session, "menu", "atividade")
  })
  
  observeEvent(input$ir_inflacao, {
    shiny::updateTabsetPanel(session, "menu", "inflacao")
  })
  
  observeEvent(input$ir_trabalho, {
    shiny::updateTabsetPanel(session, "menu", "trabalho")
  })
  
  observeEvent(input$ir_fiscal, {
    shiny::updateTabsetPanel(session, "menu", "fiscal")
  })
  
  observeEvent(input$ir_monetaria, {
    shiny::updateTabsetPanel(session, "menu", "monetaria")
  })
  observeEvent(input$ir_externo, {
    shiny::updateTabsetPanel(session, "menu", "externo")
  })
  desibge_ <- reactive({
    desempregoibge %>% 
      filter(between(data, input$periodo[1], input$periodo[2]))
  })
  
  output$graf_desibge <- renderPlotly({
    desibge <- desibge_()
    
    dif_tempo <- diff(range(desibge$data))
    intervalo <- ifelse(dif_tempo < 500, "1 month",
                        ifelse(dif_tempo < 1000, "2 months", "1 year"))
    
    ggplot(desibge, aes(data, valor, col = indicador)) +
      geom_line(size = 1) +
      scale_x_date("", date_breaks = intervalo, date_labels = "%b / %Y") +
      scale_y_continuous("") +
      ggtitle("Taxa de Desemprego IBGE (%)")
    
    ggplotly()
  })
  
  output$tab_desibge <- renderDataTable({
    mutate(desibge_(), date = format(data, "%d/%m/%Y")) %>% 
      spread(indicador, valor)
  }, options = list(pageLength = 10, scrollX = TRUE))
  
  # --
  
  
  mp_ <- reactive({
    meio_pagamento %>% 
      filter(between(date, input$periodo[1], input$periodo[2]))
  })
  
  output$graf_mp <- renderPlotly({
    mp <- mp_()
    
    dif_tempo <- diff(range(mp$date))
    intervalo <- ifelse(dif_tempo < 500, "1 month",
                        ifelse(dif_tempo < 1000, "2 months", "1 year"))
    
    ggplot(mp, aes(date, valor, col = indicador)) +
      geom_line(size = 1) +
      scale_x_date("", date_breaks = intervalo, date_labels = "%b / %Y") +
      scale_y_continuous("") +
      ggtitle("Meios de pagamentos")
    
    ggplotly()
  })
  
  output$tab_mp <- renderDataTable({
    mutate(mp_(), date = format(date, "%d/%m/%Y")) %>% 
      spread(indicador, valor)
  }, options = list(pageLength = 10, scrollX = TRUE))
  
  # --
  
  cond_ <- reactive({
    condicionantes %>% 
      filter(between(date, input$periodo[1], input$periodo[2]))
  })
  
  output$graf_cond <- renderPlotly({
    cond <- cond_()
    
    dif_tempo <- diff(range(cond$date))
    intervalo <- ifelse(dif_tempo < 500, "1 month",
                        ifelse(dif_tempo < 1000, "2 months", "1 year"))
    
    ggplot(cond, aes(date, valor, col = indicador)) +
      geom_line(size = 1) +
      scale_x_date("", date_breaks = intervalo, date_labels = "%b / %Y") +
      scale_y_continuous("") +
      ggtitle("Condicionantes")
    
    ggplotly()
  })
  
  output$tab_cond <- renderDataTable({
    mutate(cond_(), date = format(date, "%d/%m/%Y")) %>% 
      spread(indicador, valor)
  }, options = list(pageLength = 10, scrollX = TRUE))
  
  # --
  
  div_ <- reactive({
    endividamento %>% 
      filter(between(date, input$periodo[1], input$periodo[2]))
  })
  
  output$graf_div <- renderPlotly({
    div <- div_()
    
    dif_tempo <- diff(range(div$date))
    intervalo <- ifelse(dif_tempo < 500, "1 month",
                        ifelse(dif_tempo < 1000, "2 months", "1 year"))
    
    ggplot(div, aes(date, valor, col = indicador)) +
      geom_line(size = 1) +
      scale_x_date("", date_breaks = intervalo, date_labels = "%b / %Y") +
      scale_y_continuous("") +
      ggtitle("Condicionantes")
    
    ggplotly()
  })
  
  output$tab_div <- renderDataTable({
    mutate(div_(), date = format(date, "%d/%m/%Y")) %>% 
      spread(indicador, valor)
  }, options = list(pageLength = 10, scrollX = TRUE))
  
  # --
  
  selic_ <- reactive({
    selic %>% 
      filter(between(date, input$periodo[1], input$periodo[2]))
  })
  
  output$graf_selic <- renderPlotly({
    selic <- selic_()
    
    dif_tempo <- diff(range(selic$date))
    intervalo <- ifelse(dif_tempo < 500, "1 month",
                        ifelse(dif_tempo < 1000, "2 months", "1 year"))
    
    ggplot(selic, aes(date, SELIC)) +
      geom_line(col = "purple4", size = 2) +
      scale_x_date("", date_breaks = intervalo, date_labels = "%b / %Y") +
      scale_y_continuous("", limits = range(selic$SELIC) + c(-0.3, 0.1), 
                         labels = function(x) paste(x, "%") ) +
      ggtitle("Gráfico XI-A: Taxa Over/SELIC (% anualizada)")
    
    ggplotly()
  })
  
  output$tab_selic <- renderDataTable(
    mutate(selic_(), date = format(date, "%d/%m/%Y")),
    options = list(pageLength = 10, scrollX = TRUE)
  )
  
  # --
  
  creditosetorial_ <- reactive({
    creditosetorial %>% 
      filter(between(date, input$periodo[1], input$periodo[2]))
  })
  
  output$graf_creditosetorial <- renderPlotly({
    creditosetorial <- creditosetorial_()
    
    dif_tempo <- diff(range(div$date))
    intervalo <- ifelse(dif_tempo < 500, "1 month",
                        ifelse(dif_tempo < 1000, "2 months", "1 year"))
    
    ggplot(div, aes(date, valor, col = indicador)) +
      geom_line(size = 1) +
      scale_x_date("", date_breaks = intervalo, date_labels = "%b / %Y") +
      scale_y_continuous("") +
      ggtitle("Crédito Setorial")
    
    ggplotly()
  })
  
  output$tab_creditosetorial <- renderDataTable({
    mutate(creditosetorial_(), date = format(date, "%d/%m/%Y")) %>% 
      spread(indicador, valor)
  }, options = list(pageLength = 10, scrollX = TRUE))
  
}