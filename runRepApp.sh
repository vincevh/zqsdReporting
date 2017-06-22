#
killall R
git pull
R -e "shiny::runApp('.',host= '127.0.0.1', port = 1337)"
