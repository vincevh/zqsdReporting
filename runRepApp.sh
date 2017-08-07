#
##export LANG=fr_BE.utf8
killall R
git -C /home/ec2-user/zqsdReporting/ pull
R -e "shiny::runApp('/home/ec2-user/zqsdReporting/',host= '127.0.0.1', port = 1337)"
