# snmp0wn-md5
Bash script to bruteforce snmpv3 authentication passwords using MD5 (usmHMACMD5AuthProtocol)

Great article on the vulnerability and exploit by @0x0ff (in French) :
https://www.0x0ff.info/2013/snmpv3-authentification/

# Pre-requisites

* Read RFC3414 => https://tools.ietf.org/html/rfc3414

* Download a good dictionary (one is included for demo - dico.txt).

* Install bc - An arbitrary precision calculator language

  * On Debian: `sudo apt-get install bc`

* Get a packet capture of snmpv3 traffic using Auth MD5

* Reset the below variables to match your packet capture
  * "msgAuthoritativeEngineID"="*your hex stream here*"
  * "msgAuthenticationParameters"="*your hex stream here*"
  * "msgWhole="*your hex stream here*"
    * msgWhole represents your whole snmpv3 payload where you substitute *msgAuthenticationParameters* with 12 \x00 bytes (aka 24 zeroes).  

```
# "msgAuthoritativeEngineID" (SNMP Agent ID)
msgAuthoritativeEngineID=""

# "msgAuthenticationParameters" (Controls authenticity and message integrity)
msgAuthenticationParameters=""

# "msgWhole" (SNMPv3 whole message where msgAuthenticationParameters value is being replaced 12 \x00 bytes
# Before: msgWhole=".....b92621f4a93d1bf9738cd5bd....."
# After: msgWhole=".....000000000000000000000000....."
msgWhole=""
```
You can easily copy paste your extracted hex streams from Wireshark, they do no contain escape \x nor use the 0x annotation.

# How to run
`./snmp0wn-md5.sh`
