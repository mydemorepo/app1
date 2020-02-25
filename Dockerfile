#This is a base Image for app1
FROM ubuntu:18.04
MAINTAINER adamvasyliuta@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV PATH="${PATH}:/usr/lib/jvm/java-11-openjdk-amd64/bin"
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat
ENV CATALINA_BASE=/opt/tomcat

RUN   apt-get update \
   && apt-get install -y \
      curl \ 
      nano \
      git \
      gosu \
      openjdk-11-jdk \
   && { \
      echo "mysql-server-5.7 mysql-server/root_password password root" ; \
      echo "mysql-server-5.7 mysql-server/root_password_again password root" ; \
      } | debconf-set-selections \
   && apt-get install mysql-server-5.7 -y \
   && cd /tmp \
   && curl -O http://apache.ip-connect.vn.ua/tomcat/tomcat-9/v9.0.31/bin/apache-tomcat-9.0.31.tar.gz \
   && mkdir /opt/tomcat \
   && tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1 \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && echo "root:root" | chpasswd

EXPOSE 8080

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"] 

CMD ["/bin/bash"]
