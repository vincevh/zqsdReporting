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
    
    
    
    
  }else if ( command == "useless") {
  
    useless <- dbReadTable(con, "countMsgWeek")  
    
    useless <- useless[which.max(useless$n),2]
    
    toReturn <- data.frame(paste0("the most useless of previous week is: ",useless))
  
}else
    toReturn <- data.frame("Command not found. Commands: echo <word>, yesno, minpussy <age>, useless")
  

  names(toReturn)<- "text"
  res$body <- jsonlite::unbox(toReturn)
}
