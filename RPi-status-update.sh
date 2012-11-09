#!/bin/bash
#simple script for checking your RPi's external IP address 
#emails are being sent to an address with both offline logs and new system info
#modify the vars below with your data (log file, stats file, email, binary paths)

#binary locations
wget="/usr/bin/wget"
echo="/bin/echo"
mail="/usr/bin/mail"
ping="/bin/ping"
egrep_cmd="/bin/egrep"
date="/bin/date"
sleep_cmd="/bin/sleep"
nmap="/usr/bin/nmap"
hostname="/bin/hostname"
who="/usr/bin/w"
cat="/bin/cat"
#files, email address, ip check address
#script_location="$HOME/.rpiupdate/external_ip.sh"
log_file_offline="$HOME/.rpiupdate/rpi-offline.log"
stats_file="$HOME/.rpiupdate/rpi-stats-file"
email_addr="email@domain.com"
icmp_check_addr="google.com"
ip_scan_range="192.168.1.0/24"
memory_total=`$cat /proc/meminfo | awk ' /MemTotal/ { print $2 } '`
memory_free=`$cat /proc/meminfo | awk ' /MemFree/ { print $2 } '`
#icmp status check command
status=`$ping -c 1 $icmp_check_addr 2>&1 | $egrep_cmd -c "\<unknown\>|\<unreachable\>"`
# Search for .rpiupdate folder and create it together with log file and stat file
if [ ! -d $HOME/.rpiupdate/ ]; then
    mkdir $HOME/.rpiupdate/
    touch $log_file_offline
    touch $stats_file
fi
#if there is no icmp reply, add separator to log file and until there's icmp reply, add a log entry every 30 seconds
if [ $status -eq 1 ]; then
    echo "=================================" >> $log_file_offline 
until [ $status -eq 0 ]; do
    status=`$ping -c 1 $icmp_check_addr 2>&1 | $egrep_cmd -c "\<unknown\>|\<unreachable\>"`
    $echo -n "Offline - " >> $log_file_offline
    $date >> $log_file_offline
    $sleep_cmd 30
done
fi
#define internal and external ip vars
external_ip=`$wget -q -t 5 --output-document=- "http://automation.whatismyip.com/n09230945.asp"` > /dev/null 2>&1
internal_ip=`$hostname -I`
#build the file for emailing to $email_addr
#$echo -n "" > "$stats_file"
$echo "Un fleac, m-au restartat..." > "$stats_file"
$echo . >> "$stats_file"
$echo External IP: "$external_ip" >> "$stats_file"
$echo . >> "$stats_file"
$echo Internal IP: "$internal_ip" >> "$stats_file"
$echo . >> "$stats_file"
$echo Hostname: `$hostname` >> "$stats_file"
$echo . >> "$stats_file"
$echo Kernel info: `/bin/uname -s -v -r -m` >> "$stats_file"
$echo . >> "$stats_file"
$echo Total Memory: "$memory_total" kB >> "$stats_file"
$echo . >> "$stats_file"
$echo Free Memory: "$memory_free" kB >> "$stats_file"
$echo . >> "$stats_file"
$echo Who: >> "$stats_file"
$who >> "$stats_file" 
$echo . >> "$stats_file"
$echo -n Local network hosts: >> "$stats_file"
$nmap -sP $ip_scan_range >> "$stats_file"  
#mail logs and stat info
$mail -s "RPi - Status" $email_addr < "$stats_file"
$mail -s "RPi - Offline logs" $email_addr < "$log_file_offline" > /dev/null 2>&1 #don't need the output, redirect to /dev/null is for when the logfile is empty 
#done
exit 0
