#!/bin/bash

dir0=$(dirname $(cd $(dirname $0);pwd))
. ${dir0}/conf/config.conf
function sql(){
  mysql -h${db_host} -P${db_port} -u${db_user} -p${db_pass} -e "set names utf8;${1};" 
}
function print_log(){
  echo "$(date '+%F %H:%M:%S') $1"
}

function sendMsg(){
  dtime=$(date '+%F %H:%M:%S')
  if [ "$1" -eq 0 ];then
    st='Good'
  else
    st='Bad'
  fi
  if [ -n "${ukey}" ];then
    sql "insert into ${db_name}.userlogs values('${logs_time}','${ukey}','${json_data}','${st}')"
  fi
  echo "{\"Code\":\"${st}\","${2}",\"Datatime\":\"${dtime}\"}" && exit 0
}

## ip checking
function ip_checking(){
  if [[ "${1}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
    ipv4_arr=(${1//\./ })
    if [[ "${ipv4_arr[0]}" -le 255 && "${ipv4_arr[1]}" -le 255 && "${ipv4_arr[2]}" -le 255 && "${ipv4_arr[3]}" -le 255 ]];then
      iptype=4 && return 0
    else
      return 1
    fi
  elif [[ "${1}" =~  ^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$ ]];then
    iptype=6 && return 0
  else
    return 1
  fi
}

## gmap api
## 高德json返回：
## {"status":"1","info":"OK","infocode":"10000","country":"中国","province":"云南省","city":"迪庆藏族自治州","district":"香格里拉市","isp":"电信","location":"99.706463,27.826853","ip":"106.57.211.158"}
function gmap_api(){
  if [[ ! -n "${gmap_url}" || ! -n "${gmap_key}" ]];then
    sendMsg 1 "\"Msg\":\"高德地图api配置不完整，请检查 config.conf 文件\"" && exit 0
  fi
  api_json_data=$(curl -s "${gmap_url}${cip}&key=${gmap_key}")
  if [ $(echo "${api_json_data}" | jq -r .infocode) -ne 10000 ];then
    api_info="$(echo \"${api_json_daa}\" | jq -r .info)"
    sendMsg "\"Msg\":\"${api_info}\"" && exit 0
  fi
  lat="$(echo ${api_json_data} | jq -r .location)"
  isp="$(echo ${api_json_data} | jq -r .isp)"
  data_src='高德 api'
  location="$(echo ${api_json_data} | jq -r '.country,.province,.city,.district' | tr -d '\n')" 
}

## Baidu api
## 百度json返回实例
## {"address":"CN|云南省|迪庆藏族自治州|None|None|100|100","content":{"address":"云南省迪庆藏族自治州","address_detail":{"adcode":"533400","city":"迪庆藏族自治州","city_code":115,"district":"","province":"云南省","street":"","street_number":""},"point":{"x":"99.70952999","y":"27.82518468"}},"status":0}' 
function baidu_api(){
  if [[ ! -n "${baidu_url}" || ! -n "${baidu_ak}" || ! -n "${baidu_sk}" || ! -n "${baidu_coor}" ]];then
    sendMsg 1 "\"Msg\":\"百度地图api配置不完整，请检查 config.conf 文件\"" && exit 0
  fi
  sn=$(echo -n "%2Flocation%2Fip%3Fip%3D${1}%26coor%3D${baidu_coor}%26output%3Djson%26ak%3D${baidu_ak}${baidu_sk}" | md5sum | cut -d ' ' -f1)
  api_json_data=$(curl -s "${baidu_url}/location/ip?ip=${1}&coor=${baidu_coor}&output=json&ak=${baidu_ak}&sn=${sn}" | jq . | tr -d '\n' | tr -d ' ')
  if [ $(echo "${api_json_data}" | jq -r .status) -ne 0 ];then
    api_info="$(echo \"${api_json_data}\" | jq -r .message)"
    sendMsg 1 "\"Msg\":\"${api_info}\"" && exit 0
  fi
  lat="$(echo \"${api_json_data}\" | jq -r .content.point[] | tr '\n' ',')"
  lat="${lat%?}"
  isp=""
  data_src='百度 api'
  location="$(echo \"${api_json_data}\" | jq -r .content.address)"
}

## ipv6 api
## {"code":0,"daa":{' '"myip":"1.14.101.70","ip":{"query":"2409:8924:5266:116b:45f:8f2d:a32b:d92","sar":"","end":""},' '"locaion":"中国江苏省苏州市常熟市' '中国移动无线基站网络","counry":"中国江苏省苏州市常熟市","local":"中国移动无线基站网络"' '}}
function ip6_api(){
  if [ -n "${ipv6_api}" ];then 
    sendMsg 1 "\"Msg\":\"调用 ipv6_api 时 ipv6_api 变量不能为空\"" && exit 0
  fi
  api_json_data=$(curl -s "${ipv6_url}${cip}" | tr -d '\\t')
  lat='0.00000,0.00000'
  data_src='IPv6 api'
  isp="$(echo ${api_json_data} | jq -r .daa.local)"
  location="$(echo ${api_json_data} | jq -r .daa.counry)"
}

## checke api
function api_type(){
  if [[ -n "${gmap_url}" && -n "${gmap_key}" ]];then
    gmap_api "${1}"
  elif [[ -n "${baidu_url}" && -n "${baidu_ak}" && -n "${baidu_sk}" && -n "${baidu_coor}" ]];then
    baidu_api "${1}"
  else
    sendMsg 1 "\"Msg\":\"高德或者百度api不能为空(默认使用高德aip)\"" && exit 0
  fi
}

## local db checking
function local_db(){
  ip_int="${1}"
  if [ "${iptype}" -eq 4 ];then
    ip_int=$(convert_ip "${cip}")
  fi
  local_ip_json=$(sql "select CONCAT('[',GROUP_CONCAT(JSON_OBJECT('ip',ipv${iptype},'lat',lat,'location',local,'isp',isp)),']') as reluast from ${db_name}.ipv${iptype} where ipv${iptype}='${ip_int}'" | grep ']')
  if [ ! -n "${local_ip_json}" ];then
    intime="$(date '+%F %H:%M:%S')"
    "${2}" "${cip}"
    if echo ${api_json_data} | grep -q 'CN' || echo ${api_json_data} | grep -q '中国' ;then
      sql "insert into ${db_name}.ipv${iptype} values('${intime}','${ip_int}','${lat}','${location}','${isp}');"
    fi
  else
    lat=$(echo ${local_ip_json} | jq -r .[0].lat)
    isp=$(echo ${local_ip_json} | jq -r .[0].isp)
    data_src='IT小圈'
    location=$(echo ${local_ip_json} | jq -r .[0].location)
  fi
}

function isp_name(){
  if echo "${isp}" | grep -q '无线基站' ;then
    isp="${isp}"
  else
    if echo "${isp}" | grep -q '电信';then
      isp='中国电信'
    elif echo "${isp}" | grep -q '联通';then
      isp='中国联通'
    elif echo "${isp}" | grep -q '移动';then
      isp='中国移动'
    elif  echo "${isp}" | grep -q '阿里巴巴';then
      isp='阿里数据中心'
    elif  echo "${isp}" | grep -q 'tencent';then
      isp='腾讯数据中心'
    else
      isp='未知'
    fi
  fi
}

## ipv4 to int or int to ipv4
function convert_ip(){
  if expr "$1" '+' 1 >/dev/null 2>&1;then
    ## int to ipv4
    num="$1"
    ip_int="$((num >> 24)).$((num >> 16&0xff)).$((num >> 8&0xff)).$((num & 0xff))"
  elif [[ "${1}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
    ## ipv4 to int
    if [[ "${ipv4_arr[0]}" -le 255 && "${ipv4_arr[1]}" -le 255 && "${ipv4_arr[2]}" -le 255 && "${ipv4_arr[3]}" -le 255 ]];then
      ip_arr=($(echo "${1}" | tr '.' ' '))
      ip_int=$((${ip_arr[3]} + (${ip_arr[2]} << 8) + (${ip_arr[1]} << 16) + (${ip_arr[0]} << 24)))
    fi
  else
    print_log "${1} 不是合法IP"
  fi
  echo "${ip_int}"
}
