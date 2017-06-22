
cat("APP STARTED")

source(file = "ETL.R", encoding = "utf-8")
Sys.setlocale("LC_ALL", locale = "French_Belgium.1252")

library(shiny)
library(ggplot2)
library(lubridate)
library(wordcloud)
library(stringr)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(pander)
library(plotly)
library(googleVis)


yeartoload <- year(Sys.Date())

messages <- load.msgs(yeartoload)
#scoreshgt <- load.hgtscores(yeartoload)

usercolors <- load.usercolors()
jColors <- usercolors$color
names(jColors) <- usercolors$unick

mondayWeekMinus1 <- floor_date(Sys.Date() - 7, "week") + 1
sundayWeekMinus1 <- floor_date(Sys.Date(), "week")

msgWEEK <-  messages[messages$datetime >= mondayWeekMinus1 &
                       messages$datetime <=  sundayWeekMinus1 , ]
