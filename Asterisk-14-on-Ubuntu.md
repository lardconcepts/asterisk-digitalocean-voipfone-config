# Installing Asterisk PBX 14.4 on Ubuntu 17.04
# Now with [video guide](https://youtu.be/h12NkJQwpYo)

(With thanks to Peter Wallis for testing and pointing out a couple of things).

## Get yourself a VPS

I'm going to be using a $5/month London-based DigitalOcean droplet here - if you find this guide useful or need a VPS to experiment with, [sign-up via this link](https://www.digitalocean.com/?refcode=3e12153ab02b) and you'll get $10 credit (ie: 2 months) and if you stick around after that, I get a little bonus too!

Fire up a $5/month Ubuntu 16.10 x64 image in the London region.
Leave all the other boxes unticked, especially IPv6.

Connect via PuTTY. Let's correct the timezone:

````
sudo dpkg-reconfigure tzdata
/etc/init.d/cron restart
````

## Basic security

Now let's change that SSH port with `nano /etc/ssh/sshd_config`

replace Port 22 with some other number like Port 2525 and then do `service ssh restart`

Logout, change the port in PuTTY and log back in. 

So, connect to your VPS and let's install the basics plus a couple of useful extras:

## Install Asterisk

Code:
```
apt update;apt full-upgrade -y
apt install build-essential git-core pkg-config subversion autoconf automake libtool libxml2-dev libxslt1-dev libncurses5-dev libneon27-dev libsrtp0-dev uuid uuid-dev libsqlite3-dev libgnutls-dev libjansson-dev libcurl4-openssl-dev flac libio-socket-ssl-perl libjson-any-perl 
```

Log back in and continue...

```
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz
tar xvfz asterisk-14-current.tar.gz
cd asterisk-*
contrib/scripts/get_mp3_source.sh #If you want mp3 support
./configure --with-pjproject-bundled
make menuselect
```

Note: If building on a VPS, do ```menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts```. See [this](https://wiki.asterisk.org/wiki/display/AST/Building+and+Installing+Asterisk#BuildingandInstallingAsterisk-Buildingfornon-nativearchitectures) for more info.

    

- go to Add-ons and choose mp3 if required
- go to channel drivers and deselect sip from the EXTENDED menu below
- Don't need dahdi unless directly connecting "real" phones to your server
- Install the extra sounds you want, remember we're in the UK, using G711a, so for example CORE-SOUNDS-EN_GB-ALAW and the extra sounds, too. 

When done, press s to save. Now continue - the first line is the compile - takes a few minutes.

**IMPORTANT - if updating and not building for the first time, then replace the first line with just `make && make install` - do not do `make config && make samples` as you will over-write your previous config**

```
make && make install && make config && make samples && make install-logrotate
asterisk
asterisk -rvvvddd
```

Note that asterisk autostarts at boot time, so you'll normally just need `asterisk -rvvvddd`  

Just test things with `reboot`

## Reconfiguring/rebuilding in the future

    make distclean
    
## Firewall!

For basic testing, just make a file called firewall.sh, put [this](https://github.com/lardconcepts/asterisk-digitalocean-voipfone-config/blob/master/firewall.sh) in it, and then `sh firewall.sh`
Once you're happy with it, to make it persist after a reboot then  `apt install iptables-persistent`. If you change the rules in the future, then to update, just `sudo iptables-save | sudo tee /etc/iptables/rules.v4`    
    
And then start from the `make menuselect` above

## Hints and Tips

Use the Asterisk Syntax Highliter in Notepad++
https://github.com/xilitium/Asterisk-Dialplan-Syntax-Highlighting
http://www.xilitium.com/blog/2/asterisk-dialplan-syntax-highlighting-for-notepad-plus-plus


