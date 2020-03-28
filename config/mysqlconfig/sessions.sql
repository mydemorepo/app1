create database tomcatsessions;

use tomcatsessions;

create table tomcat_session_data (
session_id varchar(100) not null primary key,
valid char(1) not null,
maxinactive int not null,
last_access bigint not null,
application_name varchar(255),
session_data mediumblob
);

GRANT ALL PRIVILEGES ON tomcatsessions.* TO user1@localhost IDENTIFIED BY 'pass1';

GRANT FILE on *.* TO user1@localhost;