# CloudFlare_DDNS_Setter
[![Build Status](https://github.com/nanqinlang/SVG/blob/master/build%20passing.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)
[![language](https://github.com/nanqinlang/SVG/blob/master/language-shell-blue.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)
[![author](https://github.com/nanqinlang/SVG/blob/master/author-nanqinlang-lightgrey.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)
[![license](https://github.com/nanqinlang/SVG/blob/master/license-GPLv3-orange.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)

Script to set DDNS Record via [CloudFlare](https://www.cloudflare.com)


## download
```bash
mkdir /home/CloudFlare_DDNS
cd /home/CloudFlare_DDNS
wget https://raw.githubusercontent.com/nanqinlang-script/CloudFlare_DNS_Record/Setter/CloudFlare_DDNS_Setter.sh
wget https://raw.githubusercontent.com/nanqinlang-script/CloudFlare_DNS_Record/Setter/config.conf
```

## config
you should write your configuration down to `config.conf` :
```python
# notice: the following interpretations("# ...") is not allowed in file "config.conf"
# do not write interpretations into config file

# the email address of your cloudflare account
email=

# the zone id of your cloudflare account
zone_id=

# the api key of your cloudflare account
api_key=

# the id of domain record you want to modify
# this id can be find via "get domain record_id" selection in the script
record_id=

# the domain you want to set
domain=

# ttl of record (seconds)
# min value:120
# max value:2147483647
ttl=
```

take a example, you should write like this:
```c
email=example@gmail.com
zone_id=3456dfdhfi465ff4ae263ef35esd060f
api_key=84058228se28e28898b6ds3ej78yuf2136654

record_id=1d3a9b54623334f3debc20c56eb5585c
domain=example.example.net
ttl=120
```

## usage

### step 1
write those config down:
- email
- zone_id
- api_key

### step 2
then run
```bash
bash CloudFlare_DDNS_Setter.sh
```
and you will meet `select required service :`

1.**get domain record_id**  
this function will list all your dns records  
you should get the id of a dns record from the list and write it down to `record_id` in the config file  

2.**create new domain record**  
this function can create a new A dns record

### step 3
continuously write those config down:
- record_id
- domain
- ttl

### step 4
after you finished step 1~3, you will need to run this :
```bash
bash CloudFlare_DDNS_Setter.sh --ddns
```
for above, the parameter `--ddns` is to update your dns A record to refresh your ddns. Freely let it automatically via such as `crontab`.

## according
中文文档  
https://sometimesnaive.org/article/5 (to be updated)

Cloudflare API documentation v4  
https://api.cloudflare.com/#zone-properties