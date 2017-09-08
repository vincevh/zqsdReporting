git pull
docker build -t zqsdreporting shinyapp
docker build -t slackapi slackapi
docker build -t mynginx nginx
docker build -t srfollowup srfollowup
docker build -t mymysql mysql

docker run -d -p 3306:3306 --name mymysql -e MYSQL_DATABASE=zqsdreporting -e MYSQL_ROOT_PASSWORD=dev -e MYSQL_USER=dev -e MYSQL_PASSWORD=dev  -h mymysql mymysql

## todo créer les users db

docker run -d --rm -p 1337:1337 --name zqsdreporting -h zqsdreporting --link mymysql:mymysql zqsdreporting
docker run -d --rm -p 8000:8000 --name slackapi -h slackapi slackapi --link mymysql:mymysql
docker run -d --rm -p 3000:3000 --name srfollowup -h srfollowup --link mymysql:mymysql srfollowup 
#docker run  -p 3000:3000 --name srfollowup -h srfollowup --link mymysql:mymysql -v C:/Users/desme/Dropbox/Work/DataScience/shyrkahost/srfollowup/app:/app -ti srfollowup bash
docker run -d --rm -p 80:80 --name mynginx -v ~/myLoc:/usr/share/nginx/html/myLoc --link zqsdreporting:zqsdreporting  --link slackapi:slackapi mynginx
