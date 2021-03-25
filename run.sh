#!/bin/bash
# @author shandpy
# 

echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%                               __                                                %"
echo "%                         __   / /|                                               %"
echo "%                        |\ \  \/_/                                               %"
echo "%                        \_\| / __                                                %"
echo "%                           \/_/__\           .-=='/~\                            %"
echo "%                    ____,__/__,_____,______)/   /{~}}}                           %"
echo "%                    -,------,----,-----,---,\'-' {{~}}                           %"
echo "%                                             '-==.\}/                            %"
echo "%                                                                                 %"
echo "%                                            @author    : shandpy                 %"
echo "%                                            @Github    : github.com/shandpy      %"
echo "%                                                                                 %"
echo "%  1. Removing subdomain                                                          %"
echo "%  2. Domain to IP                                                                %"
echo "%  3. Filter Domain (Wordpress / Joomla 1.6 / 1.7)                                %"
echo "%  4. AWS Send Quota Check                                                        %"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
mkdir -p Results
echo 
read -p "Input your choose => " PILIH
case $PILIH in
	1 )
		clear 
		echo " %%% Example list Removing subdomain %%%"
		echo 
		echo "  $ cat list.txt"
		echo "  abc.kompas.com"
		echo "  xyz.detik.com"
		echo
		read -p " # Input your list : " LIST
		for rsubdo in $(cat $LIST);
		do
			./main.sh rsubdo $rsubdo
		done
		;;
	2 )
		clear
		echo " %%% Example list Domain to IP %%%"
		echo 
		echo "  $ cat list-d-to-i.txt"
		echo "  kompas.com"
		echo "  detik.com"
		echo
		read -p " # Input your list : " LIST
		for dti in $(cat $LIST);
		do
			./main.sh dti $dti
		done
		;;
	3 )
		clear
		echo " %%% Example list Filter Domain (Wordpress / Joomla 1.6 / 1.7) %%%"
		echo 
		echo "  $ cat list-wp.txt"
		echo "  detik.com"
		echo "  wordpress.com"
		echo
		read -p " Input your list => " LIST
		read -p " Send to (5/10/15|...): " SENDTO
		read -p " Delay(2/5/10/...): " WDELAY
		CALc=0
		IFS=$'\r\n' GLOBIGNORE='*' command eval 'LIST=($(cat $LIST))'
		for (( i = 0; i <"${#LIST[@]}"; i++ )); do
		 
		  DOMAIN="${LIST[$i]}"
		 
		  SENDd=$(expr $CALc % $SENDTO)
		  if [[ $SENDd == 0 && $CALc > 0 ]]; then
		    sleep $WDELAY
		  fi
		  ./main.sh chkcms $DOMAIN &
		  CALc=$[$CALc+1]
		done
		wait
		;;
	4 )
		clear
		echo " %%% Example list AWS Send Quota Check %%%"
		echo 
		echo "  $ cat list-aws.txt"
		echo "  AKIXXXXXKTXXKEXXXDXA|qkxxFPxx4I6ExxxxxxxxxxuyZxCLkiIxxxywCxxx|ap-northeast-1"
		echo
		read -p " Input Your List = > " LIST
		for KEY in $(cat $LIST);
		do
			ACCESS_KEY_ID=$(echo $KEY | cut -d '|' -f 1)
			SECRET_ACCESS_KEY=$(echo $KEY | cut -d '|' -f 2)
			DEFAULT_REGION=$(echo $KEY | cut -d '|' -f 3)
			./main.sh awschk $ACCESS_KEY_ID $SECRET_ACCESS_KEY $DEFAULT_REGION
		done
		;;
	*)
		echo "Mohon diperiksa pilihan anda"
		;;
esac
