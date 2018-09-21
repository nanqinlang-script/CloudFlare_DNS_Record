#!/bin/bash
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#=======================================
# Project: CloudFlare_DDNS_Setter
# Version: 1.0
# Author: nanqinlang
# Blog:   https://sometimesnaive.org
# Github: https://github.com/nanqinlang
#=======================================
# Secondary editing by dovela
# Version: 1.0
#=======================================
${Font_suffix}"

file='/home/CloudFlare_DDNS'
ddns_conf='/home/CloudFlare_DDNS/config.conf'

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

check_system(){
	[[ -z "`cat /etc/issue | grep -E -i "debian"`" && -z "`cat /etc/issue | grep -E -i "ubuntu"`" && -z "`cat /etc/redhat-release | grep -E -i "CentOS"`" ]] && echo -e "${Error} only support Debian or Ubuntu or CentOS !" && exit 1
}

check_deps(){
	if  [[ ! -z "`cat /etc/issue | grep -E -i "debian"`" ]]; then
		apt-get install -y openssl libssl-dev ca-certificates curl
	elif
		[[ ! -z "`cat /etc/issue | grep -E -i "ubuntu"`" ]]; then
		apt-get install -y openssl libssl-dev ca-certificates curl
	elif
		[[ ! -z "`cat /etc/redhat-release | grep -E -i "CentOS"`" ]]; then
		yum install -y openssl libssl-dev ca-certificates curl
	else
		echo -e "${Error} only support Debian or Ubuntu or CentOS !" && exit 1
	fi
}

directory(){
	[[ ! -d ${file} ]] && echo -e "${Error} can not found config directory, please check !" && exit 1
	cd ${file}
}

define(){
	[[ ! -f ${ddns_conf} ]] && echo -e "${Error} can not found config file, please check !" && exit 1

	email=`cat ${ddns_conf} | grep "email" | awk -F "=" '{print $NF}'`
	zone_id=`cat ${ddns_conf} | grep "zone_id" | awk -F "=" '{print $NF}'`
	api_key=`cat ${ddns_conf} | grep "api_key" | awk -F "=" '{print $NF}'`

	record_id=`cat ${ddns_conf} | grep "record_id" | awk -F "=" '{print $NF}'`
	domain=`cat ${ddns_conf} | grep "domain" | awk -F "=" '{print $NF}'`
	ttl=`cat ${ddns_conf} | grep "ttl" | awk -F "=" '{print $NF}'`

	dynamic_ip=`curl ipv4.ip.sb`
}

choose_service(){
	if [[ -z "$1" ]]; then
		echo -e "${Info} if you want a automatic ddns, firstly you should get record_id"
		echo -e "${Info} alternatively you can use this script to create a A record and get its id"
		echo -e "${Info} now select required service:\n1.get domain record_id\n2.create a new domain A record"
		read -p "(input 1 or 2 to select):" service
		while [[ ! "${service}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} invalid input !"
			read -p "(input 1 or 2 to select):" service
		done
		[[ "${service}" = "1" ]] && get_record_id
        sed -i '/CloudFlare_DDNS/d' /var/spool/cron/root
        echo -e '*/3 * * * * bash CloudFlare_DDNS_Setter.sh --ddns' >> /var/spool/cron/root
		[[ "${service}" = "2" ]] && create_record

	elif [[ "$1" == "--ddns" ]]; then
		echo -e "${Info} now will start automatically ddns record updating service"
		update_record

	else
		echo -e "${Error} invalid input !" && exit 1
	fi
}

get_record(){
curl -X GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
	 -H "X-Auth-Email: ${email}" \
	 -H "X-Auth-Key: ${api_key}" \
	 -H "Content-Type: application/json"
}

update_record(){
curl -X PUT "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${record_id}" \
	 -H "X-Auth-Email: ${email}" \
	 -H "X-Auth-Key: ${api_key}" \
	 -H "Content-Type: application/json" \
	 --data '{"type":"A", "name":"'${domain}'", "content":"'${dynamic_ip}'", "ttl":'${ttl}', "proxied":false}'
}

create_record(){
curl -X POST "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
	 -H "X-Auth-Email: ${email}" \
	 -H "X-Auth-Key: ${api_key}" \
	 -H "Content-Type: application/json" \
	 --data '{"type":"A", "name":"'${domain}'", "content":"'${dynamic_ip}'", "ttl":'${ttl}', "proxied":false}'
}

get_record_id(){
    records_text=`get_record`
    record_id=`echo -e "${records_text}" | sed -e 's/}}/\n/g' -e 's#{\"result\":\[# #g' | grep "${domain}" | awk -F "\"" '{print $4F}'`
    sed -i '/record_id/d' ${ddns_conf}
    echo -e "record_id=${record_id}" >> ${ddns_conf}
}


check_root
check_system
check_deps
directory
define
choose_service $1
