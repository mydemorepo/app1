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
         cp /opt/tomcat/lib/catalina-ant.jar /opt/ant/lib/catalina-ant.jar
         cp -f /opt/tomcat/webapps/app1/config/tomcatusers.xml /opt/tomcat/conf/tomcat-users.xml
         cp -f /opt/tomcat/webapps/app1/config/context_.xml /opt/tomcat/webapps/manager/META-INF/context.xml
         chown -R mysql:mysql /usr/lib/jvm
         chown -R mysql:mysql /opt/tomcat
         gosu mysql sh /opt/tomcat/bin/startup.sh
   else
      cd /opt/tomcat/webapps/app1
      git pull app1 master
      chown -R mysql:mysql /opt/tomcat/webapps/app1
      gosu mysql sh /opt/tomcat/bin/startup.sh
   fi
}

mysql_initilizing() {
   if [[ ! -d "/var/lib/mysql/classicmodels" ]]; then
      #MySQL service start
         service mysql start
      #Change the authentication method for root
         mysql -u root -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
      #Database creation
         mysql -uroot -proot < /opt/tomcat/webapps/app1/sampledatabase.sql;
   else
      #MySQL service start
         service mysql start
   fi
}

apache_ant_initilizing() {
   if [[ -O "/opt/ant" && -G "/opt/ant" ]]; then
         chown -R mysql:mysql /opt/ant
   fi
}


if [[ "$1" == /bin/bash ]]; then
      apache_tomcat_initilizing
      mysql_initilizing
      apache_ant_initilizing
fi


      exec gosu mysql "$@"