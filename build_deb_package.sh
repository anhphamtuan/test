#!/bin/bash

creator="Pham Tuan Anh"
company=exoplatform.com

echo "Folder contain necessery files to build .deb package: (should be full path)"
read foldername

if [ $(echo $1) == '' ]; then
	echo "script or binary file:"
	read filefullpath
	filename=$(basename $filefullpath)
fi

echo "package short description:"
read shortdesc

echo "package long description:"
read longdesc

mkdir -p $foldername/usr/bin
cp $filefullpath $foldername/usr/bin/$filename

cd $foldername
dh_make -s -c gpl --createorig
cd debian
rm *.ex *.EX


#edit changelog file
sed -i -e "s/unknown/$company/;s/unstable/stable/" changelog

#edit control file
sed -i -e "s/unknown/$company/;s/any/all/;s/insert up to 60 chars description/$shortdesc/;s/insert long description, indented with spaces/$longdesc/" control

#edit copyright file
sed -i -e "s/years/$(date | awk {'print $NF'})/;s/unknown/$company/;s/put author's name and email here/$creator/" copyright

#create file .install
echo "/usr/bin/$filename" > $filename.install

echo "do you want to edit $filename.install ?"; read yon

if [ $yon = "y" ]||[ $yon = "Y" ]||[ $yon = "yes" ]||[ $yon = "Yes" ]||[ $yon = "YES" ]; then
	vim $filename.install
fi

cd ..
if [ "$(head -n1 usr/bin/$filename | sed 's/ //g')" = "#!bin/bash" ]; then
	dpkg-buildpackage -us -uc
else
	dpkg-buildpackage -b
fi
