library(data.table)
library(plyr)
library(dplyr)
library(openxlsx)
library(yaml)

config <- yaml.load_file("config.yml")
slackToken = config$security$token

load.msgs <- function(yeartoload){
  
  
  #variables
  yearstoanalyse <- yeartoload
  
  #pre-processing file
  
  #EXTRACT
  #loading file, not taking the 4th column wich is always the same
  messages <- fread("message.csv", sep = ",", header = FALSE, 
                    encoding="UTF-8",
                    colClasses = c('character','factor','character','NULL','character'),
                    col.names = c("id","nick","msg","datetime"))
  
  nickschangefile <- read.xlsx(xlsxFile = "nicks.xlsx")
  uniquenicktoidfile <- read.xlsx(xlsxFile = "nicks.xlsx", sheet = 2,colNames = FALSE)
  
  
  
  
  
  #TRANSFORM
  #converting ms timestam into date class
  messages$datetime <- as.POSIXct(as.numeric(messages$datetime)/1000, origin="1970-01-01",tz="Europe/Brussels")
  
  #filtering only data for one year (as defined in yeartoanalyse variable)
  
  messages <- filter(messages, format(datetime,"%Y") %in% yearstoanalyse)
  
  
  
  #replacing nick by the user id and then by the fixed nickname from nicks.xlsx sheet two
  names(uniquenicktoidfile) <- c("user__id","unick")
  
  mappingnickstoid <- unique(nickschangefile[,c("user__id","user__name")])
  ##this next line is to add user who didnt had any changes in their profile,
  ##so they are not in the nick changes file
  names(mappingnickstoid) <- c("user__id","unick")
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
  
}


load.hgtscores <-  function(yeartoload){
  scoresHGT <- read.csv(file="scoresHGT2017.csv",col.names = c("user__id","hgtscore"))
  uniquenicktoidfile <- read.xlsx(xlsxFile = "nicks.xlsx", sheet = 2,colNames = FALSE)
  names(uniquenicktoidfile) <- c("user__id","unick")
  
  scoresHGT <- merge(scoresHGT,uniquenicktoidfile)
  scoresHGT <- scoresHGT[,2:3]
  
}



load.usercolors <- function(){
  library(jsonlite)
  url= paste0("https://slack.com/api/users.list?token=", slackToken,sep="")
  
  
  uniquenicktoidfile <- read.xlsx(xlsxFile = "nicks.xlsx", sheet = 2,colNames = FALSE)
  names(uniquenicktoidfile) <- c("user__id","unick")
  dataAPI <- fromJSON(url)
  merged <- data.frame(dataAPI$members$id,dataAPI$members$color)
  names(merged)<-c("user__id","color")
  merged <- transform(merged, color = ifelse(is.na(color), "FFFFFF", as.character(color)))
  merged$color <- paste0("#",merged$color,sep="")
  
  merged <- merge(merged,uniquenicktoidfile,by="user__id")
  merged[,2:3]
  
  
  
  
}

