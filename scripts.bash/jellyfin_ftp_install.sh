#!/bin/bash

## 用于基于docker 部署 jellyfin 家庭媒体服务
## 媒体管理使用 vsftp 管理
## By anYun V1.2 2023.11.09 Kunming

## 博客：https://deyun.fun
## 知识库：https://iquan.fun
## E-mail：deyun@deyun.fun

## 定义目录
w_dir='/data' # jellyfin 工作目录
jfin_port='' #  jellyfin 访问端口
ftp_user='jellyfin'
ftp_pass='Jfin@123'

if [[  -n "${jfin_port}" && ! `ss -ntpl | grep -qw "${jfin_port}"` ]] ;then
  echo "自定义端口 ${jfin_port} 已被使用，请更换端口" && exit 1
else
  jfin_port='8096'
fi

if ! $(whereis docker > /dev/null 2>&1) ;then
  echo "docker command not found,please install it" && exit 1
fi

if ! $(whereis docker-compose > /dev/null 2>&1) ;then
  echo "docker-compose command not found,please install it" && exit 1
fi

if [[ ! -d "${w_dir}" || ! -n "${w_dir}" ]];then
  echo "${w_dir} not exist or is empty" && exit 1
fi
cd "${w_dir}" && mkdir -p jellyfin jellyfin/config jellyfin/cache jellyfin/font jellyfin/ftp/jellyfin
work_dir=$(pwd)
ln -s ${work_dir}/jellyfin/ftp/jellyfin ${work_dir}/jellyfin/media
cd jellyfin
## jellyfin docker-compose

cat >> docker-compose.yml << EOF
version: '3'
services:
  jellyfin:
    image: nyanmisaka/jellyfin:latest
    container_name: jellyfin
    volumes:
      - ${work_dir}/config:/config  # 配置
      - ${work_dir}/cache:/cache    # 缓存
      - ${work_dir}/media:/media    # 媒体库
      - ${work_dir}/font:/font      # 字体
    devices:
      - /dev/dri:/dev/dri  # 核显
    group_add:
      - '998'  # render组
    ports:
      - "${jfin_port}:8096"
    restart: unless-stopped

  # vsftp
  vsftp:
    image: markhobson/vsftpd
    container_name: vsftp
    volumes:
      - ${work_dir}/jellyfin/ftp:/home/vsftpd
    environment:
      - FTP_USER=${ftp_user}
      - FTP_PASS=${ftp_pass}
      - PASV_MIN_PORT=21100
      - PASV_MAX_PORT=21110
    ports:
      - "20:20"
      - "21:21"
      - "21100-21110:21100-21110"
    restart: unless-stopped
EOF

docker-compose up -d && clear
echo "======= FTP info ======="
echo -e "ftp_user: ${ftp_user}\tftp_pass: ${ftp_pass}\n"
echo "======= Jellyfin info ======="
echo -e "Web Port：${jfin_port}\nDirectory：\n$(tree -d -L 1 ${work_dir}/jellyfin)"