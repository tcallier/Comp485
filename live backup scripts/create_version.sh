#!/bin/bash

###################################################################################################
# Script name		: create_version.sh                                                       #
# Description		: this script is designed to create a version history of config file      #
#			  backups created by the create_backup.sh script. these backups include   #
#			  config files for DHCP, DNS, Firewall/IPtables, and Netplan. it is	  #
#			  designed to compare the most recent backup to the most recent version	  #
#			  created. if file modifications are found, it will create a new version  #
#			  and add it to the history. if no modifications are found, a new version #
#			  will not be created. it will save up to five unique versions with	  #
#			  version one being the newest and version five being the oldest. if five #
#			  versions exist, version five will be overwritten if a new version is	  #
#			  added.								  #
# Author		: Thomas Callier							  #
###################################################################################################

###################################################################################################
# v variable declaration v									  #
###################################################################################################

DHCP_LOGFILE=/home/techlab/infrastructure/versions/dhcp_versions/versions_create.log # file path of dhcp version log file

DHCP_SOURCE=/home/techlab/infrastructure/backups/dhcp_backups/current_backup # file path of latest dhcp backup (includes time-stamp file)

DHCP_SOURCE_CONTENT=/home/techlab/infrastructure/backups/dhcp_backups/current_backup/content # file path of latest dhcp backup content (excludes time-stamp file)

DHCP_VERSIONS=/home/techlab/infrastructure/versions/dhcp_versions # file path to directory holding dhcp version history

DHCP_FIRST_VERSION=/home/techlab/infrastructure/versions/dhcp_versions/version_1 # file path to directory containing most recent dhcp version created (includes time-stamp file)

DHCP_FIRST_VERSION_CONTENT=/home/techlab/infrastructure/versions/dhcp_versions/version_1/content # file path to directory containing the content of the most recent dhcp version created (exlcludes time-stamp file)

DNS_LOGFILE=/home/techlab/infrastructure/versions/dns_versions/versions_create.log # file path of dns version log file

DNS_SOURCE=/home/techlab/infrastructure/backups/dns_backups/current_backup # file path of latest dns backup (includes time-stamp file)

DNS_SOURCE_CONTENT=/home/techlab/infrastructure/backups/dns_backups/current_backup/content # file path of latest dns backup content (excludes time-stamp file)

DNS_VERSIONS=/home/techlab/infrastructure/versions/dns_versions # file path to directory holding dns version history

DNS_FIRST_VERSION=/home/techlab/infrastructure/versions/dns_versions/version_1 # file path to directory containing most recent dns version created (includes time-stamp file)

DNS_FIRST_VERSION_CONTENT=/home/techlab/infrastructure/versions/dns_versions/version_1/content # file path to directory containing the content of the most recent dns version created (excludes time-stamp file)

FIREWALL_LOGFILE=/home/techlab/infrastructure/versions/firewall_versions/versions_create.log # file path of firewall version log file

FIREWALL_SOURCE=/home/techlab/infrastructure/backups/firewall_backups/current_backup # file path of latest firewall backup (includes time-stamp file)

FIREWALL_SOURCE_CONTENT=/home/techlab/infrastructure/backups/firewall_backups/current_backup/content # file path of latest firewall backup content (excludes time-stamp file)

FIREWALL_VERSIONS=/home/techlab/infrastructure/versions/firewall_versions # file path to directory holding firewall version history

FIREWALL_FIRST_VERSION=/home/techlab/infrastructure/versions/firewall_versions/version_1 # file path to directory containing most recent firewall version created (includes time-stamp file)

FIREWALL_FIRST_VERSION_CONTENT=/home/techlab/infrastructure/versions/firewall_versions/version_1/content # file path to directory containing the content of the most recent firewall version created (excludes time-stamp file)

NETPLAN_LOGFILE=/home/techlab/infrastructure/versions/netplan_versions/versions_create.log # file path of dhcp version log file

NETPLAN_SOURCE=/home/techlab/infrastructure/backups/netplan_backups/current_backup # file path of latest dhcp backup (includes time-stamp file)

NETPLAN_SOURCE_CONTENT=/home/techlab/infrastructure/backups/netplan_backups/current_backup/content # file path of latest dhcp backup content (excludes time-stamp file)

