cd ~/zqsdReporting
docker stop zqsdreporting
docker stop mynginx
git pull
docker build -t zqsdreporting .
docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting zqsdreporting
cd ~/zqsdReporting/nginx
docker build -t mynginx .
docker run -d -p 80:80 --name mynginx --rm -v ~/myLoc:/usr/share/nginx/html/myLoc --link zqsdreporting:zqsdreporting mynginx
