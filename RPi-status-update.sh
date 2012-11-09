#!/bin/bash
#simple script for checking your RPi's external IP address 
#emails are being sent to an address with both offline logs and new system info
#modify the vars below with your data (log file, stats file, email, binary paths)

#files, email address, ip check address
#script_location="$HOME/external_ip.sh"
log_file="$HOME/RPi-status-update.log"
stats_file="/tmp/rpi-stats-file"
email_addr="your.email.addr@domain.com"
icmp_check_addr="google.com"
#--

#variables for binary locations
wget="/usr/bin/wget"
echo="/bin/echo"
mail="/usr/bin/mail"
ping="/bin/ping"
egrep_cmd="/bin/egrep"
date="/bin/date"
sleep_cmd="/bin/sleep"
#--

status=`$ping -c 1 $icmp_check_addr 2>&1 | $egrep_cmd -c "\<unknown\>|\<unreachable\>"`

if [ $status -eq 1 ]; then
    echo "=================================" >> $log_file 
until [ $status -eq 0 ]; do
    status=`$ping -c 1 $icmp_check_addr 2>&1 | $egrep_cmd -c "\<unknown\>|\<unreachable\>"`
    $echo -n "Offline - " >> $log_file
    $date >> $log_file
    $sleep_cmd 30
done
fi

external_ip=`$wget -q -t 5 --output-document=- "http://automation.whatismyip.com/n09230945.asp"` > /dev/null 2>&1
#$echo -n "" > "$stats_file"
$echo "Un fleac, m-au restartat..." > "$stats_file"
$echo "..." >> "$stats_file"
$echo EXTERNAL IP: "$external_ip" >> "$stats_file"
$echo HOSTNAME: `/bin/hostname` >> "$stats_file"
$echo KERNEL: `/bin/uname -s -v -r -m` >> "$stats_file"
$mail -s "RPi - New IP information" $email_addr < "$stats_file"
$mail -s "RPi - Offline logs" $email_addr < "$log_file" > /dev/null 2>&1 #don't need the output, redirect to /dev/null is for when the logfile is empty

exit 0
