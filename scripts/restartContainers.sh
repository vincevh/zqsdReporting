docker stop mymysql
docker stop zqsdreporting
docker stop srfollowup
docker stop slackapi
docker stop mynginx

git pull

docker build -t zqsdreporting ../shinyapp
docker build -t slackapi ../slackapi
docker build -t mynginx ../nginx
docker build -t srfollowup ../srfollowup

docker start mymysql

sleep 30
docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting --link mymysql:mymysql zqsdreporting
docker run -d --rm -p 3000:3000 --name srfollowup -h srfollowup --link mymysql:mymysql srfollowup 
docker run -d --rm -p 8000:8000 --name slackapi -h slackapi --link mymysql:mymysql slackapi
#docker run  -p 3000:3000 --name srfollowup -h srfollowup --link mymysql:mymysql -v $(pwd)/srfollowup/app:/app -ti srfollowup bash
docker run -d --rm -p 80:80 --name mynginx -v ~/myLoc:/usr/share/nginx/html/myLoc --link zqsdreporting:zqsdreporting  --link slackapi:slackapi --link srfollowup:srfollowup mynginx
