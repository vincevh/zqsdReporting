##backup db
docker exec -it mymysql /usr/bin/mysqldump -u root -p mysql --databases  --flush-privileges > ../backup/mysql.sql
docker exec -it mymysql /usr/bin/mysqldump -u root -p zqsdreporting --databases > ../backup/zqsdreporting.sql
docker exec -it mymysql /usr/bin/mysqldump -u root -p srfollowup --databases > ../backup/srfollowup.sql
#docker exec -it mymysql /usr/bin/mysqldump -u root -p blog --databases > ../backup/blog.sql