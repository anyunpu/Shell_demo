#!/bin/bash

. scripts/public.sh

json_data="${1//null/}"
ukey=$(echo ${json_data} | jq -r .ukey | tr -d ' ')
cip=$(echo ${json_data} | jq -r .ip | tr -d ' ')
dtime=$(echo ${json_data} | jq -r .dtime)
md5=$(echo ${json_data} | jq -r .md5 | tr -d ' ')
logs_time=$(date "+%F %H:%M:%S")
if [ ! -n "${json_data}" ];then
  sendMsg 1 "\"Msg\":\"Json 消息体不能为空\""
fi
## echo ${json_data} > json.txt
if [ $(echo -n "${json_data}" | jq ". | length") -ne 4 ];then
  sendMsg 1 "\"Msg\":\"Json 消息体长度不符\""
fi
if [[ ! -n "${dtime}" ]] && [[ ! -n "${ukey}" ]] && [[ ! -n "${cip}" ]] && [[ ! -n "${md5}" ]];then
  sendMsg 1 "\"Msg\":\"Json 主体 'ukey,ip,dtime,md5' 值不能为空\""
fi

## Time check
if [ $(( $(date -d "${dtime}" "+%s") + 60 )) -lt $(date "+%s") ];then
  sendMsg 1 "\"Msg\":\"请求超时或时间系统错误\""
fi

## user check
userinfo=$(sql "select CONCAT('[',GROUP_CONCAT(JSON_OBJECT('ukey',ukey,'utype',utype,'endtime',endtime,'uenable',uenable,'daymax',daymax,'daycount',daycount)),']') as reluast from ${db_name}.ipuser where  ukey='${ukey}'" | grep ']')
echo "${userinfo}" | grep -q -w "${ukey}"
if [ $? -ne 0 ] ;then
  sendMsg 1 "\"Msg\":\"用户key ${ukey} 错误或不存在，请检查或注册\""
fi

if [ $(echo "${userinfo}" | jq -r .[0].uenable) -ne 1 ];then
  sendMsg 1 "\"Msg\":\"用户key ${ukey} 已被禁用，请联系管理员开通\""
fi

if [ $(echo "${userinfo}" | jq -r .[0].daymax) -lt $(echo "${userinfo}" | jq -r .[0].daycount) ];then
  sendMsg 1 "\"Msg\":\"用户key ${ukey} 日请求量已超，请明日再尝试\""
fi
endtime=$(echo "${userinfo}" | jq -r .[0].endtime)
if [ $(date -d "${endtime}" "+%s") -lt $(date "+%s") ];then
  sendMsg 1 "\"Msg\":\"用户key ${ukey} 已过有效期，请联系管理员处理\""
fi
if [ $(echo "${userinfo}" | jq -r .[0].daymax) -ne 999 ];then
  daycount=$(echo "${userinfo}" | jq -r .[0].daycount)
  n=$(( ${daycount} + 1 ))
  sql "update ${db_name}.ipuser set daycount='${n}' where ukey='${ukey}'"
fi

## Json 合法校验
if [ $(echo -n "${json_data}" | jq ". | length") -ne 4 ];then
  sendMsg 1 "\"Msg\":\"Json 长度不符\""
fi

## ip type check
iptype=''
if ! ip_checking "${cip}" > /dev/null 2>&1;then
  sendMsg 1 "\"Msg\":\"IP地址不合法\"" && exit 0
fi
jzstr=$(sql "select jzstr from  public_ip.juzi" | grep -vE '\-|jzstr' | shuf -n 1)
if echo -n "${dtime}${ukey}${cip}" | md5sum | grep -qw "${md5}" ;then
  if [[ -n "${ipv6_check}" && "${ipv6_check}" == 'yes' && -n  "${ipv6_url}" && "${iptype}" -eq 6 ]];then
    local_db "${cip}" 'ip6_api'
  else
    local_db "${cip}" 'api_type'
  fi
  ## 日志记录
  sql "insert into ${db_name}.userlogs values('${logs_time}','${ukey}','${json_data}','Good：正常')"
else
  sendMsg 1 "\"Msg\":\"MD5值不匹配\""
fi

## echo "$ip_json"
isp_name
ip_json="\"iptype\":\"IPv${iptype}\",\"ip\":\"${cip}\",\"isp\":\"${isp}\",\"ip_location\":\"${location}\",\"lat\":\"${lat}\",\"data_src\":\"${data_src}\",\"ver\":\"${version}\""
sendMsg 0 "${ip_json//null/},\"jzstr\":\"${jzstr}\""
