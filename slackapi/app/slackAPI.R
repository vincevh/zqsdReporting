library(RMySQL)
library(yaml)


config <- yaml.load_file("./resources/config.yml")
dbMdp = config$security$dbMdp

con <- dbConnect(MySQL(),
                 user = 'zqsdreporting',
                 password = dbMdp,
                 host = 'mymysql',
                 port = 3306,
                 dbname= 'zqsdreporting')


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
    
    
    
    
  }else if ( command == "useless_week") {
    
    useless <- dbReadTable(con, "countMsgWeek")  
    
    useless <- useless[which.max(useless$n),]
    
    toReturn <- data.frame(paste0("The most useless of previous week is ",useless[,2], " with ",useless[,1], " messages"  ))
    
  }else if ( command == "useless_day") {
  
    useless <- dbReadTable(con, "countMsgDayMinusOne")  
    
    useless <- useless[which.max(useless$n),]
    
    toReturn <- data.frame(paste0("The most useless of previous day is ",useless[,2], " with ",useless[,1], " messages"  ))
  
}else
    toReturn <- data.frame("Command not found. Commands: echo <oneword>, yesno, minpussy <age>, useless_week, useless_day")
  

  names(toReturn)<- "text"
  res$body <- jsonlite::unbox(toReturn)
}
