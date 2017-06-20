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
library(plotly)

yeartoload <- year(Sys.Date())
messages <- load.msgs(yeartoload)
scoreshgt <- load.hgtscores(yeartoload)
usercolors <- load.usercolors()

mondayWeekMinus1 <- floor_date(Sys.Date()-7, "week")+1
sundayWeekMinus1 <- floor_date(Sys.Date(), "week")

msgWEEK <- messages[messages$datetime >=mondayWeekMinus1 & messages$datetime <=  sundayWeekMinus1 ,]
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
  
  
  output$chart1 <- renderPlotly({

    
    
    
    
    msgpernickperhourWEEK <- count(msgWEEK, unick ,hour(datetime))
    
    names(msgpernickperhourWEEK) <- c("unick","hour","n")
    
    
    p <- ggplot(data=msgpernickperhourWEEK, aes(x=hour,y=unick)) + geom_point(aes(size=n),pch=21,stroke=0) + aes(fill=unick) + scale_fill_manual(values = jColors)+ ggtitle("Activity per hour of previous week")  + scale_x_continuous(breaks=1:24) + guides(color=FALSE,fill=FALSE)
   ggplotly(p,width=800,height=600,tooltip=c("n"))
    
    
  })
  
  output$chart2 <- renderPlotly({
  msgpernickWEEKK <- count(msgWEEK, unick)
  
  
  p <- ggplot(data=msgpernickWEEKK,aes(reorder(unick,n),n)) + geom_bar(stat='identity') + coord_flip() + ylab("Number of messages") + xlab("Username")+ ggtitle("Most useless at work (previous week)") + aes(fill=unick)+ scale_fill_manual(values = jColors)+ guides(fill=FALSE)
  
  ggplotly(p,width=800,height=600,tooltip=c("n"))
  
  })
  
  
  output$messages = renderDataTable({
    messages[,c("datetime","unick","msg")]
  })
  
  
  
  output$chart4 <- renderPlotly({
    msgpernickperweekday<- count(messages, unick ,format(datetime,"%A"))
    names(msgpernickperweekday) <- c("unick","weekday","n")
    
    msgpernickperweekday$weekday <- factor(msgpernickperweekday$weekday, levels = c("lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"))
    
    
    p <- ggplot(data=msgpernickperweekday,aes(reorder(unick,n),n,fill=weekday)) + coord_flip() + geom_bar(stat="identity") + ggtitle(sprintf("Number of messages per weekday for %s", (yeartoload))) + xlab("Username") + ylab("# of messages") + scale_fill_brewer(palette = "Blues")
    
    ggplotly(p,width=800,height=600)
    
  })
  
  output$chart5 <- renderPlotly({
    msgpernickperhour<- count(messages, unick ,hour(datetime))
    names(msgpernickperhour) <- c("unick","hour","n")
    
    
    
    p <-  ggplot(data=msgpernickperhour, aes(x=hour,y=unick)) + geom_point(aes(size=n),pch=21,stroke=0) + aes(fill=unick) + scale_fill_manual(values = jColors)+ ggtitle("Activity per hour for the whole year") + scale_x_continuous(breaks=1:24) + guides(color=FALSE,fill=FALSE)
    
    ggplotly(p,width=800,height=600)
    
  })
  
  
  output$chart6 <- renderPlotly({
    msgperweekpernick <- count(messages, unick ,format(datetime,"%U"))
    names(msgperweekpernick) <- c("unick","weeknumber","count")
    p <- ggplot(data=msgperweekpernick,aes(weeknumber,count,fill=unick)) + geom_bar(stat='identity')+ scale_fill_manual(values = jColors) + ggtitle("Number of messages per week & per nick") + xlab("Week Number") + ylab("Number of messages")
    
    ggplotly(p,width=800,height=600)
    
  })
  
  
  output$chart7 <- renderPlotly({
    messages2 <- messages
    messages2$msg <- as.numeric(nchar(messages2$msg))
    messages2 <- messages2[,c(2,4)]
    toplot <- aggregate(messages2$msg, by=list(messages2$unick), FUN="mean")
    toplot <- toplot[,1:2]
    names(toplot) <- c("Nick","averagecharpermsg")
    p <- ggplot(toplot,aes(x = Nick,y=averagecharpermsg)) + geom_bar(stat="identity") + coord_flip() + aes(fill=Nick) + scale_fill_manual(values = jColors) + guides(fill=FALSE) + ggtitle("Average number of chars per message") + xlab("Nick") + ylab("Average chars in message")
    ggplotly(p,width=800,height=600)
    
  })
  
  
  
})
