#!/bin/bash

. scripts/public.sh

ukey="${1}"
dtime="${2}"

if [[ ! -n "${ukey}" ]] || [[ ! -n "${dtime}" ]];then
  sendMsg 1 "\"Msg\":\"链接无效，请注册后尝试\""
fi

if [ ! -f "temp/${ukey}.json" ];then
  sendMsg 1 "\"Msg\":\"注册信息不存在，请重新注册\""
fi

if [ $(( $( date -d "${dtime}" +%s) + 900 )) -lt $(date +%s) ];then
  rm -f "temp/${ukey}.json" " temp/${ukey}.txt" && sendMsg 1 "\"Msg\":\"验证链接已失效，请重新注册\""
fi
ctime=$(date "+%F %H:%M:%S")
tday=$(date  "+%F")
uemail=$(cat "temp/${ukey}.json" | jq -r .uemail)
web_url=$(cat "temp/${ukey}.json" | jq -r .web_url)
utype=$(cat "temp/${ukey}.json" | jq -r .utype)
check_file="${web_url}/${ukey}.txt"
curl -s "${check_file}" | grep -qw "${ukey}"
if [ $? -ne 0 ];then
  sendMsg 1 "\"Msg\":\"验证文件 [ ${check_file} ] 不存在，请上传后再尝试\""
fi
case "${utype}" in
  1)
    daymax=100
    late_date=$(date -d "${tday} 30 days" "+%F")
    utype=3
    uenable=1
  ;;
  2)
    daymax=500
    late_date=$(date -d "${tday} 90 days" "+%F")
    utype=2
    uenable=2
  ;;
  *)
    daymax=0
    late_date=$(date -d "${tday} 1 days" "+%F")
esac  
t=$(date "+%H:%M:%S")
sql "insert into public_ip.ipuser value('${ctime}','${utype}','${ukey}','${uenable}','${late_date} ${t}','${uemail}','${web_url}','${daymax}','0');" > /dev/null 2>&1

## send mail msg
title='恭喜：邮箱验证成功'
contents="站长您好：<br><br>感谢您注册使用，您的key信息如下：<br><br>用户key: ${ukey}<br>用户类型：接口测试<br>日最大请求：${daymax}/日<br>有效期至：${late_date}<br>接口URL：https://ip.iquan.fun/getip.php<br>请求Json示例：{\"dtime\":\"2023-01-30 01:15:33\",\"ukey\":\"${ukey}\",\"ip\":\"240e:34c:80:9340:2071:489f:f73c:1d0c\",\"md5\":\"05f3dc8a944412ff7d5d692d35924548\"}<br>更多说明请参考 <a target=\"_blank\" href=\"https://ip.iquan.fun\">IT小圈IP接口文档</a><br>
<br><br><hr /><br>By IT小圈<br><br><br><br><a target=\"_blank\" href=\"https://deyun.fun\">流年小站</a><br><a target=\"_blank\" href=\"https://iquan.fun\">IT小圈</a>"
php tools/PHPMailer/sendmail.php "${uemail}" "${title}" "${contents}" > /dev/null 2>&1
rm -f "temp/${ukey}.json" " temp/${ukey}.txt" & sendMsg 0 "\"Msg\":\"用户验证成功详情请查阅邮件信息\""
