docker stop zqsdreporting
docker stop mynginx
docker stop slackapi
git pull
docker build -t zqsdreporting shinyapp
docker build -t slackapi slackapi
docker build -t mynginx nginx
docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting zqsdreporting
docker run -d --rm -p 8000:8000 --name slackapi -h slackapi slackapi
docker run -d --rm -p 80:80 --name mynginx -v ~/myLoc:/usr/share/nginx/html/myLoc --link zqsdreporting:zqsdreporting  --link slackapi:slackapi mynginx

