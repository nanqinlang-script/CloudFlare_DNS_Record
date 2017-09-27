#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: CloudFlare_DNSRecord_Modifier
# Version: 1.0
# Author: nanqinlang
# Blog:   https://www.nanqinlang.com
# Github: https://github.com/nanqinlang
#======================================${Font_suffix}"

check_root(){
	if [[ "`id -u`" = "0" ]]; then
	echo -e "${Info} user is root"
	else echo -e "${Error} must be root user" && exit 1
	fi
}

directory(){
	[[ ! -d /home/CloudflareDNS ]] && mkdir -p /home/CloudflareDNS
	cd /home/CloudflareDNS
}

install_curl(){
	apt-get install curl ca-certificates -y
}

email=`cat config.conf|grep "email"|awk -F "=" '{print $NF}'`
zone_id=`cat config.conf|grep "zone_id"|awk -F "=" '{print $NF}'`
api_key=`cat config.conf|grep "api_key"|awk -F "=" '{print $NF}'`

domain=`cat config.conf|grep "domain"|awk -F "=" '{print $NF}'`
required_ip=`cat config.conf|grep "required_ip"|awk -F "=" '{print $NF}'`
dynamic_ip=`wget -qO - http://myip.ipip.net/ | awk '{print $2}' | tr "：" " " | awk '{print $2}'`
ttl=`cat config.conf|grep "ttl"|awk -F "=" '{print $NF}'`
id=`cat config.conf|grep "id"|awk -F "=" '{print $NF}'`


create_record(){
curl -X POST "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
	 -H "X-Auth-Email: ${email}" \
	 -H "X-Auth-Key: ${api_key}" \
	 -H "Content-Type: application/json" \
	 --data '{"type":"A","name":"${domain}","content":"${ip}","ttl":${ttl},"proxied":false}'
}


get_record_id(){
curl -X GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
     -H "X-Auth-Email: ${email}" \
     -H "X-Auth-Key: ${api_key}" \
     -H "Content-Type: application/json"
}


update_record(){
curl -X PUT "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${id}" \
     -H "X-Auth-Email: ${email}" \
     -H "X-Auth-Key: ${api_key}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"${domain}","content":"${ip}","ttl":${ttl},"proxied":false}'
}

	check_root
	directory

	echo -e "${Info} are you want to use DynamicDNS ? "
	stty erase '^H' && read -p "(select: 1.yes 2.no):" Dynamic
	[[ -z "${Dynamic}" || "${Dynamic}" != "1" || "${Dynamic}" != "2" ]] && echo -e "${Error} no or bad choose, exiting ..." && exit 1
	[[ "${Dynamic}" = "1" ]] && ip="${dynamic_ip}"
	[[ "${Dynamic}" = "2" ]] && ip="${required_ip}"

	echo -e "${Info} select required service:\n1.get domain records details\n2.modify domain record\n3.create new domain record\n4.install essence(curl)"
	stty erase '^H' && read -p "(defaultly cancel):" Service
	[[ -z "${Service}" || "${Service}" != "1" || "${Service}" != "2" || "${Service}" != "3" || "${Service}" != "4" ]] && echo -e "${Error} no or bad choose, exiting ..." && exit 1
	[[ "${Service}" = "1" ]] && get_record_id
	[[ "${Service}" = "2" ]] && update_record
	[[ "${Service}" = "3" ]] && create_record
	[[ "${Service}" = "4" ]] && install_curl