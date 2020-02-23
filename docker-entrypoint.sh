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
               sh /opt/tomcat/bin/startup.sh
      else
               git pull app1 master
               sh /opt/tomcat/bin/startup.sh
      fi
}

mysql_initilizing() {
      if [[ ! -d "/var/lib/mysql/classicmodels" ]]; then
            #MySQL service start
               service mysql start
            #Change the authentication method for root
               mysql -u root -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
            #database creation
               mysql -uroot -proot < /opt/tomcat/webapps/app1/sampledatabase.sql;
      else
            #MySQL service start
               service mysql start
      fi
}

if [[ "$1" == /bin/bash ]]; then
         apache_tomcat_initilizing
         mysql_initilizing
fi


exec "$@"
