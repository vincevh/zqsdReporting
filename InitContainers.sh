
docker build -t zqsdreporting shinyapp
docker build -t slackapi slackapi
docker build -t mynginx nginx
docker build -t srfollowup srfollowup
docker build -t mymysql mysql

docker run -d -p 3306:3306 --name mymysql -e MYSQL_ROOT_PASSWORD=temp -h mymysql mymysql

sleep 180


##  mysqladmin -u root -p password
## mysql :
## create database zqsdreporting;
## create database srfollowup;
## create user 'zqsdreporting'@'%' identified by 'gnitroperdsqz';
## create user 'srfollowup'@'%' identified by 'puwollofrs';
## grant all privileges on zqsdreporting.* to 'zqsdreporting'@'%';
## grant all privileges on srfollowup.* to 'srfollowup'@'%';
## flush privileges;


cat backup/zqsdreporting.sql | docker exec -i mymysql /usr/bin/mysql -u root --password=temp 
cat backup/srfollowup.sql | docker exec -i mymysql /usr/bin/mysql -u root --password=temp 
#cat backup/blog.sql | docker exec -i mymysql /usr/bin/mysql -u root --password=temp 
cat backup/mysql.sql | docker exec -i mymysql /usr/bin/mysql -u root --password=temp 

docker stop mymysql