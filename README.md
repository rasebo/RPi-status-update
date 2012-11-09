RPi-status-update
=================

Bash script to email new ip &amp; system info on reboot. 
I'm using it on my Raspberry Pi Raspbian, can be used on any distro as long as email and env vars are adjusted.

Prereqs: MTA setup and nmap

2DOs:

-email only the latest offline logs, and only if connectivity was lost, include logs in status update mail

