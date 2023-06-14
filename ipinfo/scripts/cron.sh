#!/bin/bash

dname=$(cd $(dirname $0);pwd)
. ${dname}/public.sh
function late_user(){
  dtime=$(date "+%F %H:%M:%S")
  sql "delete from ${db_name}.ipuser where endtime < '${dtime}';" > /dev/null 2>&1
}

function re_daycount(){
  sql "update ${db_name}.ipuser set `daycount`='0';" > /dev/null 2>&1
}

function del_oldfile(){
  find "${dir0}/temp" -mmin +1440 -type f -exec rm -rf {} \;
}

## 日志清理
function clean_logs(){
  nowtime=$(date "+%H:%M:%S")
  nowdate=$(date "+%F")
  bdate=$(date -d "${nowdate} 30 days ago" "+%F")
  sql "delete from ${db_name}.userlogs where getime < '${bdate} ${nowtime}' " > /dev/null 2>&1
}
run_time=$(date "+%s")

if [[ "${run_time}" -gt $(date -d "$(date '+%F') 00:00:00" '+%s') && "${run_time}" -lt $(date -d "$(date '+%F') 00:08:00" '+%s') ]];then
  re_daycount
fi
late_user
del_oldfile
clean_logs
