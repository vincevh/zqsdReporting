
library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Word Cloud"),
  

  sidebarLayout(
    sidebarPanel(
       selectInput("unick", label="Select username", choices = c("*","logs","bz","paf"))
    ),
    
    mainPanel(
       plotOutput("wordPlot")
    )
  )
))
