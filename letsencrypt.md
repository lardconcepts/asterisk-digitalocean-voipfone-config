# Installing a letsencrypt certificate
(this is not for voipfone)

Temporarily open the firewall ports

    /sbin/iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
    /sbin/iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

## Install letsencrypt

```
apt install letsencrypt

cd /opt/letsencrypt
./certbot-auto certonly --renew-by-default --email email@host.tld --text --agree-tos -d asterisk.example.com
```

To renew

```
cd /opt/letsencrypt
./certbot-auto renew # (add --dry-run if you want)
```

TLS is a TCP-based protocol.   You need to open tcp on port 5061 ( assuming you're using this port ) 
You do not need udp on 5061. See 
See https://github.com/lardconcepts/asterisk-digitalocean-voipfone-config/blob/master/pjsip.conf for an example of how to use tls transport in pjsip.conf
