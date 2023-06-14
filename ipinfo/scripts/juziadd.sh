#!/bin/bash
. scripts/public.sh

## Replace words
rep_old=( '，' '“' '（' '）' )
rep_new=( ',' '"' '(' ')' )
del_word=( 'null' ' ' )
jzstr="${1}"
for ((i=0;i<${#rep_old[*]};i++))
do
  jzstr=${jzstr/"${rep_old[$i]}"/"${rep_new[$i]}"}
done

for ((i=0;i<${#del_word[*]};i++))
do
  jzstr=${jzstr//"${del_word[$i]}"/}
done
if [ ! -n  "${jzstr}" ];then
  sendMsg 1 "\"Msg\":\"句子不能为空\"" | jq .
  exit 0
fi
if [ ! -n  "${jzstr}" ];then
  sendMsg 1 "\"Msg\":\"出处不可为空\"" | jq .
  exit 0
fi
sql "insert public_ip.juzi values(now(),'${jzstr}','${2}')" && sendMsg 0 "\"Msg\":\"句子 '${jzstr}' 录入成功\"" | jq .
