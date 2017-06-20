source(file = "ETL.R", encoding = "utf-8")
library(shiny)
library(markdown)
library(ggplot2)
library(plotly)

usercolors <- load.usercolors()



navbarPage(
  "#zqsd [BETA!]",
  
 
  tabPanel("Weekly",
           fluidPage(
            fixedRow(
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
               #,plotlyOutput("chart7", height=600)
             )
           )),
  
  
  
  tabPanel("WordCloud",
           fluidPage(
               titlePanel("zqsd Word Cloud 2017 [BETA]"),
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
               )
           )),
  
  
  tabPanel("DEV",
           fluidPage(
             fixedRow(
              "DEV"
             )
           )),
  
  
  navbarMenu("More",
             tabPanel("Messages archive",
                      dataTableOutput('messages')),
             tabPanel("About",
                      fluidRow(includeMarkdown("README.md")
                      )))

)

