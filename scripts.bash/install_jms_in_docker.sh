#!/bin/bash

## 用于自动化安装 jumpserver
## 如果自己有 数据库、Redis ，则可以把 docker-compose 中对应的 mariadb 、 Redis 删除
## E-mail：deyun@deyun.fun
## Blog：https://deyun.fun
## By anYun Kunming 2023.12.20

## 相关配置
db_host='192.168.56.103'
db_port='3306'
db_user='jms'
db_pass='jms@123456'
db_name='jms'
db_root_pass='abcd@1234'

redis_host='192.168.56.103'
redis_port='6379'
redis_pass='123456'

jms_web_port='80'
jms_ssh_port='2222'
jms_dir='/data/jumpserver'

## 逻辑判断
if [ ! -d "${jms_dir}" ];then
  echo "目录 ${jms_dir} 不存在，请检查" && exit 2
fi
t=$(ls -A "${jms_dir}")
if [ ! -z "${t}" ];then
  echo "目录 ${jms_dir} 不为空，请更改目录或清空目录" && exit 2
fi

## 端口探测
if ! whic nc > /dev/null 2>&1 ;then
  echo "此脚本依赖 nc 工具，请安装后运行 ..." && exit 2
fi
if ! nc -vz ${db_host} ${db_port} > /dev/null 2>&1 ;then
  echo "数据库 ${db_host}:${db_port} 无法连接，请确认数据库信息 ..." && exit 2
fi

if ! nc -vz ${redis_host} ${redis_port} > /dev/null 2>&1 ;then
  echo "Redis ${redis_host}:${redis_port} 无法连接，请确认 Redis 信息 ..." && exit 2
fi

if nc -vz 127.0.0.1 ${jms_web_port} > /dev/null 2>&1 ;then
  echo "端口 ${jms_web_port} 已被占用，请检查..." && exit 2
fi

if nc -vz 127.0.0.1 ${jms_ssh_port} > /dev/null 2>&1 ;then
  echo "端口 ${jms_ssh_port} 已被占用，请检查..." && exit 2
fi

## 初始化 SQL 脚本
cat > ${jms_dir}/init.sql <<EOF
CREATE USER \`${db_user}\`@\`%\` IDENTIFIED BY '${db_pass}';
CREATE DATABASE ${db_name} DEFAULT CHARSET 'utf8mb4';
GRANT ALL ON ${db_name}.* TO \`${db_user}\`@\`%\` WITH GRANT OPTION;
flush privileges;
EOF

## 生成 token 和 key
. ~/.bashrc
if [ ! -n "${SECRET_KEY}" ]; then
  s_key=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50)
  echo "SECRET_KEY=${s_key}" >> ~/.bashrc
else
  s_key=$(echo $SECRET_KEY)
fi

if [ ! -n "${BOOTSTRAP_TOKEN}" ]; then
  b_token=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
  echo "BOOTSTRAP_TOKEN=${b_token}" >> ~/.bashrc
else
  b_token="$(echo ${BOOTSTRAP_TOKEN})"
fi

## 生成 docker-compose 文件
cat > ${jms_dir}/docker-compose.yml <<EOF
version: '3.9'
services:
    mariadb:
        command: '--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci'
        image: 'mariadb:latest'
        volumes:
            - '${jms_dir}/mariadb/data:/var/lib/mysql'
            - '${jms_dir}/init.sql:/docker-entrypoint-initdb.d/init.sql'
        ports:
            - '${db_port}:3306'
        environment:
            - MYSQL_ROOT_PASSWORD=${db_root_pass}
        restart: always
        container_name: mariadb
    redis:
        command: '--requirepass "${redis_pass}"'
        image: 'redis:latest'
        sysctls:
            - net.core.somaxconn=1024
        restart: always
        volumes:
            - '${jms_dir}/redis/data:/data'
        ports:
            - '${redis_port}:6379'
        container_name: redis
        tty: true
        stdin_open: true
    jms_all:
        image: 'jumpserver/jms_all:latest'
        environment:
            - REDIS_PASSWORD=${redis_pass}
            - REDIS_PORT=${redis_port}
            - REDIS_HOST=${redis_host}
            - DB_NAME=${db_name}
            - DB_PASSWORD=${db_pass}
            - DB_USER=${db_user}
            - DB_PORT=${db_port}
            - DB_HOST=${db_host}
            - BOOTSTRAP_TOKEN=${b_token}
            - SECRET_KEY=${s_key}
        ports:
            - '${jms_ssh_port}:2222'
            - '${jms_web_port}:80'
        volumes:
            - '${jms_dir}/jumpserver:/opt/jumpserver/data'
        restart: always
        hostname: jumpserver
        container_name: jms_all
EOF
cd ${jms_dir} && docker-compose up -d
