source(file = "services/ETL.R", encoding = "utf-8")


usercolors <- load.usercolors()



navbarPage(
  "#zqsd",
  
  tabPanel("Weekly",
           fluidPage(
            fixedRow(
               textOutput("Load"),
               plotlyOutput("chart1", height=600),
               plotlyOutput("chart2", height=600)
             )
           )),
  
  
  
  tabPanel("Yearly",
           fluidPage(
             fluidRow(
               plotlyOutput("chart6", height=600),
               plotlyOutput("chart5", height=600),
               plotlyOutput("chart4", height=600)
             )
           )),
  
  
  tabPanel("WordCloud",
           fluidPage(
               titlePanel("zqsd Word Cloud"),
               #js file is used to display pop up messages 
               singleton(tags$head(tags$script(src = "script.js"))),

               sidebarLayout(
                 sidebarPanel(
                   selectInput(
                     "unick",
                     label = "Select username",
                     choices = append(c("*"), usercolors$unick[!usercolors$color == "#FFFFFF"])
                   ),
                   dateInput(
                     "start",
                     label = "Begin Date",
                     format = "dd-mm-yyyy",
                     value = "2017-01-01",
                     min = "2017-01-01",
                     max = Sys.Date(),
                     weekstart = 1,
                     language = "fr"
                   ),
                   dateInput(
                     "end",
                     label = "End Date",
                     format = "dd-mm-yyyy",
                     value = Sys.Date(),
                     min = "2017-01-01",
                     max = Sys.Date(),
                     weekstart = 1,
                     language = "fr"
                   ),
                   hr(),
                   sliderInput(
                     "freq",
                     "Minimum Frequency:",
                     min = 1,
                     max = 100,
                     value = 10
                   ),
                   sliderInput(
                     "max",
                     "Maximum Number of Words:",
                     min = 1,
                     max = 300,
                     value = 100
                   )
                 ),
                 mainPanel(plotOutput("wordPlot"))
               ),
               
               fluidRow(
                 column(12, dataTableOutput('wordCloudData')
                 )
               )
           )),
  
  
  tabPanel("Links",
               tabPanel("URLs current month",
                        fluidPage(
                          fixedRow(
                            dataTableOutput('links')
                          )
                        ))
           ),
  
  
  navbarMenu("More",
             tabPanel("Messages archive",
                      dataTableOutput('messages')),
             tabPanel("Files archive",
                      htmlOutput("boxlink")
                      )),
              tabPanel("About",
                       fluidRow(includeMarkdown("../README.md")
                       ))

)

