#!/bin/bash

dir=$(cd $(dirname $0);pwd)
. ${dir}/scripts/public.sh

function late_user(){
  dtime=$(date "+%F %H:%M:%S")
  sql "delete from ${db_name}.ipuser where endtime < '${dtime}' and daymax<>'999';" > /dev/null 2>&1
}

function re_daycount(){
  sql "update ${db_name}.ipuser set `daycount`='0';" > /dev/null 2>&1
}

function del_oldfile(){
  find "${dir}/temp" -mmin +1440 -name *.json -exec rm -rf {} \;
}

run_time=$(date "+%s")

if [[ "${run_time}" -gt $(date -d "$(date '+%F') 00:00:00" '+%s') ]] &&  [[ "${run_time}" -lt $(date -d "$(date '+%F') 00:08:00" '+%s') ]];then
  re_daycount
fi
late_user
del_oldfile
