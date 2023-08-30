#!/bin/bash
ukey='643b4682ddc002b6aec7d1780d43aacd4a57187'
dtime="$(date '+%F %H:%M:%S')"
md5_str=$(echo -n "${dtime}${ukey}${1}" | md5sum | cut -d' ' -f1)
json_data=$(echo '{}' | jq -c ".dtime=\"${dtime}\"|.ukey=\"${ukey}\"|.ip=\"${1}\"|.md5=\"${md5_str}\"")
curl -s -H "Content-Type: application/json;charset=UTF-8" -X POST -d "$json_data" 'https://ip.iquan.fun/getip.php'
