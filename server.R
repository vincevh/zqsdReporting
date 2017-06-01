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

shinyServer(function(input, output) {
  
  loadMsgs <- reactive({
   
    
    # Change when the "update" button is pressed...
    input$update
    
    isolate({
    withProgress({
      setProgress(message = "Loading messages ...")
     
      
      if(input$unick == "*"){
        temp <- clean.msgs(messages[messages$datetime >=input$start & messages$datetime <=  input$end ,])
        
      }else
      {
        temp <- clean.msgs(messages[messages$unick==input$unick & messages$datetime >=input$start & messages$datetime <=  input$end,])
      }
    })
    
    
    }) 
    })
  
   
  output$wordPlot <- renderPlot({

    temp <- loadMsgs()

    wordcloud(temp$temp,temp$Freq,max.words = input$max, min.freq = input$freq, scale=c(4,0.5),
               random.order = FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
   
   
    
  }, height = 700, width = 700 )
  
})
