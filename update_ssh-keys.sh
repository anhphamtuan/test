#!/bin/bash

storage=storage.exoplatform.vn/sn-config/ssh-key/privatekey
local_folder=~/ssh-key/privatekey

id=sn2
pw=vdH948dJ

dlist=/tmp/download_list
updated_keys=''
cd $local_folder
local_list=$(ls)
curl -L --silent -u $id:$pw ftp://$storage/ > $dlist

key_list=$(cat $dlist | awk '{print $NF}' | grep 'MAY\|may')

if [ "$key_list" != '' ]; then
	for local_key in ${local_list}; do
		[ "$(grep $local_key $key_list)" == '' ]&&{ rm -rf $key; }
	done
	for key in ${key_list}; do
		chmod 666 $key
		wget -N --http-user=$id --http-password=$pw http://$storage/$key 
		[ $? ]&&{ $updated_key += "$key "; }
		chmod 400 $key
	done
fi

echo "[RESULT] keys was updated: $updated_keys"
