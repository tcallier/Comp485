#!/bin/bash

###################################################################################################
# Script name		: create_backup.sh                                                        #
# Description		: this script is designed to copy important service configuration files   #
#                         and save them temporarily on backup directories. it is currently        #
#			  configured to back up DHCP, DNS, and Firewall/IPtables configurations.  #
#			  this script will overwrite previously created backups each time it is   #
#			  executed. it is intended to run in conjuction with create_version.sh    #
#			  which will create a long-term backup history and save up to five unique #
#			  versions. 								  #
# Author		: Thomas Callier							  #
###################################################################################################

###################################################################################################
# v variable declaration v                                                                        #
###################################################################################################

DHCP_LOGFILE=/home/techlab/backups/dhcp_backups/create_backup.log # file path of dhcp copy log file

DHCP_DATEFILE=/home/techlab/backups/dhcp_backups/current_backup/backup_date.log # file path of dchp backup time-stamp file

DHCP_SOURCE=/home/techlab/config_files/dhcp/* # file path of live dhcp config files

DHCP_DESTINATION=/home/techlab/backups/dhcp_backups/current_backup/content # file path of dhcp temp destination directory

DNS_LOGFILE=/home/techlab/backups/dns_backups/create_backup.log # file path of dns copy log file

DNS_DATEFILE=/home/techlab/backups/dns_backups/current_backup/backup_date.log # file path of dns backup time-stamp file

DNS_SOURCE=/home/techlab/config_files/dns/* # file path of live dns config files

DNS_DESTINATION=/home/techlab/backups/dns_backups/current_backup/content # file path of dns temp destination directory

FIREWALL_LOGFILE=/home/techlab/backups/firewall_backups/create_backup.log # file path of firewall copy log file

FIREWALL_DATEFILE=/home/techlab/backups/firewall_backups/current_backup/backup_date.log # file path of firewall backup time-stamp file

FIREWALL_SOURCE=/home/techlab/config_files/firewall/* # file path of live firewall config files

FIREWALL_DESTINATION=/home/techlab/backups/firewall_backups/current_backup/content # file path of firewall temp destination directory

DATE=$(date "+%m/%d/%Y %T") # used to display current date/time

SPACER=------------------------------------------------------------ # used to separate log entries

###################################################################################################
# v back up DHCP config files v                                                                   #
###################################################################################################

mkdir -p $DHCP_DESTINATION # create directory to copy dhcp config files to if it does not exist

touch $DHCP_LOGFILE # create log file if it does not exist

touch $DHCP_DATEFILE # create backup time-stamp file if it does not exist

cp -R $DHCP_SOURCE $DHCP_DESTINATION 2>> $DHCP_LOGFILE # copy dhcp config source files to destination directory & log any errors

if [ $? -eq 0 ]; then # if file copy successful
	echo -e "$DATE : $DHCP_SOURCE copied to $DHCP_DESTINATION\n$SPACER" >> $DHCP_LOGFILE # write success message to log file
	echo -e "This backup was created on $DATE" > $DHCP_DATEFILE # write date/time to time-stamp file
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create a backup of $DHCP_SOURCE\n$SPACER" >> $DHCP_LOGFILE # write error message to log file
fi

###################################################################################################
# v back up DNS config files v                                                                    #
###################################################################################################

mkdir -p $DNS_DESTINATION # create directory to copy dns config files to if it does not exist

touch $DNS_LOGFILE # create log file if it does not exist

touch $DNS_DATEFILE # create backup time-stamp file if it does not exist

cp -R $DNS_SOURCE $DNS_DESTINATION 2>> $DNS_LOGFILE # copy dns config source files to destination directory & log any errors 

if [ $? -eq 0 ]; then # if file copy successful
	echo -e "$DATE : $DNS_SOURCE copied to $DNS_DESTINATION\n$SPACER" >> $DNS_LOGFILE # write success message to log file
	echo -e "This backup was created on $DATE" > $DNS_DATEFILE # write date/time to time-stamp file
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create a backup of $DNS_SOURCE\n$SPACER" >> $DNS_LOGFILE # write error message to log file
fi

###################################################################################################
# v back up Firewall config files v                                                               #
###################################################################################################

mkdir -p $FIREWALL_DESTINATION # create directory to copy firewall config files to if it does not exist

touch $FIREWALL_LOGFILE # create log file if it does not exist

touch $FIREWALL_DATEFILE # create backup time-stamp file if it does not exist

cp -R $FIREWALL_SOURCE $FIREWALL_DESTINATION 2>> $FIREWALL_LOGFILE # copy firewall config source files to destination directory & log any errors

cp -R /home/techlab/config_files/iptables $FIREWALL_DESTINATION 2>> $FIREWALL_LOGFILE

cp /home/techlab/config_files/iptablerules.fw $FIREWALL_DESTINATION 2>> $FIREWALL_LOGFILE

if [ $? -eq 0 ]; then # if file copy successful
	echo -e "$DATE : $FIREWALL_SOURCE copied to $FIREWALL_DESTINATION\n$SPACER" >> $FIREWALL_LOGFILE # write success message to log file
	echo -e "This backup was created on $DATE" > $FIREWALL_DATEFILE # write date/time to time-stamp file
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create a backup of $FIREWALL_SOURCE\n$SPACER" >> $FIREWALL_LOGFILE # write error message to log file
fi

# end script

