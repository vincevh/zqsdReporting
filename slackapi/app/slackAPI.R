#' @post /slackAPI

function(text,res){

  request <- strsplit(text, "+",fixed = TRUE)[[1]]
  
  command <- request[2]
  
  if ( command == "echo") {
    toReturn <- data.frame(request[3])
    
    
  } else if ( command == "minpussy") {
    toReturn <- data.frame(request[3]/2+7)
    
    
  } else if ( command == "yesno") {
    answers <- c("yes","no")
    toReturn <- data.frame(answers[sample(1:2, 1)])
    
  } else
    toReturn <- data.frame("Command not found. Commands: echo <word>, yesno, minpussy <age>")
  

  names(toReturn)<- "text"
  res$body <- jsonlite::unbox(toReturn)
}