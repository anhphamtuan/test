#!/bin/bash 

storage=storage.exoplatform.vn

storage_location=$storage/itop/exocloud/backup

download_basedir=ftp://$storage_location

backup_folder=$(date +%Y%m%d)

upload_location=sn/tenant-backup
upload_folder=$storage/$upload_location
upload_basedir=http://$upload_folder

unamed="anhpt"
pword='b1@ckcryst41'

db_list=/tmp/db_list
comp_db_list=/tmp/comp_db_list

tenant_list=$(cat ${HOME}/tenant_list.txt)

function download_upload()
{

filename=$(basename $1)
#[ "$2" == '' ]&&{ $2='.'; }
echo "$filename :"
curl --fail --show-error -u $unamed:$pword $1 > /tmp/$filename;

if [ -s /tmp/$filename ]; then
	curl -T /tmp/$filename ftp://$upload_folder/$backup_folder/ --user $unamed:$pword	
fi
}

[ ! -f $db_list ]&&{ curl -L --silent -u $unamed:$pword ftp://$storage_location/ > $db_list; }
[ ! -f $comp_db_list ]&&{ curl -L --silent -u $unamed:$pword ftp://$storage_location/db_storage/db_storage/ > $comp_db_list; }

ftp -n $storage <<END_SCRIPT
quote USER $unamed
quote PASS $pword
mkdir $upload_location/$backup_folder
echo "$upload_location/$backup_folder is created"
quit
END_SCRIPT

for tenant in ${tenant_list}; do
db_file=$(grep DB-${tenant}.sql $db_list | head -n1 | awk '{print $NF}')
if [ "$db_file" != '' ]; then
	download_upload ftp://$storage_location/$db_file
else
	db_file=$(grep DB-${tenant}.zip $comp_db_list | head -n1 | awk '{print $NF}')
	download_upload ftp://$storage_location/db_storage/db_storage/$db_file
fi
done
echo "Link ${upload_basedir}/${backup_folder}"
