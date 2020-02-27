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
               chown -R mysql:mysql /usr/lib/jvm
               chown -R mysql:mysql /opt/tomcat
               sed '/</tomcat-users>/i "<user username="user1" password="pass1" roles="manager-script,manager-gui"/>"' /opt/tomcat/conf/tomcat-users.xml
               sed '/<user username="user1" password="pass1" roles="manager-script,manager-gui"/>/i "<role rolename="manager-gui"/>"' /opt/tomcat/conf/tomcat-users.xml
               sed '/<role rolename="manager-gui"/>/i "<role rolename="manager-script"/>"' /opt/tomcat/conf/tomcat-users.xml
               sed '/<Context antiResourceLocking="false" privileged="true" >/a "<!--"' /opt/tomcat/webapps/manager/META-INF/context.xml
               sed '/allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />/a "-->"' /opt/tomcat/webapps/manager/META-INF/context.xml
               cp /opt/tomcat/lib/catalina-ant.jar /opt/ant/lib/catalina-ant.jar
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
            #database creation
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
