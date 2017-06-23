
cat(paste0(Sys.time(), " APP STARTED"))

source(file = "ETL.R", encoding = "utf-8")
Sys.setlocale("LC_ALL", locale = "French_Belgium.1252")

suppressPackageStartupMessages({
library(shiny)
library(lubridate)
  library(shiny)
  library(markdown)
  library(ggplot2)
  library(plotly)
  library(wordcloud)
  library(DT)
  
})

yeartoload <- year(Sys.Date())

cat(paste0(Sys.time(), " loading msgs"))
messages <- load.msgs(yeartoload)
#scoreshgt <- load.hgtscores(yeartoload)
cat(paste0(Sys.time(), " end loading msgs"))

usercolors <- load.usercolors()
jColors <- usercolors$color
names(jColors) <- usercolors$unick

mondayWeekMinus1 <- floor_date(Sys.Date() - 7, "week") + 1
sundayWeekMinus1 <- floor_date(Sys.Date(), "week")

msgWEEK <-  messages[messages$datetime >= mondayWeekMinus1 &
                       messages$datetime <=  sundayWeekMinus1 , ]
