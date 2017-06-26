# bruteforce-snmpv3-md5
Bash script to bruteforce snmpv3 authentication passwords using MD5 (usmHMACMD5AuthProtocol)

This tool was developed for the snmp authentication root-me challenge:

https://www.root-me.org/en/Challenges/Network/SNMP-Authentification

I do not suggest you use this tool to solve the challenge, come up with your own (otherwise what's the point ?)

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
msgAuthoritativeEngineID="80001f8880e9bd0c1d12667a5100000000"
# "msgAuthenticationParameters" (Controls authenticity and message integrity)
msgAuthenticationParameters="b92621f4a93d1bf9738cd5bd"
# "msgWhole" (SNMPv3 whole message where msgAuthenticationParameters value is being replaced 12 \x00 bytes
# Before: msgWhole=".....b92621f4a93d1bf9738cd5bd....."
# After: msgWhole=".....000000000000000000000000....."
msgWhole="3081800201033011020420dd06a7020300ffe30401050201030431302f041180001f8880e9bd0c1d12667a5100000000020105020120040475736572040c00000000000000000000000004003035041180001f8880e9bd0c1d12667a51000000000400a11e02046b4c5ac20201000201003010300e060a2b06010201041e0105010500"
```
The above values are "Hex streams" gathered from Wireshark, they do no contain escape \x or use the 0x annotation.

# How to run
`./snmp0wn-md5.sh`
