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
      menuItem("Setor externo", tabName = "externo"),
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
          p("Este projeto visa facilitar a exploração de uma síntese de dados e indicadores conjunturais atualizados"),
          div(
            actionButton("ir_atividade", "Atividade econômica"),
            actionButton("ir_inflacao", "Inflação"),
            actionButton("ir_trabalho", "Mercado de trabalho"),
            actionButton("ir_fiscal", "Política fiscal"),
            actionButton("ir_monetaria", "Política monetária"),
            actionButton("ir_externo", "Setor externo"),
            actionButton("ir_internacionais", "Internacionais")
            
          ),
          width = 12
        )
        
      ),
      tabItem(
        "atividade",
        tabBox(
          tabPanel("Gráfico",plotlyOutput("graf_pibr")),
          tabPanel("Tabela",dataTableOutput("tab_pibr")),
          title = "Crescimento do PIB"
        ),
        tabBox(
          tabPanel("Gráfico",plotlyOutput("graf_pfi")),
          tabPanel("Tabela",dataTableOutput("tab_pfi")),
          title = "Produção Física Industrial (var %)"
        )
        ),

      tabItem(
        "inflacao",
        tabBox(
          tabPanel("Gráfico",plotlyOutput("graf_ipca")),
          tabPanel("Tabela",dataTableOutput("tab_ipca")),
          title = "IPCA (var %)"
        ),
        tabBox(
          tabPanel("Gráfico",plotlyOutput("graf_cacomp")),
          tabPanel("Tabela",dataTableOutput("tab_cacomp")),
          title = "IPCA - Componentes (var %)"
        )
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
          title = "Meios de Pagamento"
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
        ),
        tabBox(
          tabPanel("Tabela", dataTableOutput("tab_creditosetorial")), 
          title = "Crédito Setorial", width = 12
        )
      ),
      tabItem(
        "externo"
      ),
      tabItem(
        "internacionais"
      )
    )
  )
)

