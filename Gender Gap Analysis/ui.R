header <- dashboardHeader(title = "Gender Gap Analysis")

sidebar <- dashboardSidebar(
    sidebarMenu(menuItem(text = "Gap Earnings", 
                         tabName = "gap", 
                         icon = icon("dashboard"),
                         badgeLabel = "annually",
                         badgeColor = "red"),
                menuItem(text = "Correlation Plot", 
                         tabName = "corr", 
                         icon = icon("th")),
                menuItem(text = "Data", 
                         tabName = "data", 
                         icon = icon("database")),
                selectInput(inputId = "tahun", 
                            label = "Choose year", 
                            choices = unique(workers$year))
                
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "gap", 
                h2("Gap Gender Annually Report"),
                fluidRow(valueBox(nrow(workers_clean), 
                                  "Data", 
                                  icon = icon("credit-card"), 
                                  color = "red"),
                         valueBox(round(mean(workers_clean$total_earnings),2), 
                                  "Mean Earnings", 
                                  icon = icon("address-card"),
                                  color = "red"),
                         valueBox(round(mean(workers_clean$total_workers), 2), 
                                  "Mean Total Workers", 
                                  icon = icon("adjust"),
                                  color = "red")),
                # fluidRow(
                #     ),
                fluidRow(
                    box(width = 10, title = "Chart",background = "black",
                        plotlyOutput("plot_ranking"))
                )
                
                
        ),
        tabItem(tabName = "corr",
                radioButtons(inputId = "num",
                             label = "Choose numerical variable", 
                             choices = names(select_if(workers_clean[,-1], is.numeric)) %>% 
                                 str_replace_all(pattern = "_", replacement = " ") %>% 
                                 str_to_title()),
                plotlyOutput("plot_corr")),
        tabItem(tabName = "data",
                dataTableOutput("dat"))
        
    )
)

dashboardPage(
    title = "My Dashboard", 
    skin = "red",
    header = header,
    body = body,
    sidebar = sidebar
)
