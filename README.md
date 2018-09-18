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
wget https://raw.githubusercontent.com/dovela/CloudFlare_DNS_Record/Setter/CloudFlare_DDNS_Setter.sh
wget https://raw.githubusercontent.com/dovela/CloudFlare_DNS_Record/Setter/config.conf
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

# the domain you want to set
domain=

# ttl of record (seconds)
# min value:120
# max value:2147483647
ttl=

# the id of domain record you want to modify
# you can't see it before run this script
# this id can be added automatically via "get domain record_id" selection in the script
record_id=

```

take a example, you should write like this:
```c
email=example@gmail.com
zone_id=3456dfdhfi465ff4ae263ef35esd060f
api_key=84058228se28e28898b6ds3ej78yuf2136654

domain=example.example.net
ttl=120
```

## usage

### step 1
write those config down:
- email
- zone_id
- api_key
- domain
- ttl

### step 2
then run
```bash
bash CloudFlare_DDNS_Setter.sh
```
and you will meet `select required service :`

1.**get domain record_id**  
this function will get the record_id of your domain and insert it into config file automatically

2.**create new domain record**  
this function can create a new A dns record


### step 3
after you finished step 1~2, you will need to run this :
```bash
bash CloudFlare_DDNS_Setter.sh --ddns
```
for above, the parameter `--ddns` is to update your dns A record to refresh your ddns. Freely let it automatically via such as `crontab`.
this script have already added a record that is `*/3 * * * * bash CloudFlare_DDNS_Setter.sh --ddns` to `/var/spool/cron/root`,and you can use `crontab -e` to modify it.

## according
中文文档  
https://sometimesnaive.org/article/5 (to be updated)

Cloudflare API documentation v4  
https://api.cloudflare.com/#zone-properties
