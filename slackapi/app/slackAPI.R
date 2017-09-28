library(RMySQL)
library(yaml)
library(jsonlite)

config <- yaml.load_file("./resources/config.yml")
dbMdp = config$security$dbMdp

connectDB <- function(){
  dbConnect(MySQL(),
            user = 'zqsdreporting',
            password = dbMdp,
            host = 'mymysql',
            port = 3306,
            dbname= 'zqsdreporting')
  
}



#' @post /slackAPI

function(text,res){

  request <- strsplit(text, "+",fixed = TRUE)[[1]]
  
  command <- request[2]
  
  if ( command == "echo") {
    toReturn <- data.frame(request[3])
    
    
  } else if ( command == "minpussy") {
    toReturn <- data.frame(as.numeric(request[3])/2+7)
    
    
  } else if ( command == "yesno") {
    answers <- c("yes","no")
    toReturn <- data.frame(answers[sample(1:2, 1)])
    
    
    
    
  }else if ( command == "bitcoin") {
    
    amount <- request[3]
    rate_buy <- request[4]
    dataAPI <- fromJSON("https://www.bitstamp.net/api/v2/ticker/btceur/")
    current_rate <- dataAPI$last
    gain <- ((amount / rate_buy) * current_rate) - amount
    
    toReturn <- data.frame(paste0("Gain: ",as.numeric(gain)))
    
    
    
    
  }else if ( command == "useless_week") {
    con <-  connectDB()
    useless <- dbReadTable(con, "countMsgWeek")  
    
    useless <- useless[which.max(useless$n),]
    
    toReturn <- data.frame(paste0("Most useless week-1: ",useless[,2], "  (",useless[,1], " messages)"  ))
    dbDisconnect(con)
  }else if ( command == "useless_day") {
    con <-  connectDB()
    useless <- dbReadTable(con, "countMsgDayMinusOne")  
    
    useless <- useless[which.max(useless$n),]
    
    toReturn <- data.frame(paste0("Most useless day-1: ",useless[,2], " (",useless[,1], " messages)"  ))
    dbDisconnect(con)
}else
    toReturn <- data.frame("Command not found. Commands: echo <oneword>, yesno, minpussy <age>, useless_week, useless_day, bitcoin <amount in euro> <BTC/EUR exchange rate when bought>")
  

  names(toReturn)<- "text"
  res$body <- jsonlite::unbox(toReturn)
}
