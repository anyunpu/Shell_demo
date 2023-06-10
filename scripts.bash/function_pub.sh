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
      MYSQL_PWD="${db_pass}" && mysql -h${db_host} -P${db_port} -u${db_user} -e "set names utf8;${1};"
    else
      echo "Command 'mysql' not found" && return 1
    fi
  else
    echo "db_host db_port db_user db_pass can't empty" && return 1
  fi
}
function print_log(){
  echo "$(date '+%F %H:%M:%S') $1"
}

## ip 格式检验
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
    echo "${1} 不是一个有效的IP" && return 1
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
    print_log "${1} 不是合法IPv4" && return 1
  fi
  echo "${ip_int}"
}

## Make password
function mkpassword(){
  ## 密码长度
  pass_len="${1}"
  pass_type="${2}"
  ## 特殊符号
  sig_strs='\! \# \$ \% \^ \& \* \( \) \- _ \= \; \, \? \/ \< \> \.'
  a=0
  pass_str=''
  if [[ ! -n "${pass_len}" || "${pass_len}" -lt 6 ]];then
    echo "密码长度必须大于6个字符才有意义" && return 1
  fi
  if [[ ! -n "${pass_type}" || "${pass_type}" -lt "0" || "${pass_type}" -gt "11" ]];then
    cat << EOF
密码类型参数只能是 0 - 8
  0 表示 小写 + 大写 + 数字 + 字符
  1 小写 + 大写
  2 小写 + 数字
  3 小写 + 字符
  4 大写+ 数字
  5 大写+ 字符
  6 小写 + 大写 + 数字
  7 大写 + 数字 + 字符
  8 纯小写
  9 纯大写
  10 纯数字
  11 纯字符
EOF
  exit 0
  fi
  function daxie_zm(){
    pass_str=("${pass_str[*]}" $(echo {A..Z} | tr ' ' '\n' | shuf | shuf -n 1))
  }
  function xiaoxie_zm(){
    pass_str=("${pass_str[*]}" $(echo {a..z} | tr ' ' '\n' | shuf | shuf -n 1))
  }
  function shuzi(){
    pass_str=(${pass_str[*]} $(echo {0..9} | tr ' ' '\n' | shuf | shuf -n 1))
  }
  function zifu(){
    pass_str=(${pass_str[*]} $(echo "${sig_strs}" | tr ' ' '\n' | shuf | shuf -n 1))
  }
  case "${pass_type}" in 
    "0")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	xiaoxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	daxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	shuzi
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
        zifu	
      done
      ;;
    "1")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	xiaoxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	daxie_zm
      done
      ;;
    "2")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	xiaoxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
        shuzi	
      done
      ;;
    "3")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	xiaoxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
        zifu	
      done
      ;;
    "4")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	daxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
        shuzi	
      done
      ;;
    "5")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	daxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
        zifu	
      done
      ;;
    "6")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	xiaoxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	daxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	shuzi
      done
      ;;
    "7")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	daxie_zm
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	shuzi
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
        zifu	
      done
      ;;
    "8")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
          break
        fi
        xiaoxie_zm	
      done
      ;;
    "9")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
          break
        fi
        daxie_zm	
      done
      ;;
    "10")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
          break
        fi
        shuzi	
      done
      ;;
    "11")
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
          break
        fi
        zifu
      done
      ;;
    *)
      for ((i=0;i<"${pass_len}";i++))
      do
        if [ "${#pass_str[*]}" -gt "${pass_len}" ];then
	  break
	fi
	xiaoxie_zm
      done
      ;;
    esac
  echo "${pass_str[*]}" | tr ' ' '\n' | shuf | tr -d '\n' | tr -d '\\'
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
    curl -s -X POST H 'Content-Type: application/json' "https://oapi.dingtalk.com/robot/send?access_token=${2}&timestmap=${timestamp}&sign=${sign_url_encode}" \
    -d "${4}"
  else
    echo "参数个数或形式不合规" && return 1
  fi
}
