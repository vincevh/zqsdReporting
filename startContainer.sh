cd ~/zqsdReporting
docker stop zqsdreporting
docker stop mynginx
git pull
docker build -t zqsdreporting .
docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting zqsdreporting
