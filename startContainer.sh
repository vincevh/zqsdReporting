docker stop zqsdreporting
docker stop mynginx
docker stop slackapi
git pull
cd shinyapp
docker build -t zqsdreporting .
docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting zqsdreporting
cd ../slackapi
docker build -t slackapi .
docker run -d --rm -p 8000:8000 --name slackapi -h slackapi slackapi
cd ../nginx
docker build -t mynginx .
docker run -d -p 80:80 --name mynginx --rm -v ../myLoc:/usr/share/nginx/html/myLoc --link zqsdreporting:zqsdreporting  --link slackapi:slackapi mynginx

