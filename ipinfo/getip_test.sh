#!/bin/bash
clear
ukey='655937c56f1aef933f01d3afdf7d15e4b810c718caad9009ad39cc546d25c836'
dtime="$(date '+%F %H:%M:%S')"
md5_str=$(echo -n "${dtime}${ukey}" | md5sum | cut -d' ' -f1)
json_data="{\"dtime\":\"${dtime}\",\"ukey\":\"${ukey}\",\"ip\":\"${1}\",\"md5\":\"${md5_str}\"}"

## 接口测试
## curl -s -H "Content-Type: application/json;charset=UTF-8" -X POST -d "$json_data" 'https://ip.iquan.fun/getip.php' | jq .

## main_check.sh 测试
bash scripts/main_check.sh "${json_data}" | jq .

echo -e "请求Json如下"
echo "${json_data}" | jq .
