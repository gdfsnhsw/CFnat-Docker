#!/bin/sh

# 检查配置文件是否存在，如果不存在，则使用默认配置
if [ ! -f /config/ips-v4.txt ]; then
    cp /app/ips-v4.txt /config/ips-v4.txt   
fi

if [ ! -f /config/ips-v6.txt ]; then
    cp /app/ips-v6.txt /config/ips-v6.txt
fi

if [ ! -f /config/locations.json ]; then
    cp /app/locations.json /config/locations.json
fi

if [ "${coloip}" = "true" ] && [ "${ips}" = "4" ] && [ ! -f /config/ip.csv ]; then
    /app/colo \
        -random "${random}" \
        -task "${task}"
    grep ms /config/ip.csv | awk -F. '{printf $1"."$2"."$3".0/24\n"}' | sort -u > /config/ips-v4.txt
fi

if [ "${coloip}" = "false" ] && [ "${ips}" = "4" ] && [ -f /config/ip.csv ]; then
    cp /app/ips-v4.txt /config/ips-v4.txt 
fi

# 执行主程序，直接调用 /config/cfnat
/app/cfnat \
    -colo "${colo}" \
    -port "${port}" \
    -delay "${delay}" \
    -ips "${ips}" \
    -addr "${addr}" \
    -code "${code}" \
    -domain "${domain}" \
    -ipnum "${ipnum}" \
    -num "${num}" \
    -random "${random}" \
    -task "${task}" \
    -tls "${tls}"
