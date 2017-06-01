library(shiny)
source(file = "ETL.R", encoding = "utf-8")
library(ggplot2)
library(lubridate)
library(wordcloud)
library(stringr)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(pander)

yeartoload <- year(Sys.Date())
messages <- load.msgs(yeartoload)
scoreshgt <- load.hgtscores(yeartoload)
usercolors <- load.usercolors()



jColors <- usercolors$color
names(jColors) <- usercolors$unick

shinyServer(function(input, output, session) {
  session$sendCustomMessage(type = 'infomessage',
                            message =  "Beta. Slowness should be expected.")
  
  output$wordPlot <- renderPlot({
    ##TODO: clean.msgs should be improved, cleaning the data first and not at each run
    if (input$unick == "*") {
      temp <- clean.msgs(messages[messages$datetime >= input$start
                                  & messages$datetime <=  input$end ,])
      
    } else
    {
      temp <- clean.msgs(messages[messages$unick == input$unick
                                  & messages$datetime >= input$start
                                  & messages$datetime <= input$end,])
      
    }
    
    if (max(temp$Freq) < input$freq) {
      session$sendCustomMessage(type = 'infomessage',
                                message =  "Freq too high, setting it back to the max value")
      
      updateSliderInput(
        session = session,
        inputId = "freq",
        value = max(temp$Freq)
      )
    }
    
    wordcloud_rep <- repeatable(wordcloud)
    
    wordcloud_rep(
      temp$temp,
      temp$Freq,
      max.words = input$max,
      min.freq = input$freq,
      random.order = FALSE,
      rot.per = 0.35,
      colors = brewer.pal(8, "Dark2")
    )
    
    
    
  }, height = 700, width = 700)
  
  
})
