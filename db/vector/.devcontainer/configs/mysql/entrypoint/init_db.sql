
-- # Set 'secure_file_priv=/mysql_files' must be set in my.cnf file [mysqld] property
-- # create databases
CREATE DATABASE IF NOT EXISTS `milvus_meta`;
CREATE DATABASE IF NOT EXISTS `my_app_meta`;
-- # create users and grant privileges
CREATE USER IF NOT EXISTS 'alpha'@'%' IDENTIFIED BY 'developer';
CREATE USER IF NOT EXISTS 'beta'@'%' IDENTIFIED BY 'developer';
CREATE USER IF NOT EXISTS 'gamma'@'%' IDENTIFIED BY 'developer';
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'developer';
CREATE USER IF NOT EXISTS 'milvus'@'%' IDENTIFIED BY 'developer';
GRANT ALL PRIVILEGES ON *.* TO 'alpha'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'beta'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'gamma'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'milvus'@'%';
