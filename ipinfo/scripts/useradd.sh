#!/bin/bash

. scripts/public.sh

json_data="${1}"
uemail=$(echo "${json_data}" | jq -r .uemail | tr -d ' ')
web_url=$(echo "${json_data}" | jq -r .web_url | tr -d ' ')
utype=$(echo "${json_data}" | jq -r .utype | tr -d ' ')
## echo "${json_data}" > json.txt
if [[ ! -n "${uemail}" || ! -n "${web_url}" ]];then
  sendMsg 1 "邮箱地址和网址必填，不可为空"
fi

if [ "${utype}" -ne 1 ];then
  sendMsg 1 "请选择账户类型\n目前仅支持测试类型申请"
fi

if sql "select * from ${db_name}.ipuser where uemail='${uemail}' or website='${web_url}'" | grep -q -v '+';then
  sendMsg 1 "当前站点${web_url} 或 邮箱${uemail}\n已被注册，一个网站或邮箱只能注册一次"
fi

## Website check
if ! curl -s "${web_url}" > /dev/null 2>&1 ;then
  sendMsg 1 "URL ${web_url} 测通失败"
fi
if echo "${web_url}" | grep -qE '^https://' ;then
  sendMsg 1 "URL ${web_url} 不是一个有效的https站点"
fi

## create user json data
dtime=$(date "+%F %H:%M:%S")
ukey=$(echo -n "${web_url}${dtime}${uemail}" | sha256sum | awk '{print $1}')
user_json_data="{\"dtime\":\"${dtime}\",\"ukey\":\"${ukey}\",\"uemail\":\"${uemail}\",\"web_url\":\"${web_url}\",\"utype\":\"${utype}\"}"
echo "${user_json_data}" > temp/${ukey}.json
echo "${ukey}" > temp/${ukey}.txt

## send email checking
user_check_url="https://ip.iquan.fun/usercheck.php?ukey=${ukey}&dtime=${dtime}"
fpath="temp/${ukey}.txt"
ukey=''
title='IT小圈注册邮箱验证：注册邮箱需要验证通过才能使用对应的接口哦'
contents="站长您好：<br><br>感谢您注册使用<a target=\"_blank\" href=\"https://ip.iquan.fun\">IT小圈</a> IP接口，请在<font color=\"red\"> 15分钟 内 </font>完成邮箱验证：<br><br>1. 请将附件 ${ukey}.txt 上传到您网站的根目录下 ${web_url}<br><br>2. 然后点击下方链接进行邮箱验证 ↓↓<br><a target=\"_blank\" href=\"${user_check_url}\">${user_check_url}</a><br><br><br><br>By IT小圈<br><br><br><br><a target=\"_blank\" href=\"https://deyun.fun\">流年小站</a><br><a target=\"_blank\" href=\"https://iquan.fun\">IT小圈</a>"
php tools/PHPMailer/sendmail.php "${uemail}" "${title}" "${contents}" "${fpath}"
sendMsg 0 "\"Msg\":\"确认邮件已发送至邮箱 ${uemail}\n请及时前往确认(24H 内有效)\""
