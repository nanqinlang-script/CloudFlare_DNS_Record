# CloudFlare_DNS_Record
[![Build Status](https://github.com/nanqinlang/SVG/blob/master/build%20passing.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)
[![language](https://github.com/nanqinlang/SVG/blob/master/language-shell-blue.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)
[![author](https://github.com/nanqinlang/SVG/blob/master/author-nanqinlang-lightgrey.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)
[![license](https://github.com/nanqinlang/SVG/blob/master/license-GPLv3-orange.svg)](https://github.com/nanqinlang-script/CloudFlare_DNS_Record)

Script to modify DNS Record via [CloudFlare](https://www.cloudflare.com)

## usage
the following is the method to use this scrpit

### download
```bash
mkdir /home/CloudFlare_DDNS
cd /home/CloudFlare_DDNS
wget https://raw.githubusercontent.com/nanqinlang-script/CloudFlare_DNS_Record/Keeper/CloudFlare_DDNS_Keeper.sh
wget https://raw.githubusercontent.com/nanqinlang-script/CloudFlare_DNS_Record/Keeper/config.conf
```

### config
you should write your config to `config.conf`, and just write what you need :
```python
# just write what you need

# notice: the following interpretations("# ...") is not allowed in file "config.conf", do not write interpretations into config file

# the email address of your cloudflare account
email=

# the zone id of your cloudflare account
zone_id=

# the api key of your cloudflare account
api_key=

# the id of domain record you want to modify
# this id can be find via "get domain records details" function of the script
record_id=

# the domain you want to set
domain=

# ttl of record
# min value:120
# max value:2147483647
ttl=
```

take a example, you should write like this:
```c
email=example@gmail.com
zone_id=2736dff127f14ff4ae263ef35esd060f
api_key=84058228se28e28898b6ds3ej78yuf2136654
record_id=1d3a9b54623334f3debc20c56eb5585c
domain=example.example.net
ttl=120
```

### function

**step 1**  
fully write configs required

**step 2**  
then run
```bash
bash CloudFlare_DDNS_Keeper.sh
```

**step 3**  
you will meet  
`select required service :`

1.**get domain records details**  
this function will list all your dns records down  
you can find the id of a dns record from that list  

2.**modify domain record**  
this function need a record_id of dns record you want to modify, so you should write that id to `config.conf`  
this function can modify a dns record

3.**create new domain record**  
this function can create a new dns record

## according
中文文档  
https://sometimesnaive.org/article/5 (to be updated)

Cloudflare API documentation v4  
https://api.cloudflare.com/#zone-properties