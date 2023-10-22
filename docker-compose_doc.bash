
Deploy Application Manually:
---------------------------

#GIT Clone 
git clone https://github.com/Iqbalkhan319/bhw.git
cd /root/bhw/includes
vim config.php
<?php
// DB credentials.
define('DB_HOST','backend');	#backend will bd service name
define('DB_USER','bhw');
define('DB_PASS','password');
define('DB_NAME','bhw');
// Establish database connection.
try
{
$dbh = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME,DB_USER, DB_PASS,array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'"));
}
catch (PDOException $e)
{
exit("Error: " . $e->getMessage());
}
?>


Create Docker file:
-------------------
vim Dockerfile
FROM maqelabs/php-apache-fpm:php-7.4.13.4
RUN apt-get update
RUN docker-php-ext-install pdo pdo_mysql
COPY . /var/www/html/
CMD ["apachectl", "-D", "FOREGROUND"]

docker build -t iqbal/bhw:v1 .
docker run -v /myql/data:/var/lib/mysql --name=backend -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=Time@12345 mysql:latest
docker exec -it backend bash
#mysql -u root -p
#Create user
create user bhw@'%' IDENTIFIED by 'Time@12345';
#create database
create database bhw;
#grant previleges
GRANT ALL PRIVILEGES ON bhw.* TO 'bhw'@'%';
flush privileges
exit
cd bhw/SQL\ File/
cat bhw.sql |docker exec -i bhw_backend /usr/bin/mysql -u root --password=Time@12345 bhw
docker run -dit --name=app -p 3000:80 --link backend:backend iqbal/bhw:v1

Check URL:
---------
http://serverip	# To login application

Install Docker Compose:
-----------------------
curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#GIT Clone 
git clone https://github.com/Iqbalkhan319/bhw.git
cd /root/bhw/includes
vim config.php
<?php
// DB credentials.
define('DB_HOST','backend');	#backend will bd service name
define('DB_USER','bhw');
define('DB_PASS','password');
define('DB_NAME','bhw');
// Establish database connection.
try
{
$dbh = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME,DB_USER, DB_PASS,array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'"));
}
catch (PDOException $e)
{
exit("Error: " . $e->getMessage());
}
?>


Create Docker file:
-------------------
vim Dockerfile
FROM maqelabs/php-apache-fpm:php-7.4.13.4
RUN apt-get update
RUN docker-php-ext-install pdo pdo_mysql
COPY . /var/www/html/
EXPOSE 3000
CMD ["apachectl", "-D", "FOREGROUND"]

###RUN BHW Application useing Docker Compose##
----------------------------------------------
Create Docker Compose file:
---------------------------
cat docker-compose.yaml

version: '3.7'
services:
  backend:
    container_name: bhw_backend
    image: mysql:latest
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: Time@12345
      MYSQL_ROOT_HOST: '%'
      MYSQL_DATABASE: "bhw"
    volumes:
      - db-data:/var/lib/mysql
    restart: unless-stopped
  phpmyadmin:
    container_name: bhw_phpmyadmin
    image: phpmyadmin:latest
    ports:
      - 3001:80
    environment:
      PMA_HOST: backend
    restart: unless-stopped
  frontend:
    container_name: bhw-app
    build: .
    ports:
      - 80:80
    depends_on:
      - backend
volumes:
  db-data:
  
docker-compose up --build -d		# Start Application
docker-compose ps

#Database user create and dump restore:
---------------------------------------
#Login mysql Container and Do following steps:
docker exec -it bhw_backend bash
#mysql -u root -p
#Create user
create user bhw@'%' IDENTIFIED by 'Time@12345';
#create database
create database bhw;
#grant previleges
GRANT ALL PRIVILEGES ON bhw.* TO 'bhw'@'%';
flush privileges

Restore DB:
-----------
cd bhw/SQL\ File/
cat bhw.sql |docker exec -i bhw_backend /usr/bin/mysql -u root --password=Time@12345 bhw		#bhw_backend[container name]

Check from Browser:
http://serverip	# To login application
http://serverip:3001  # To login phpmyadmin

#Stop Application:
------------------
docker-compose down # To shutdown application









