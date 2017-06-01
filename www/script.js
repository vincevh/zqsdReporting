// This recieves messages of type "infomessage" from the server.
Shiny.addCustomMessageHandler("infomessage",
  function(message) {
    alert(JSON.stringify(message));
  }
);