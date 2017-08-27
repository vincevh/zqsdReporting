#' @post /slackAPI

function(text,res){
  cat("RECIEVED MSG \n")
  cat("text=")
  cat(text)
  cat("\n end text \n")
  
  request <- strsplit(text, "+",fixed = TRUE)[[1]]
  
  command <- request[2]
  
  if ( command == "echo") {
    toReturn <- data.frame(paste("you said" ,request[3], " "))
  } else if ( command == "pushtotaunt") {
    toReturn <- data.frame("smb")
  } else if ( command == "useless") {
    toReturn <- data.frame("Most useless of the week is: xxx")
  } else
    toReturn <- data.frame("Command not found")
  

  names(toReturn)<- "text"
  res$body <- jsonlite::unbox(toReturn)
}

