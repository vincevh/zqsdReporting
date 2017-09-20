suppressPackageStartupMessages({
library(data.table)
library(plyr)
library(dplyr)
library(openxlsx)
library(yaml)
library(jsonlite)
library(stringr)
library(RMySQL)
})

config <- yaml.load_file("resources/config.yml")
slackToken = config$security$tokenSlack
zipURL = config$security$zipURL
zipUser = config$security$zipUser
zipMdp = config$security$zipMdp
dbMdp = config$security$dbMdp

url= paste0("https://slack.com/api/users.list?token=", slackToken,sep="")


connectDB <- function(){
  dbConnect(MySQL(),
            user = 'zqsdreporting',
            password = dbMdp,
            host = 'mymysql',
            port = 3306,
            dbname= 'zqsdreporting')
  
}

  

  
  





load.msgs <- function(yeartoload){
  con <- connectDB()
  
  unicksToIgnore <- c("nicobot","slackbot","thu")
  
  temp <- tempfile()
  download.file(zipURL,temp)
  unzip(temp,"message.csv",exdir = "input")
  unlink(temp)
  
  x <- readLines("input/message.csv")
  
  y <- gsub( "\\\\\"", "\"\"", x )
  
  cat(y, file="input/message.csv", sep="\n")
  

  messages <- fread("input/message.csv", sep = ",", header = FALSE, 
                    encoding="UTF-8",
                    colClasses = c('character','factor','character','NULL','character'),
                    col.names = c("id","nick","msg","datetime"))
  
  dataAPI <- fromJSON(url)
  uniquenicktoidfile <- dataAPI$members[!dataAPI$members$deleted,c("id","name")]
 
  nickschangefile <- flatten(stream_in(file("input/nick_change.log")))
  
  
  #TRANSFORM
  #converting ms timestam into date class
  messages$datetime <- as.POSIXct(as.numeric(messages$datetime)/1000, origin="1970-01-01",tz="Europe/Brussels")
  
  #filtering only data for one year (as defined in yeartoanalyse variable)
  
  messages <- filter(messages, format(datetime,"%Y") %in% yeartoload)
  
  
  
  #replacing nick by the user id and then by the fixed nickname from nicks.xlsx sheet two
  names(uniquenicktoidfile) <- c("user.id","unick")
  
  mappingnickstoid <- unique(nickschangefile[,c("user.id","user.name")])
  ##this next line is to add user who didnt had any changes in their profile,
  ##so they are not in the nick changes file
  names(mappingnickstoid) <- c("user.id","unick")
  mappingnickstoid <- unique(rbind(mappingnickstoid, uniquenicktoidfile))
  
  
  messages <- merge(messages,mappingnickstoid, by.x = "nick", by.y =  "unick", all = TRUE)
  messages <- merge(messages, uniquenicktoidfile)
  
  
  
  #taking only needed cols
  messages <- messages[,c("id","msg","datetime","unick")]
  messages$unick <- as.factor(messages$unick)
  #sorting by date and time
  messages <- messages[order(messages$datetime),]
  
  #removing all lines with NA
  messages <- messages[complete.cases(messages),]
  
  ##removing all messages from ignored nicks
  messages <- messages[!messages$unick %in% unicksToIgnore,]
  
  dbWriteTable(conn = con, name = 'Messages', value = messages, overwrite=TRUE,row.names=FALSE, field.types=list(datetime="datetime", id="int",msg="text",unick="text"))
  dbDisconnect(con)
  messages
  
}

load.previousweek <- function(mondayWeekMinus1,sundayWeekMinus1){

msgWEEK <- messages[messages$datetime >= mondayWeekMinus1 &
           messages$datetime <=  sundayWeekMinus1 , ]
con <- connectDB()
dbWriteTable(conn = con, name = 'MessagesWeek', value = msgWEEK, overwrite=TRUE,row.names=FALSE, field.types=list(datetime="datetime", id="int",msg="text",unick="text"))

countMsgWeek<- count(msgWEEK, unick)

dbWriteTable(conn = con, name = 'countMsgWeek', value = countMsgWeek, overwrite=TRUE,row.names=FALSE, field.types=list(n="int",unick="text"))

dbDisconnect(con)
msgWEEK
}


load.previousday <- function(day){
  msgDayMinusOne <- messages[messages$datetime <= ceiling_date(day,"day") & messages$datetime >= floor_date(day,"day"),]
  countMsgDay <- count(msgDayMinusOne, unick)
  con <- connectDB()
  dbWriteTable(conn = con, name = 'countMsgDayMinusOne', value = countMsgDay, overwrite=TRUE,row.names=FALSE, field.types=list(n="int",unick="text"))
  dbDisconnect(con)
  
}

get.count.msg.week <- function(){
  con <- connectDB()
  toreturn <-  dbReadTable(con, "countMsgWeek")
  dbDisconnect(con)
  toreturn
}


load.usercolors <- function(){
  dataAPI <- fromJSON(url)
  toreturn <- dataAPI$members[!dataAPI$members$deleted,c("name","color")]
  toreturn$color <- paste0("#",toreturn$color)
  names(toreturn)<- c("unick","color")
  toreturn
}


clean.msgs <- function(messagesToClean){
  
  ##todo: ne pas lire le fichier à chaque fois.. boulet va
  stopwordsFR <-as.character(read.csv("resources/stopwords-fr.txt", fileEncoding = "UTF-8", header=FALSE)$V1  )
  
  search  = "çñÄÂÀÁäâàáËÊÈÉéèëêÏÎÌÍïîìíÖÔÒÓöôòóÜÛÙÚüûùúµ"
  replace = "cnaaaaaaaeeeeeeeeeiiiiiiiioooooooouuuuuuuuu"
  
  "%w/o%" <- function(x, y) x[!x %in% y] #--  x without y
  
  
  messagesToClean$msg <- tolower(chartr(search,replace,messagesToClean$msg))
  #removing smilies
  messagesToClean$msg <- str_replace_all(messagesToClean$msg, ":[A-Za-z_]*:", "")
  
  messagesToClean$msg <- str_replace_all(messagesToClean$msg, "[^[:alnum:]]", " ")
  
  temp <- (unlist(strsplit(messagesToClean$msg," ")))
  
  temp <- temp %w/o% stopwordsFR
  
  temp <- temp[temp!= ""]
  
  temp <- as.data.frame(table(temp))
  temp$temp <- as.character(temp$temp)
  names(temp) <- c("Word","Freq")
  
  
  temp <- temp[nchar(temp$Word) > 3,]
}



generateLinkTable <- function(messagesURL){
  url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  
  messagesURL$msg <- str_extract(messagesURL$msg, url_pattern)
  messagesURL <- messagesURL[!grepl("zqsd",messagesURL$msg),]
  messagesURL$msg <- sub(">","",messagesURL$msg)
  messagesURL$month <-  format(messagesURL$datetime, "%m")
  
  messagesURL[messagesURL$month == currentMonthNumber,c("unick","msg")]
}

