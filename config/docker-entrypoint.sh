#!/bin/bash
set -euo pipefail

apache_tomcat_initilizing() {
   if [[ ! -d "/opt/tomcat/webapps/app1" ]]; then
         git config --global user.name "mydemorepo"
         git config --global user.email adamvasyliuta@gmail.com
         cd /opt/tomcat/webapps
         git clone https://github.com/mydemorepo/app1.git
         cd app1
         git remote add app1 https://github.com/mydemorepo/app1.git
         cp -f /opt/tomcat/webapps/app1/config/tomcatconfig/tomcatusers.xml /opt/tomcat/conf/tomcat-users.xml
         cp -f /opt/tomcat/webapps/app1/config/tomcatconfig/context_.xml /opt/tomcat/webapps/manager/META-INF/context.xml
         cp -f /opt/tomcat/webapps/app1/config/tomcatconfig/context__.xml /opt/tomcat/conf/context.xml
         mv /opt/tomcat/webapps/app1/config/tomcatconfig/mysql-connector-java-8.0.19.jar /opt/tomcat/lib 
         chown -R mysql:mysql /usr/lib/jvm
         chown -R mysql:mysql /opt/tomcat
   fi
}

mysql_initilizing() {
   if [[ ! -d "/var/lib/mysql/classicmodels" ]]; then
      #MySQL service start
         service mysql start
      #Change the authentication method for root
         mysql -u root -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
      #Databases creation
         mysql -uroot -proot < /opt/tomcat/webapps/app1/config/mysqlconfig/sampledatabase.sql;
         mysql -uroot -proot < /opt/tomcat/webapps/app1/config/mysqlconfig/sessions.sql;
         service mysql stop
   fi
}

apache_ant_initilizing() {
   if [[ -O "/opt/ant" && -G "/opt/ant" ]]; then
         cp /opt/tomcat/lib/catalina-ant.jar /opt/ant/lib/catalina-ant.jar
         chown -R mysql:mysql /opt/ant
   fi
}

apache_http_initilizing() {
   if [[ -O "/var/www/html" && -G "/var/www/html" ]]; then
         cp /opt/tomcat/webapps/app1/config/apache2config/000-default.conf /etc/apache2/sites-available/000-default.conf
         chown -R www-data:www-data /var/www/html
         a2enmod proxy
         a2enmod proxy_http
   fi
}

apache_tomcat_start() {
         gosu mysql sh /opt/tomcat/bin/startup.sh
}

mysql_start() {
         service mysql start
}

apache_http_start() {
         service apache2 start
}

if [[ "$1" == /bin/bash ]]; then
         mysql_initilizing
         apache_tomcat_initilizing
         apache_http_initilizing
         apache_ant_initilizing
         mysql_start
         apache_tomcat_start
         apache_http_start
fi
         exec gosu mysql "$@"
