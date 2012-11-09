RPi-status-update
=================

Bash script to email new ip &amp; system info upon reboot.

It also mails a log file, so if the host has been disconnected from the 
internet for a certain period of time you know for how long it has been offline.

You need to have a MTA setup on your rpi, either standalone or as a relay.

2do

-install switch that creates .hidden folder in $HOME for logs and file to be mailed

-email only the latest offline logs, and only if connectivity was lost, include logs in status update mail

