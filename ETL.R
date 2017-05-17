library(data.table)
library(plyr)
library(dplyr)
library(openxlsx)



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
  
  messages <- merge(messages,mappingnickstoid, by.x = "nick", by.y =  "user__name")
  messages <- merge(messages, uniquenicktoidfile)
  
  #taking only needed cols
  messages <- messages[,c("id","msg","datetime","unick")]
  messages$unick <- as.factor(messages$unick)
  #sorting by date and time
  messages <- messages[order(messages$datetime),]
  
}


load.hgtscores <-  function(yeartoload){
  scoresHGT <- read.csv(file="scoresHGT2017.csv",col.names = c("user__id","hgtscore"))
  uniquenicktoidfile <- read.xlsx(xlsxFile = "nicks.xlsx", sheet = 2,colNames = FALSE)
  names(uniquenicktoidfile) <- c("user__id","unick")
  
  scoresHGT <- merge(scoresHGT,uniquenicktoidfile)
  scoresHGT <- scoresHGT[,2:3]
  
}



