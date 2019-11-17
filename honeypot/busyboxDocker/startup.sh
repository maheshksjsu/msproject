#!/bin/sh
/bin/telnetd -S
/bin/syslogd -O /var/spool/messages
while [  1 ];do sleep 1000000;done
