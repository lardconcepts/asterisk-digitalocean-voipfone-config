# Installing Asterisk PBX 13.7.2 on Ubuntu 15.10

(With thanks to Peter Wallis for testing and pointing out a couple of things).

## Get yourself a VPS

I'm going to be using a $5/month London-based DigitalOcean droplet here - if you find this guide useful or need a VPS to experiment with, [sign-up via this link](https://www.digitalocean.com/?refcode=3e12153ab02b) and you'll get $10 credit (ie: 2 months) and if you stick around after that, I get a little bonus too!

Fire up a $5/month Ubuntu 15.10 x64 image in the London region.
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

link to bash script for iptables

So, connect to your VPS and let's install the basics plus a couple of useful extras:

## Install Asterisk

Code:
```
sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get install -y build-essential git-core pkg-config subversion libjansson-dev sqlite autoconf automake libtool libxml2-dev libncurses5-dev unixodbc unixodbc-dev libasound2-dev libogg-dev libvorbis-dev libneon27-dev libsrtp0-dev libspandsp-dev libmyodbc uuid uuid-dev sqlite3 libsqlite3-dev libgnutls-dev htop iftop silversearcher-ag nmap
sudo shutdown -r now
```

Log back in and continue...


```
cd /usr/src/
wget http://www.pjsip.org/release/2.4.5/pjproject-2.4.5.tar.bz2
tar -xjvf pjproject-2.4.5.tar.bz2
cd pjproject-2.4.5/
./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr 
make dep && make && make install
ldconfig
ldconfig -p | grep pj
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz
tar xvfz asterisk-13-current.tar.gz
cd asterisk-*
./configure
contrib/scripts/get_mp3_source.sh #If you want mp3 support
make menuselect
```

- go to Add-ons and choose mp3 if required
- go to channel drivers and deselect sip from the EXTENDED menu below
- Install the extra sounds you want, remember we're in the UK, using G711a, so for example CORE-SOUNDS-EN_GB-ALAW and the extra sounds, too. 

When done, press s to save. Now continue - the first line is the compile - takes a few minutes.

```
make && make install && make config && make samples && make install-logrotate
ldconfig
asterisk
asterisk -rvvvddd
```

Note that asterisk autostarts at boot time, so you'll normally just need `asterisk -rvvvddd`  

## Reconfiguring/rebuilding in the future

    make distclean
    
And then start from the `make menuselect` above

## Hints and Tips

Use the Asterisk Syntax Highliter in Notepad++
https://github.com/xilitium/Asterisk-Dialplan-Syntax-Highlighting
http://www.xilitium.com/blog/2/asterisk-dialplan-syntax-highlighting-for-notepad-plus-plus
