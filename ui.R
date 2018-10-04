dashboardPage(
  dashboardHeader(title = "Conjuntura"),
  dashboardSidebar(
    sidebarMenu(id = "menu",
      menuItem("Início", tabName = "inicio"),
      menuItem("Nível de atividade", tabName = "atividade"),
      menuItem("Inflação", tabName = "inflacao"),
      menuItem("Mercado de trabalho", tabName = "trabalho"),
      menuItem("Política fiscal", tabName = "fiscal"),
      menuItem("Política monetária", tabName = "monetaria"),
      hr(),
      dateRangeInput("periodo", "Período da análise", Sys.Date() - 380, 
                     min = "1994-01-1", format = "dd/mm/yyyy", separator = " até ")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        "inicio", 
        box(
          h1("Painel de conjuntura"),
          p("Bem-vind@ ao painel de conjuntura."),
          br(), 
          p("Este projeto visa dar acesso fácil a dados conjunturais atualizados"),
          div(
            actionButton("ir_atividade", "Atividade econômica"),
            actionButton("ir_inflacao", "Inflação"),
            actionButton("ir_trabalho", "Mercado de trabalho"),
            actionButton("ir_fiscal", "Política fiscal"),
            actionButton("ir_monetaria", "Política monetária")
          ),
          width = 12
        )
        
      ),
      tabItem(
        "atividade"
        ),
      tabItem(
        "inflacao"
      ),
      tabItem(
        "trabalho"
      ),
      tabItem(
        "fiscal"
      ),
      tabItem(
        "monetaria", 
        tabBox(
          tabPanel("Gráfico", plotlyOutput("graf_mp")),
          tabPanel("Tabela", dataTableOutput("tab_mp")), 
          title = "Meios de Pagamentos"
        ),
        tabBox(
          tabPanel("Gráfico", plotlyOutput("graf_div")),
          tabPanel("Tabela", dataTableOutput("tab_div")), 
          title = "Endividamento"
        ),
        tabBox(
          tabPanel("Gráfico", plotlyOutput("graf_cond")),
          tabPanel("Tabela", dataTableOutput("tab_cond")), 
          title = "Condicionantes da Base Monetária"
        ),
        tabBox(
          tabPanel("Gráfico", plotlyOutput("graf_selic")),
          tabPanel("Tabela", dataTableOutput("tab_selic")), 
          title = "Selic"
        )
      )
    )
  )
)

