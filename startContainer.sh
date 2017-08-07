cd ~/zqsdReporting
docker stop zqsdreporting
git pull
docker build -t zqsdreporting .
docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting zqsdreporting
docker stop mynginx
cd ~/zqsdReporting/nginx
docker build -t mynginx .
docker run -d -p 80:80 --name mynginx --rm --link zqsdreporting:zqsdreporting bdesmet/mynginx:latest