NETPLAN_VERSIONS=/home/techlab/infrastructure/versions/netplan_versions # file path to directory holding dhcp version history

NETPLAN_FIRST_VERSION=/home/techlab/infrastructure/versions/netplan_versions/version_1 # file path to directory containing most recent dhcp version created (includes time-stamp file)

NETPLAN_FIRST_VERSION_CONTENT=/home/techlab/infrastructure/versions/netplan_versions/version_1/content # file path to directory containing the content of the most recent dhcp version created (exlcludes time-stamp file)

DATE=$(date "+%m/%d/%Y %T") # Displays the current date/time

SPACER=------------------------------------------------------------ # used to separate log entries

###################################################################################################
# v dhcp version creation v                                                                       #
###################################################################################################

for i in 1 2 3 4 5
do
	mkdir -p $DHCP_VERSIONS/version_$i
done # creates 5 directories for the dhcp version backups if they do not already exist

touch $DHCP_LOGFILE # create the dhcp log file if it does not already exist

echo -e "$DATE : Starting...\n$DATE : Seeking source directory..." >> $DHCP_LOGFILE # write starting message to dhcp log file

if [ ! -d $DHCP_SOURCE_CONTENT ]; then # if the content of the latest dhcp backup is not found
	echo -e "$DATE : Source directory not found! Unable to create new version." >> $DHCP_LOGFILE # write message to dhcp log file that source directory could not be found - unable to create new version
