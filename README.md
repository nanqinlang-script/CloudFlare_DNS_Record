# CloudFlare_DNSRecord_Modifier
[![Build Status](https://github.com/nanqinlang/SVG/blob/master/build%20passing.svg)](https://github.com/nanqinlang/CloudFlare_DNSRecord_Modifier)
[![language](https://github.com/nanqinlang/SVG/blob/master/language-shell-blue.svg)](https://github.com/nanqinlang/CloudFlare_DNSRecord_Modifier)
[![author](https://github.com/nanqinlang/SVG/blob/master/author-nanqinlang-lightgrey.svg)](https://github.com/nanqinlang/CloudFlare_DNSRecord_Modifier)
[![license](https://github.com/nanqinlang/SVG/blob/master/license-GPLv3-orange.svg)](https://github.com/nanqinlang/CloudFlare_DNSRecord_Modifier)

A convenient script to modify DNS Record in [CloudFlare](https://www.cloudflare.com)

## usage
the following is the way to use this scrpit

### config

you should write your config to `config.conf`  
and just write what you need

```python
# just write what you need

# the email address of your cloudflare account
email=

# the zone id of your cloudflare account
zone_id=

# the api key of your cloudflare account
api_key=

# the domain you want to set
domain=

# the ip you want to set
# if you don't use dynamic dns
required_ip=

# the current public ip of local device
# if you use dynamic dns
dynamic_ip=

# ttl of record
ttl=

# the id of domain record you want to modify
id=
```

## usage

**step 1**  
fully write configs you need

**step 2**  
then run
```bash
bash scrpit.sh
```

**step 3**  
you will meet  
`are you want to use Dynamic DNS ?`

you have two choices:  
1.yes  
2.no

input 1 or 2 then press enter

**step 3**  
you will meet  
`select required service :`

1.**get domain records details**  
this function will list all your dns records down  
you can find the id of a dns record from that list  

2.**modify domain record**  
this function need a id of dns record you want to modify, so you should write that id to `config.conf`  
this function can modify a dns record

3.**create new domain record**  
this function can create a new dns record

4.**install essence**  
the script requires this following :  
- root
- cat
- curl
- ca-certificates  
this function will install `curl and ca-certificates`  
if you have not installed this, you should run this.

## according

中文文档 ： https://www.nanqinlang.com/shell-CloudFlare_DNSRecord_Modifier.html

Cloudflare API documentation v4 : https://api.cloudflare.com/#zone-properties
