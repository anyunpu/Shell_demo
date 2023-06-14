#!/bin/bash

## 脚本会根据 config.conf 进行数据库初始化
## 请确保数据库名称不与数据库中的冲突
## 代码由 anYun 本地测试通过
## By  anYun  Kunming  2023.01.30
## @IT小圈  https://ip.iquan.fun  https://iquan.fun  https://deyun.fun
w_dir=$(cd $(dirname $0);pwd)
. scripts/public.sh

if [ "$USER" != 'root' ];then
  print_log "请使用 root 运行脚本" && exit 0
fi
if [ ! -f conf/config.conf ];then
  print_log "配置文件 config.conf 不存在"
  exit 0
fi
. conf/config.conf
if sql "SHOW DATABASES;" > /dev/null 2>&1 ;then
  if [ ! -f ./default.sql.0 ];then
    print_log "数据库初始化脚本不存在 default.sql.0" && exit 0
  fi
  cp ./default.sql.0 ./default.sql
  sed -i "s/public_ip/${db_name}/g" ./default.sql
  OLDIFS="$IFS"
  IFS=$'\n'
  print_log "正在初始化数据库"
  for i in $(grep -vE '^#' ./default.sql)
  do
    if sql "${i}" >/dev/null 2>&1;then
      print_log "SQL 语句 '${i}' Success"
    else
      print_log "SQL 语句 '${i}' Failed"
    fi
  done
  print_log "数据初始化完成"
  IFS="$OLDIFS"
  if [ "${create_tmpuser}" == 'yes' ];then
    test_key=$(ip  a show | sha256sum | awk '{print $1}')
    sql "insert into public_ip.ipuser value('2023-01-29 16:50:25','3','${test_key}','1','2099-01-01 00:00:00','deyun@deyun.fun','https://deyun.fun','999','0');"
    echo "测试key为 ${test_key}"
    sed -i "s/ukey=655937c56f1aef933f01d3afdf7d15e4b810c718caad9009ad39cc546d25c836/key=${test_key}" getip_test.sh
    sed -i "s/655937c56f1aef933f01d3afdf7d15e4b810c718caad9009ad39cc546d25c836/key=${test_key}" index.php
  fi
else
  print_log "数据库连接失败，请检查配置"
  echo -e "db_host=${db_host}\ndb_port=${db_port}\ndb_user=${db_user}\ndb_pass=${db_pass}" && exit 0 
fi

## 环境检查
## if php -v >/dev/null 2>&1 ;then
##   print_log "需要依赖PHP，当前环境PHP不存在" && exit 0
## fi
if which jq > /dev/null 2>&1 ;then
  cp tools/jq /usr/bin && chmod +x /usr/bin/jq
fi

##  cron
if [ ! -n ${cron_min} ];then
  cron_min=7
fi
if crontab -l | grep -q "${w_dir}/scripts/cron.sh" ;then
  w_dir0=$(echo -n ${w_dir} | tr '/' '\\/')
  sed -i "/${w_dir}\/cron.sh/d" /var/spool/cron/root
fi
echo "*/${cron_min} * * * * bash ${w_dir}/scripts/cron.sh >/dev/null 2>&1" >>  /var/spool/cron/root
systemctl restart crond

## mail config
sed -i "s/deyun@deyun.fun/${mail_addr}/g" tools/PHPMailer/sendmail.php
sed -i "s/smtp.exmail.qq.com/${mail_host}/g" tools/PHPMailer/sendmail.php
sed -i "s/Ab123456/${mail_pass}/g" tools/PHPMailer/sendmail.php
sed -i "s/456/${mail_port}/g" tools/PHPMailer/sendmail.php
