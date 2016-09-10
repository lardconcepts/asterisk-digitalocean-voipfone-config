EXIF="eth0"

/sbin/iptables --flush
/sbin/iptables --policy INPUT DROP
/sbin/iptables --policy OUTPUT ACCEPT
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
/sbin/iptables -A INPUT -f -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL ALL -j REJECT
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# change the port below to whatever you changed your ssh port to
/sbin/iptables -A INPUT -p tcp --dport 2525 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp --sport 2525 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Voipfone
/sbin/iptables -A INPUT -p tcp -i $EXIF -m state --state NEW -s 195.189.173.0/24 -j ACCEPT
/sbin/iptables -A INPUT -p udp -i $EXIF -m state --state NEW -s 195.189.173.0/24 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -i $EXIF -m state --state NEW -s 46.31.225.0/24 -j ACCEPT
/sbin/iptables -A INPUT -p udp -i $EXIF -m state --state NEW -s 46.31.225.0/24 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -i $EXIF -m state --state NEW -s 46.31.231.0/24 -j ACCEPT
/sbin/iptables -A INPUT -p udp -i $EXIF -m state --state NEW -s 46.31.231.0/24 -j ACCEPT

# Allow icmp input so that people can ping us
/sbin/iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW -j ACCEPT

# Log then drop any packets that are not allowed. You will probably want to turn off the logging
# /sbin/iptables -A INPUT -j LOG
/sbin/iptables -A INPUT -j REJECT

# run it with sh firewall.sh
# Now save it so that the firewall is active after reboot
# apt install iptables-persistent
# sudo iptables-save | sudo tee /etc/iptables/rules.v4
