#!/bin/bash

## 经常写shell脚本的人都知道
## 经常要自己写一些需求，但逻辑比较不好搞
## 这个脚本本意是集一些常用的、复杂的function
## 让每个有需求的人都可以直接调用
## 同时脚本是开源方式，也可以完善自己的deamo
## By anYun Kunming 2023.04.22
## deyun@deyun.fun  https://deyun.fun  https://iquan.fun

## 数据库操作
function sql(){
  if [[ ! -n "${db_host}" || ! -n "${db_host}" && ! -n "${db_user}" || ! -n "${db_port}" || ! -n "${db_pass}" ]];then
    if which mysql > /dev/null 2>&1 ;then
      MYSQL_PWD="${db_pass}" && mysql -h${db_host} -P${db_port} -u${db_user} -p${MYSQL_PWD} -e "set names utf8;${1};"
    else
      echo "Command 'mysql' not found" && return 1
    fi
  else
    echo "db_host db_port db_user db_pass can't empty" && return 1
  fi
}

## print logs
function print_log(){
  echo "$(date '+%F %H:%M:%S') $1"
}

## ip 格式检验
function ip_checking(){
  if [[ "${1}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
    ipv4_arr=(${1//\./ })
    if [[ "${ipv4_arr[0]}" -le 255 && "${ipv4_arr[1]}" -le 255 && "${ipv4_arr[2]}" -le 255 && "${ipv4_arr[3]}" -le 255 ]];then
      iptype=4 && echo "$1 is a valid IPv4" && return 0
    else
      echo "$1 Not a valid IPv4" && return 1
    fi
  elif [[ "${1}" =~  ^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$ ]];then
    iptype=6 && echo "$1 Not a valid IPv6" && return 0
  else
    echo "${1} 不是一个有效的IP" && return 1
  fi
}

## ipv4 to int or int to ipv4
function conv_ip(){
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
    echo  "${1} Not a valid IPv4" && return 1
  fi
  echo "${ip_int}"
}

## Make password
function new_pass(){
  if [[ -n "${1}" && "${1}" -gt 0 ]] && expr "${1}" '+' 1 >/dev/null 2>&1 ;then
    openssl rand -base64 "${1}"
  else
    echo "密码长度必须是大于0的整数" && return 1
  fi
}

## encode url
function url_encode(){
  encode_str=''
  up_type=''
  if [[ -n "${2}" && "${1}" == '-A' ]];then
    up_type='-u'
    encode_str="${2}"
  elif [ -n "${2}" ];then
    encode_str="${2}"
  else
    encode_str="${1}"
  fi

  if [ -n "${encode_str}" ];then
    if [ -n "${up_type}" ];then
      echo -n "${encode_str}" | xxd "${up_type}" -plain | sed 's/\(..\)/%\1/g'
    else
      echo -n "${encode_str}" | xxd -plain | sed 's/\(..\)/%\1/g'
    fi
  else
    echo "The encode strings can't empty" && return 1
  fi
}

## decode url
function url_decode(){
  if [ -n "${1}" ];then
    printf $(echo -n "${1}" | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')
  else
    echo "The decode strings can't empty" && return 1
  fi
}

## Dingtalk robot
function dingtk_robot(){
  function dtk_url_encode() {
    echo -n "${1}" | od -t d1 | awk '{for (i = 2; i <= NF; i++) {printf(($i>=48 && $i<=57) || ($i>=65 &&$i<=90) || ($i>=97 && $i<=122) ||$i==45 || $i==46 || $i==95 || $i==126 ?"%c" : "%%%02X", $i)}}'
  }  
  if [[ "${1}" == '-w' && $# -eq 3 ]];then
    ## key words
    curl -s -X POST H 'Content-Type: application/json' "https://oapi.dingtalk.com/robot/send?access_token=${2}" \
    -d "${3}"
  elif [[ "${1}" == '-s' && $# -eq 4 ]];then
    ## sign
    timestamp=$(date '+%s%3N')
    sign=$(echo -ne "${timestamp}\n${3}" | openssl dgst -sha256 -hmac "${3}" --binary | base64)
    sign_url_encode=$(dtk_url_encode "${sign}")
    curl -s -X POST -H 'Content-Type: application/json' "https://oapi.dingtalk.com/robot/send?access_token=${2}&timestamp=${timestamp}&sign=${sign_url_encode}" \
    -d "${4}"
  else
    echo -e "参数个数或形式不合规\n关键词方式：dingtk_robot -w 'access_token' 'messge_str'\n加签方式：dingtk_robot -s 'access_token' 'secret' 'messge_str'" && return 1
  fi
}

## date diff
function date_diff(){
  if [[ -n "${1}" && -n "${2}" ]];then
    if [[ "${1}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ && "${2}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "${1}" +%s > /dev/null 2>&1 && date -d "${2}" +%s > /dev/null 2>&1;then
      a=$(date -d "${1}" '+%s')
      b=$(date -d "${2}" '+%s')
      echo $(( (${b} - ${a}) / 86400))
    elif date -d "${1}" +%s >/dev/null 2>&1 && echo "${2}" | grep -qE '^\-|^\+' && expr $(echo "${2}" | tr -d '-' | tr -d '+') '+' 1 > /dev/null 2>&1;then 
      if echo "${2}" | grep -qE '^-';then
	 befor_day=$(echo "${2}" | tr -d '-')
         echo $(date -d "${1} ${befor_day} days ago" '+%F')
      else
	 after_day=$(echo "${2}" | tr -d '+')
         echo $(date -d "${1} ${after_day} days" '+%F')
      fi
    else
      echo "参数个数或形式不合规" && return 1
    fi
  else
    echo "参数个数或形式不合规" && return 1
  fi
}

## Dir empty check
function em_dir(){
  if [ -d "$1" ];then
    if [ -n "$(ls -A $1)" ];then
      ## Not Empty
      echo "\"$1\" is not Empty" && return 1
    else
      ## Empty
      echo "\"$1\" is Empty" && return 0
    fi
  else
    echo "$1 not a Directory" && return 1
  fi
}

## str to unicode
function str2unicode(){
  ## agv_1 need to unicode str
  ## avg_2 reslut type, 0 => a-z , 1 => A-Z
  ## default t_type=0
  t_str="${1}"
  if [ -n "${2}" ];then
    t_type=${2}
  else
    t_type=0
  fi
  t_str_unc=''
  if [ -n "${t_str}" ];then
    for (( i = 0 ; i < ${#t_str} ; i++ ))
    do
      a="${t_str:$i:1}"
      if [ "${a}" == '\' ];then
        i=$(( $i + 1 ))
        b="${a}${t_str:$i:1}"
        t_str_unc+=$(printf '\\u%04x' "$(printf \"${b}\")")
      else
        t_str_unc+=$(printf '\\u%04x' "'${a}'")
      fi
    done
  fi

  if [ ${t_type} -eq 1 ];then
    t_str_unc="$(echo ${t_str_unc} | tr 'a-z' 'A-Z')"
  fi
  echo -n "${t_str_unc}"
}
