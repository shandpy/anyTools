#!/bin/bash
# @author shandpy
# 
function awschk() {
	rm -rf ~/.aws/*
	## Config
	echo "[default]" >> ~/.aws/config
	echo "region = ${3}" >> ~/.aws/config
	echo "output = json" >> ~/.aws/config
	# Credentials
	echo "[default]" >> ~/.aws/credentials
	echo "aws_access_key_id = ${1}" >> ~/.aws/credentials
	echo "aws_secret_access_key = ${2}" >> ~/.aws/credentials
	AWSs=$(aws ses get-send-quota)
	if [[ $AWSs =~ 'Max24HourSend' ]]; then
		echo " + VALID ${1} || ${2} || ${3}" | tee -a Results/aws-quota.txt
	else
		echo " - NOT VALID ${1} || ${2} || ${3}"
	fi
}
function chkcms() {
	chkcms=$(curl -sL -m 10 -A "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:83.0) Gecko/20100101 Firefox/83.0" $1)
	if [[ $chkcms =~ "/wp-content/themes/" ]]; then
		echo " + FOUND WORDPRESS $1" | tee -a Results/wordpress.txt
	elif [[ $chkcms =~ "Joomla! 1.6" ]]; then 
		echo " + FOUND JOOMLA $1" | tee -a Results/joomla-16.txt
	elif [[ $chkcms =~ "Joomla! 1.7" ]]; then 
		echo " + FOUND JOOMLA $1" | tee -a Results/joomla-17.txt
	else
		echo " - NOT FOUND $1"
	fi
}
function dti() {
	CHKdti=$(dig +short $1 | head -1)
	if [ -z $CHKdti ]
	then
		echo " - IP can't found"
	else
		echo " + $1 => $CHKdti" | tee -a Results/domain-to-ip.txt
	fi
}

function rsubdo () {
	echo $1 | awk -F\. '{print $(NF-1) FS $NF}' | tee -a Results/removing-subdomain.txt
}

case $1 in
	rsubdo )
		rsubdo $2
		;;
	dti )
		dti $2 
		;;
	chkcms )
		chkcms $2
		;;
	awschk )
		awschk $2 $3 $4
		;;
	*)
		echo "tidak dikenali"
		;;
esac