else # if the content of the latest dhcp backup is found
	echo -e "$DATE : Source directory found.\n$DATE : Checking if any files in directory have been modified since last version creation..." >> $DHCP_LOGFILE # write success message to dhcp log file. write message to dhcp log file that file comparison will begin
	diff -r $DHCP_SOURCE_CONTENT $DHCP_FIRST_VERSION_CONTENT &>/dev/null # search for differences in the content of the latest dhcp backup and the content of the most recent dhcp version created. output to /dev/null to prevent printing to console if differences are found
	if [ $? -eq 0 ]; then # if no differences found
		echo -e "$DATE : No files in source directory have been modified since last version creation. No new version will be created." >> $DHCP_LOGFILE # write message to dhcp log file that no modifications have been found - new version will not be created
	else # if differences are found
		echo -e "$DATE : Files in source directory have been modified. Creating new version..." >> $DHCP_LOGFILE # write message to dhcp log file that modifications were found and a new version is being created
		cp -R $DHCP_VERSIONS/version_4/* $DHCP_VERSIONS/version_5 2>> $DHCP_LOGFILE # copy all files in version 4 to version 5
		cp -R $DHCP_VERSIONS/version_3/* $DHCP_VERSIONS/version_4 2>> $DHCP_LOGFILE # copy all files in version 3 to version 4
		cp -R $DHCP_VERSIONS/version_2/* $DHCP_VERSIONS/version_3 2>> $DHCP_LOGFILE # copy all files in version 2 to version 3
		cp -R $DHCP_VERSIONS/version_1/* $DHCP_VERSIONS/version_2 2>> $DHCP_LOGFILE # copy all files in version 1 to version 2
		cp -R $DHCP_SOURCE/* $DHCP_FIRST_VERSION 2>> $DHCP_LOGFILE # copy all files in the latest dhcp backup created to version 1
		echo -e "$DATE : New version created!" >> $DHCP_LOGFILE # write message to dhcp log file that a new version was successfully created
	fi
fi

echo -e "$DATE : Done.\n$SPACER" >> $DHCP_LOGFILE # write message to dhcp log file that the version create process is complete

###################################################################################################
# v dns version creation v									  #
###################################################################################################

for i in 1 2 3 4 5
do
	mkdir -p $DNS_VERSIONS/version_$i
done # creates 5 directories for the dns version backups if they do not exist already

touch $DNS_LOGFILE # create the dns log file if it does not exist already

echo -e "$DATE : Starting...\n$DATE : Seeking source directory..." >> $DNS_LOGFILE # write starting message to dns log file

if [ ! -d $DNS_SOURCE_CONTENT ]; then # if the content of the latest dns backup is not found
	echo -e "$DATE : Source directory not found! Unable to create new version." >> $DNS_LOGFILE # write message to dns log file that source directory could not be found - unable to create new version
else # if the content of the latest dns backup is found
	echo -e "$DATE : Source directory found.\n$DATE : Checking if any files in directory have been modified since last version creation..." >> $DNS_LOGFILE # write success message to dns log file. write message to dns log file that file comparison will begin
	diff -r $DNS_SOURCE_CONTENT $DNS_FIRST_VERSION_CONTENT &>/dev/null # search for differences in the content of the latest dns backup and the content of the most recent dns version created. output to /dev/null to prevent printing to console if differences are found
	if [ $? -eq 0 ]; then # if no differences found
		echo -e "$DATE : No files in source directory have been modified since last version creation. No new version will be created." >> $DNS_LOGFILE # write message to dns log file that no modifications have been found - new version will not be created
	else # if differences are found
		echo -e "$DATE : Files in source directory have been modified. Creating new version..." >> $DNS_LOGFILE # write message to dns log file that modifications were found and a new versions is being created
		cp -R $DNS_VERSIONS/version_4/* $DNS_VERSIONS/version_5 2>> $DNS_LOGFILE # copy all files in version 4 to version 5
		cp -R $DNS_VERSIONS/version_3/* $DNS_VERSIONS/version_4 2>> $DNS_LOGFILE # copy all files in version 3 to version 4
		cp -R $DNS_VERSIONS/version_2/* $DNS_VERSIONS/version_3 2>> $DNS_LOGFILE # copy all files in version 2 to version 3
		cp -R $DNS_VERSIONS/version_1/* $DNS_VERSIONS/version_2 2>> $DNS_LOGFILE # copy all files in version 1 to version 2
		cp -R $DNS_SOURCE/* $DNS_FIRST_VERSION 2>> $DNS_LOGFILE # copy all files in the latest dns backup created to version 1
		echo -e "$DATE : New version created!" >> $DNS_LOGFILE # write message to dns log file that a new version was successfully created
	fi
fi

echo -e "$DATE : Done.\n$SPACER" >> $DNS_LOGFILE # write message to dns log file that the version create process is complete

###################################################################################################
# v firewall version creation v									  #
###################################################################################################

for i in 1 2 3 4 5
do
	mkdir -p $FIREWALL_VERSIONS/version_$i
done # creates 5 directories for the firewall version backups if they do not exist already

touch $FIREWALL_LOGFILE # create the firewall log file if it does not exist already

echo -e "$DATE : Starting...\n$DATE : Seeking source directory..." >> $FIREWALL_LOGFILE # write starting message to firewall log file

if [ ! -d $FIREWALL_SOURCE_CONTENT ]; then # if the content of the latest firewall backup is not found
	echo -e "$DATE : Source directory not found! Unable to create new version." >> $FIREWALL_LOGFILE # write message to firewall log file that source directory could not be found - unable to create new version
else # if the content of the latest firewall backup is found
	echo -e "$DATE : Source directory found.\n$DATE : Checking if any files in directory have been modified sicne last version creation..." >> $FIREWALL_LOGFILE # write success message to firewall log file. write message to firewall log file that file comparison will begin
	diff -r $FIREWALL_SOURCE_CONTENT $FIREWALL_FIRST_VERSION_CONTENT &>/dev/null # search for differences in the content of the latest firewall backup and the content of the most recent firewall version created. output to /dev/null to prevent printing to console if differences are found
	if [ $? -eq 0 ]; then # if no differences found
		echo -e "$DATE : No files in source directory have been modified since last version creation. No new version will be created." >> $FIREWALL_LOGFILE # write message to firewall log file that no modifications have been found - new version will not be created
	else # if differences are found
		echo -e "$DATE : Files in source directory have been modified. Creating new version." >> $FIREWALL_LOGFILE # write message to firewall log file that modifications were found and a new version is being created
		cp -R $FIREWALL_VERSIONS/version_4/* $FIREWALL_VERSIONS/version_5 2>> $FIREWALL_LOGFILE # copy all files in version 4 to version 5
		cp -R $FIREWALL_VERSIONS/version_3/* $FIREWALL_VERSIONS/version_4 2>> $FIREWALL_LOGFILE # copy all files in version 3 to version 4
		cp -R $FIREWALL_VERSIONS/version_2/* $FIREWALL_VERSIONS/version_3 2>> $FIREWALL_LOGFILE # copy all files in version 2 to version 3
		cp -R $FIREWALL_VERSIONS/version_1/* $FIREWALL_VERSIONS/version_2 2>> $FIREWALL_LOGFILE # copy all files in version 1 to version 2
		cp -R $FIREWALL_SOURCE/* $FIREWALL_FIRST_VERSION 2>> $FIREWALL_LOGFILE # copy all files in the latest firewall backup created to version 1
		echo -e "$DATE : New version created!" >> $FIREWALL_LOGFILE # write message to firewall log file that a new version was successfully created
	fi
fi

echo -e "$DATE : Done.\n$SPACER" >> $FIREWALL_LOGFILE # write message to firewall log file that the version create process is complete

###################################################################################################
# v netplan version creation v                                                                    #
###################################################################################################

for i in 1 2 3 4 5
do
	mkdir -p $NETPLAN_VERSIONS/version_$i
done # creates 5 directories for the netplan version backups if they do not already exist

touch $NETPLAN_LOGFILE # create the netplan log file if it does not already exist

echo -e "$DATE : Starting...\n$DATE : Seeking source directory..." >> $NETPLAN_LOGFILE # write starting message to netplan log file

if [ ! -d $NETPLAN_SOURCE_CONTENT ]; then # if the content of the latest netplan backup is not found
	echo -e "$DATE : Source directory not found! Unable to create new version." >> $NETPLAN_LOGFILE # write message to netplan log file that source directory could not be found - unable to create new version
else # if the content of the latest netplan backup is found
	echo -e "$DATE : Source directory found.\n$DATE : Checking if any files in directory have been modified since last version creation..." >> $NETPLAN_LOGFILE # write success message to netplan log file. write message to netplan log file that file comparison will begin
	diff -r $NETPLAN_SOURCE_CONTENT $NETPLAN_FIRST_VERSION_CONTENT &>/dev/null # search for differences in the content of the latest netplan backup and the content of the most recent netplan version created. output to /dev/null to prevent printing to console if differences are found
	if [ $? -eq 0 ]; then # if no differences found
		echo -e "$DATE : No files in source directory have been modified since last version creation. No new version will be created." >> $NETPLAN_LOGFILE # write message to dhcp log file that no modifications have been found - new version will not be created
	else # if differences are found
		echo -e "$DATE : Files in source directory have been modified. Creating new version..." >> $NETPLAN_LOGFILE # write message to netplan log file that modifications were found and a new version is being created
		cp -R $NETPLAN_VERSIONS/version_4/* $NETPLAN_VERSIONS/version_5 2>> $NETPLAN_LOGFILE # copy all files in version 4 to version 5
		cp -R $NETPLAN_VERSIONS/version_3/* $NETPLAN_VERSIONS/version_4 2>> $NETPLAN_LOGFILE # copy all files in version 3 to version 4
		cp -R $NETPLAN_VERSIONS/version_2/* $NETPLAN_VERSIONS/version_3 2>> $NETPLAN_LOGFILE # copy all files in version 2 to version 3
		cp -R $NETPLAN_VERSIONS/version_1/* $NETPLAN_VERSIONS/version_2 2>> $NETPLAN_LOGFILE # copy all files in version 1 to version 2
		cp -R $NETPLAN_SOURCE/* $NETPLAN_FIRST_VERSION 2>> $NETPLAN_LOGFILE # copy all files in the latest netplan backup created to version 1
		echo -e "$DATE : New version created!" >> $NETPLAN_LOGFILE # write message to netplan log file that a new version was successfully created
	fi
fi

echo -e "$DATE : Done.\n$SPACER" >> $NETPLAN_LOGFILE # write message to netplan log file that the version create process is complete

####### gitlab
echo "starting push to github..." >> /home/techlab/infrastructure/gitlab.log

git add versions && \
git add -u && \
git commit -m "remote commit from 18.04 vm" && \
git push origin HEAD 2>> /home/techlab/infrastructure/gitlab.log

# end script