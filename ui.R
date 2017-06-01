


library(shiny)
source(file = "ETL.R", encoding = "utf-8")
usercolors <- load.usercolors()


shinyUI(fluidPage(
  # Application title
  titlePanel("zqsd Word Cloud 2017 [BETA]"),
  
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
))
