library(data.table)
library(plyr)
library(dplyr)
library(openxlsx)
library(yaml)
library(jsonlite)

config <- yaml.load_file("resources/config.yml")
slackToken = config$security$tokenSlack
zipURL = config$security$zipURL
zipUser = config$security$zipUser
zipMdp = config$security$zipMdp


url= paste0("https://slack.com/api/users.list?token=", slackToken,sep="")

load.msgs <- function(yeartoload){
  
  
  #variables
  yearstoanalyse <- yeartoload
  unicksToIgnore <- c("nicobot","slackbot","thu")
  
  #pre-processing file
  
  #EXTRACT
  #loading file, not taking the 4th column wich is always the same
  
  temp <- tempfile()
  download.file(zipURL,temp)
  unzip(temp,"message.csv")
  unlink(temp)
  
  x <- readLines("message.csv")
  
  y <- gsub( "\\\\\"", "\"\"", x )
  
  cat(y, file="message.csv", sep="\n")
  

  messages <- fread("message.csv", sep = ",", header = FALSE, 
                    encoding="UTF-8",
                    colClasses = c('character','factor','character','NULL','character'),
                    col.names = c("id","nick","msg","datetime"))
  
  dataAPI <- fromJSON(url)
  uniquenicktoidfile <- dataAPI$members[!dataAPI$members$deleted,c("id","name")]
  
  
 
  
  
  nickschangefile <- flatten(stream_in(file("nick_change.log")))
  
  
  #TRANSFORM
  #converting ms timestam into date class
  messages$datetime <- as.POSIXct(as.numeric(messages$datetime)/1000, origin="1970-01-01",tz="Europe/Brussels")
  
  #filtering only data for one year (as defined in yeartoanalyse variable)
  
  messages <- filter(messages, format(datetime,"%Y") %in% yearstoanalyse)
  
  
  
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
  
}


# load.hgtscores <-  function(yeartoload){
#   scoresHGT <- read.csv(file="scoresHGT2017.csv",col.names = c("user.id","hgtscore"))
#   uniquenicktoidfile <- read.xlsx(xlsxFile = "nicks.xlsx", sheet = 2,colNames = FALSE)
#   names(uniquenicktoidfile) <- c("user.id","unick")
#   
#   scoresHGT <- merge(scoresHGT,uniquenicktoidfile)
#   scoresHGT <- scoresHGT[,2:3]
#   
# }



load.usercolors <- function(){
  dataAPI <- fromJSON(url)
  toreturn <- dataAPI$members[!dataAPI$members$deleted,c("name","color")]
  toreturn$color <- paste0("#",toreturn$color)
  names(toreturn)<- c("unick","color")
  toreturn
}







clean.msgs <- function(messagesToClean){
  stopwordsFR <-as.character(read.csv("resources/stopwords-fr.txt", fileEncoding = "UTF-8", header=FALSE)$V1  )
  
  search  = "çñÄÂÀÁäâàáËÊÈÉéèëêÏÎÌÍïîìíÖÔÒÓöôòóÜÛÙÚüûùúµ"
  replace = "cnaaaaaaaeeeeeeeeeiiiiiiiioooooooouuuuuuuuu"
  
  "%w/o%" <- function(x, y) x[!x %in% y] #--  x without y
  
  
  messagesToClean$msg <- tolower(chartr(search,replace,messagesToClean$msg))
  
  messagesToClean$msg <- str_replace_all(messagesToClean$msg, "[^[:alnum:]]", " ")
  
  temp <- (unlist(strsplit(messagesToClean$msg," ")))
  
  
  
  temp <- temp %w/o% stopwordsFR
  
  temp <- temp[temp!= ""]
  
  temp <- as.data.frame(table(temp))
  temp$temp <- as.character(temp$temp)
  
  
  temp <- temp[nchar(temp$temp) > 3,]
}



