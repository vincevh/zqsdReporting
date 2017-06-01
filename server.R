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




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$wordPlot <- renderPlot({

    
    if(input$unick == "*"){
      temp <- clean.msgs(messages)
    }else
    {
      temp <- clean.msgs(messages[messages$unick==input$unick,])
    }
   
    
    
    layout(matrix(c(1, 2),ncol = 2), widths = c(1, 10))
    par(mar=c(0,3,0,0))
    plot.new()
    
    
    wordcloud(temp$temp,temp$Freq,max.words =100, main="Title" , min.freq = 4
              , random.order = FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
    
    text(x=0, y=0.5, input$unick, col=jColors[input$unick],cex=2,srt=90, font=2)
   
    
  })
  
})
