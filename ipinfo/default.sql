## 如果数据库存在则删除
## 并重新创建数据库
DROP DATABASE IF EXISTS public_ip;
CREATE DATABASE IF NOT EXISTS public_ip CHARACTER SET = utf8mb4;

## 开始创建数据库
CREATE TABLE public_ip.ipv4(`uptime` datetime NOT NULL,`ipv4` BIGINT(10) NOT NULL UNIQUE,`lat` VARCHAR(20),`local` VARCHAR(255),`isp` VARCHAR(20));
CREATE TABLE public_ip.ipv6(`uptime` datetime NOT NULL,`ipv6` VARCHAR(255) NOT NULL UNIQUE,`lat` VARCHAR(20),`local` VARCHAR(255),`isp` VARCHAR(20));
CREATE TABLE public_ip.ipuser(`ctime` datetime NOT NULL,`utype` INT(1) NOT NULL,`ukey` VARCHAR(64) NOT NULL UNIQUE,`uenable` INT(1) NOT NULL,`endtime` datetime,`uemail` VARCHAR(255) NOT NULL,`website` VARCHAR(255) NOT NULL,`daymax` INT(20) NOT NULL,`daycount` INT(21) NOT NULL);
CREATE TABLE public_ip.userlogs(`getime` DATETIME NOT NULL,`ukey` VARCHAR(64) NOT NULL,`getjson` VARCHAR(255) NOT NULL,`msg` VARCHAR(255));
## 随机句子
CREATE TABLE public_ip.juzi(`ctime` datetime NOT NULL,`jzstr` VARCHAR(255) NOT NULL,`author` VARCHAR(255));
