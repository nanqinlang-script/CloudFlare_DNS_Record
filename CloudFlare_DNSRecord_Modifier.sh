#!/bin/bash
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#=======================================
# Project: CloudFlare_DNSRecord_Modifier
# Version: 1.1
# Author: nanqinlang
# Blog:   https://sometimesnaive.org
# Github: https://github.com/nanqinlang
#=======================================
${Font_suffix}"

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

check_system(){
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
	[[ ! -d /home/CloudFlare_DNSRecord_Modifier ]] && echo -e "${Error} can not found config directory, please check !" && exit 1
	cd /home/CloudFlare_DNSRecord_Modifier
}

define(){
	[[ ! -f config.conf ]] && echo -e "${Error} can not found config file, please check !" && exit 1

	email=`cat config.conf | grep "email" | awk -F "=" '{print $NF}'`
	zone_id=`cat config.conf | grep "zone_id" | awk -F "=" '{print $NF}'`
	api_key=`cat config.conf | grep "api_key" | awk -F "=" '{print $NF}'`

	domain=`cat config.conf | grep "domain" | awk -F "=" '{print $NF}'`

	required_ip=`cat config.conf | grep "required_ip" | awk -F "=" '{print $NF}'`
	dynamic_ip=`curl ip.sb`

	ttl=`cat config.conf | grep "ttl" | awk -F "=" '{print $NF}'`
	record_id=`cat config.conf | grep "record_id" | awk -F "=" '{print $NF}'`
}

choose_service(){
	echo -e "${Info} select required service:\n1.get domain records details\n2.modify exists domain record\n3.create new domain record"
	read -p "(input 1 or 2 or 3 to select):" service

	while [[ ! "${service}" =~ ^[1-3]$ ]]
	do
		echo -e "${Error} invalid input !"
		read -p "(input 1 or 2 or 3 to select):" service
	done

	[[ "${service}" = "1" ]] && get_record_id
	[[ "${service}" = "2" ]] && choose_dynamic
	[[ "${service}" = "3" ]] && choose_dynamic
}

choose_dynamic(){
	echo -e "${Info} are you want to use a Dynamic DNS ?"
	echo -e "${Info} select: 1.yes 2.no"
	read -p "(input 1 or 2 to select):" dynamic

	while [[ ! "${dynamic}" =~ ^[1-2]$ ]]
	do
		echo -e "${Error} invalid input !"
		echo -e "${Info} select: 1.yes 2.no" && read -p "(input 1 or 2 to select):" dynamic
	done

	[[ "${dynamic}" = "1" ]] && ip="${dynamic_ip}"
	[[ "${dynamic}" = "2" ]] && ip="${required_ip}"

	[[ "${service}" = "2" ]] && update_record
	[[ "${service}" = "3" ]] && create_record
}

get_record_id(){
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
	 --data '{"type":"A", "name":"'${domain}'", "content":"'${ip}'", "ttl":'${ttl}', "proxied":false}'
}

create_record(){
curl -X POST "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
	 -H "X-Auth-Email: ${email}" \
	 -H "X-Auth-Key: ${api_key}" \
	 -H "Content-Type: application/json" \
	 --data '{"type":"A", "name":"'${domain}'", "content":"'${ip}'", "ttl":'${ttl}', "proxied":false}'
}



check_root
check_system
directory
define
choose_service