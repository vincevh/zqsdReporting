#' @post /slackAPI
function(text){
cat("RECIEVED MSG \n")
cat(text)

temp <- data.frame(paste("you said" ,text, " "))
names(temp)<- "text"

temp

}

