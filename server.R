


shinyServer(function(input, output, session) {
  session$sendCustomMessage(type = 'infomessage',
                            message =  "Beta. Slowness should be expected. Please wait 30 sec for the 1st charts to appear")
  
  output$Load<-  renderText({ 
    paste("From:",mondayWeekMinus1, "To:",sundayWeekMinus1,"Last message in db: ", max(messages$datetime), sep=" ")
  })
  
 
  
  
  output$wordPlot <- renderPlot({
    ##TODO: clean.msgs should be improved, cleaning the data first and not at each run
    if (input$unick == "*") {
      temp <- clean.msgs(messages[messages$datetime >= input$start
                                  & messages$datetime <=  input$end , ])
      
    } else{
      temp <- clean.msgs(messages[messages$unick == input$unick
                                  & messages$datetime >= input$start
                                  & messages$datetime <= input$end, ])
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
    
    output$wordCloudData <-renderDataTable(
      datatable(
        temp, options = list(
          pageLength = 15, order = list(2, 'desc')
        )
      )
    )
    
    
    wordcloud_rep <- repeatable(wordcloud)
    
    wordcloud_rep(
      temp$Word,
      temp$Freq,
      max.words = input$max,
      min.freq = input$freq,
      random.order = FALSE,
      rot.per = 0.35,
      colors = brewer.pal(8, "Dark2")
    )}, height = 600, width = 600)
  
  
  
  output$chart1 <- renderPlotly({
    msgpernickperhourWEEK <- count(msgWEEK, unick , hour(datetime))
    names(msgpernickperhourWEEK) <- c("unick", "hour", "n")
    
    p <-ggplot(data = msgpernickperhourWEEK, aes(x = hour, y = unick)) +
     geom_point(aes(size = n), pch = 21, stroke = 0) +
     aes(fill = unick) +
     scale_fill_manual(values = jColors) +
     ggtitle("Activity per hour of previous week")  +
     scale_x_continuous(breaks = 1:24) +
     guides(color = FALSE, fill = FALSE) +
    theme(plot.margin=unit(c(2,1,1,1),"cm"))
    
    ggplotly(p,
             width = 800,
             height = 600,
             tooltip = c("n"))
  })
  
  
  output$chart2 <- renderPlotly({
    msgpernickWEEKK <- count(msgWEEK, unick)
    
    p <-ggplot(data = msgpernickWEEKK, aes(reorder(unick, n), n)) +
     geom_bar(stat ='identity') +
     coord_flip() +
     ylab("Number of messages") +
     xlab("Username") +
     ggtitle("Most useless at work (previous week)") +
     aes(fill =unick) +
     scale_fill_manual(values = jColors)+
     guides(fill = FALSE)+
      theme(plot.margin=unit(c(2,1,1,1),"cm"))
    
    ggplotly(p,
             width = 800,
             height = 600,
             tooltip = c("n"))
    
  })
  
  
  
  output$messages = renderDataTable({
    datatable(
    messages[, c("datetime", "unick", "msg")],
    options = list(
      pageLength = 100, order = list(1, 'desc')
    ))
  })
  

  
  output$chart4 <- renderPlotly({
    msgpernickperweekday <- count(messages, unick , format(datetime, "%A"))
    names(msgpernickperweekday) <- c("unick", "weekday", "n")
    
    msgpernickperweekday$weekday <-
      factor(
        msgpernickperweekday$weekday,
        levels = c(
          "lundi",
          "mardi",
          "mercredi",
          "jeudi",
          "vendredi",
          "samedi",
          "dimanche"
        )
      )
    
    p <-ggplot(data = msgpernickperweekday, aes(reorder(unick, n), n, fill = weekday)) +
     coord_flip() +
     geom_bar(stat = "identity") +
     ggtitle(sprintf("Number of messages per weekday for %s", (yeartoload))) +
     xlab("Username") +
     ylab("# of messages") +
     scale_fill_brewer(palette = "Blues")+
      theme(plot.margin=unit(c(2,1,1,1),"cm"))
    
    ggplotly(p, width = 800, height = 600)
  })
  
  
  
  output$chart5 <- renderPlotly({
    msgpernickperhour <- count(messages, unick , hour(datetime))
    names(msgpernickperhour) <- c("unick", "hour", "n")
    
    p <-ggplot(data = msgpernickperhour, aes(x = hour, y = unick)) +
     geom_point(aes(size = n), pch = 21, stroke = 0) +
     aes(fill = unick) +
     scale_fill_manual(values = jColors) +
     ggtitle("Activity per hour for the whole year") +
     scale_x_continuous(breaks = 1:24) +
     guides(color = FALSE, fill = FALSE)+
      theme(plot.margin=unit(c(2,1,1,1),"cm"))
    
    ggplotly(p, width = 800, height = 600)
  })
  
  
  
  output$chart6 <- renderPlotly({
    msgperweekpernick <- count(messages, unick , format(datetime, "%U"))
    names(msgperweekpernick) <- c("unick", "weeknumber", "count")
    
    p <-ggplot(data = msgperweekpernick, aes(weeknumber, count, fill = unick)) +
     geom_bar(stat ='identity') +
     scale_fill_manual(values = jColors) +
     ggtitle("Number of messages per week & per nick") +
     xlab("Week Number")+
     ylab("Number of messages")+
      theme(plot.margin=unit(c(2,1,1,1),"cm"))
    
    ggplotly(p, width = 800, height = 600)
  })

})
