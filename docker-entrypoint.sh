#!/bin/bash
set -euo pipefail

apache_tomcat_initilizing() {
       
        sh /opt/tomcat/bin/startup.sh
        echo "Apache Tomcat server initialiazed!"
}

mysql_initilizing() {
     #MySQL service start
        service mysql start
     #Change the authentication method for root
        mysql -u root -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
     #database creation
        cd /tmp
        curl -LJO https://raw.githubusercontent.com/mydemorepo/files/master/sampledatabase.sql
        mysql -uroot -proot < sampledatabase.sql;
     #selection of the database used in the application
        mysql -u user1 -ppass1 -e "USE classicmodels;"
        echo "MySQL database initialized!"
}

if [[ "$1" == /bin/bash ]]; then
        echo ""
        echo "***APACHE TOMCAT SERVER INITIALIZING ... ***"
        echo ""
        apache_tomcat_initilizing
        echo ""
        echo "*** APACHE TOMCAT SERVER STARTED SUCCESSFULY ***"
        echo ""
        echo ""
        echo "***MySQL SERVER INITIALIZING ... ***"
        echo ""
        mysql_initilizing
        echo ""
        echo "***MySQL SERVER STARTED SUCCESSFULY ***"
fi


exec "$@"
