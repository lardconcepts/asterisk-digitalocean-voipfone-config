#!/bin/bash
# PLEASE EDIT THE SSH PORT A FEW LINES BELOW TO MATCH 
# WHAT YOU CHANGED IT TO!

EXIF="eth0"

/sbin/iptables --flush
/sbin/iptables --policy INPUT DROP
/sbin/iptables --policy OUTPUT ACCEPT
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -i $EXIF -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
/sbin/iptables -A INPUT -f -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL ALL -j REJECT
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
/sbin/iptables -A INPUT -p tcp -i $EXIF --dport 2525 -m state --state NEW -j ACCEPT

# Allow connections from my machines - first me then voipfone
/sbin/iptables -A INPUT -p tcp -i $EXIF -m state --state NEW -s 195.189.173.27 -j ACCEPT
/sbin/iptables -A INPUT -p udp -i $EXIF -m state --state NEW -s 195.189.173.27 -j ACCEPT

# Allow icmp input so that people can ping us
/sbin/iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW -j ACCEPT

# Log then drop any packets that are not allowed. You will probably want to turn off the logging
# /sbin/iptables -A INPUT -j LOG
/sbin/iptables -A INPUT -j REJECT
