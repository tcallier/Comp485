#!/bin/bash

###################################################################################################
# Script name		: create_backup.sh                                                        #
# Description		: this script is designed to copy important service configuration files   #
#                         and save them temporarily on backup directories. it is currently        #
#			  configured to back up DHCP, DNS, Firewall/IPtables, and Netplan 	  #
#			  configurations. this script will overwrite previously created backups	  # 
#			  each time it is executed. it is intended to run in conjuction with	  #
#			  create_version.sh which will create a long-term backup history and save #
#			  up to five unique versions.						  #
# Author		: Thomas Callier							  #
###################################################################################################

###################################################################################################
# v variable declaration v                                                                        #
###################################################################################################

DHCP_LOGFILE=/home/techlab/infrastructure/backups/dhcp_backups/create_backup.log # file path of dhcp copy log file

DHCP_DATEFILE=/home/techlab/infrastructure/backups/dhcp_backups/current_backup/backup_date.log # file path of dchp backup time-stamp file

DHCP_SOURCE=/etc/dhcp/* # file path of live dhcp config files

DHCP_DESTINATION=/home/techlab/infrastructure/backups/dhcp_backups/current_backup/content # file path of dhcp temp destination directory

DNS_LOGFILE=/home/techlab/infrastructure/backups/dns_backups/create_backup.log # file path of dns copy log file

DNS_DATEFILE=/home/techlab/infrastructure/backups/dns_backups/current_backup/backup_date.log # file path of dns backup time-stamp file

DNS_SOURCE=/etc/bind # file path of live dns config files

DNS_DESTINATION=/home/techlab/infrastructure/backups/dns_backups/current_backup/content # file path of dns temp destination directory

RESOLVE_SOURCE=/etc/resolv.conf # file path of live dns resolve config file

FIREWALL_LOGFILE=/home/techlab/infrastructure/backups/firewall_backups/create_backup.log # file path of firewall copy log file

FIREWALL_DATEFILE=/home/techlab/infrastructure/backups/firewall_backups/current_backup/backup_date.log # file path of firewall backup time-stamp file

FIREWALL_SOURCE=/etc/Firewall # file path of live firewall config files directory

FIREWALL_DESTINATION=/home/techlab/infrastructure/backups/firewall_backups/current_backup/content # file path of firewall temp destination directory

IPTABLES_SOURCE=/etc/iptables # file path of iptables config files

IPTABLES_FILE=/etc/iptablerules.fw # file path of iptables file

NETPLAN_LOGFILE=/home/techlab/infrastructure/backups/netplan_backups/create_backup.log # file path of netplan copy log file

NETPLAN_DATEFILE=/home/techlab/infrastructure/backups/netplan_backups/current_backup/backup_date.log # file path of netplan backup time-stamp file

NETPLAN_SOURCE=/etc/netplan/* # file path of live netplan config files

NETPLAN_DESTINATION=/home/techlab/infrastructure/backups/netplan_backups/current_backup/content # file path of netplan temp destination directory

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
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create/complete a full backup of $DHCP_SOURCE\n$SPACER" >> $DHCP_LOGFILE # write error message to log file
fi

echo -e "This backup was created on $DATE" > $DHCP_DATEFILE # write date/time to time-stamp file

###################################################################################################
# v back up DNS config files v                                                                    #
###################################################################################################

mkdir -p $DNS_DESTINATION # create directory to copy dns config files to if it does not exist

touch $DNS_LOGFILE # create log file if it does not exist

touch $DNS_DATEFILE # create backup time-stamp file if it does not exist

cp -R $DNS_SOURCE $DNS_DESTINATION 2>> $DNS_LOGFILE # copy dns config source files to destination directory & log any errors

cp $RESOLVE_SOURCE $DNS_DESTINATION 2>> $DNS_LOGFILE # copy dns resolve source file to destination directory & log any errors

if [ $? -eq 0 ]; then # if file copy successful
	echo -e "$DATE : $DNS_SOURCE copied to $DNS_DESTINATION\n$SPACER" >> $DNS_LOGFILE # write success message to log file
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create/complete a full backup of $DNS_SOURCE\n$SPACER" >> $DNS_LOGFILE # write error message to log file
fi

echo -e "This backup was created on $DATE" > $DNS_DATEFILE # write date/time to time-stamp file

###################################################################################################
# v back up Firewall config files v                                                               #
###################################################################################################

mkdir -p $FIREWALL_DESTINATION # create directory to copy firewall config files to if it does not exist

touch $FIREWALL_LOGFILE # create log file if it does not exist

touch $FIREWALL_DATEFILE # create backup time-stamp file if it does not exist

cp -R $FIREWALL_SOURCE $FIREWALL_DESTINATION 2>> $FIREWALL_LOGFILE # copy firewall config source files to destination directory & log any errors

cp -R $IPTABLES_SOURCE $FIREWALL_DESTINATION 2>> $FIREWALL_LOGFILE # copy iptables config source files to destination directory & log any errors

cp $IPTABLES_FILE $FIREWALL_DESTINATION 2>> $FIREWALL_LOGFILE # copy iptables config source file to destination directory & log any errors

if [ $? -eq 0 ]; then # if file copy successful
	echo -e "$DATE : $FIREWALL_SOURCE copied to $FIREWALL_DESTINATION\n$SPACER" >> $FIREWALL_LOGFILE # write success message to log file
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create/complete a full backup of $FIREWALL_SOURCE\n$SPACER" >> $FIREWALL_LOGFILE # write error message to log file
fi

echo -e "This backup was created on $DATE" > $FIREWALL_DATEFILE # write date/time to time-stamp file

###################################################################################################
# v back up netplan config files v                                                                #
###################################################################################################

mkdir -p $NETPLAN_DESTINATION # create directory to copy netplan config files to if it does not exist

touch $NETPLAN_LOGFILE # create log file if it does not exist

touch $NETPLAN_DATEFILE # create backup time-stamp file if it does not exist

cp -R $NETPLAN_SOURCE $NETPLAN_DESTINATION 2>> $NETPLAN_LOGFILE # copy netplan config source files to destination directory & log any errors

if [ $? -eq 0 ]; then # if file copy successful
	echo -e "$DATE : $NETPLAN_SOURCE copied to $NETPLAN_DESTINATION\n$SPACER" >> $NETPLAN_LOGFILE # write success message to log file
else # if file copy unsuccessful
	echo -e "$DATE : Unable to create/complete a full backup of $NETPLAN_SOURCE\n$SPACER" >> $NETPLAN_LOGFILE # write error message to log file
fi

echo -e "This backup was created on $DATE" > $NETPLAN_DATEFILE # write date/time to time-stamp file

# end script