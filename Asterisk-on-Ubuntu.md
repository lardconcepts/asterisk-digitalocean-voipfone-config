# Installing Asterisk PBX 18 on Ubuntu 20.04
# Now with [video guide](https://youtu.be/h12NkJQwpYo)

(With thanks to Peter Wallis for testing and pointing out a couple of things).

## Get yourself a VPS

You can use any small VPS for around $5 per month, but if using Amazon EC2, don't go below t3a small at least while building Asterisk.

Connect via shh and then...

```
apt update;apt full-upgrade -y
```

Let's correct the timezone:

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

Log back in and continue...

```
cd /usr/src
sudo wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
sudo tar xvfz asterisk-18-current.tar.gz
cd  "$(\ls -1dt ./ast*/ | head -n 1)" # cd to directory created just above
```

For the FIRST TIME you install Asterisk only

```
cd contrib/scripts
sudo ./install_prereq install
sudo ./install_prereq install-unpackaged # although this seems to fail 
```

For subsequent installs

```
sudo contrib/scripts/get_mp3_source.sh #If you want mp3 support
sudo ./configure
```

You have two choices for option selection - the first is the interactive version 

```
sudo make menuselect
```

- go to Add-ons and choose mp3 if required
- Install the extra sounds you want, remember we're in the UK, using G711a, so for example CORE-SOUNDS-EN_GB-ALAW and the extra sounds, too. 

When done, press s to save. Now continue - the first line is the compile - takes a few minutes.



Alternatively, you can use 100% automated and command line version, if you know what you want. For more details see https://wiki.asterisk.org/wiki/display/AST/Using+Menuselect+to+Select+Asterisk+Options

```
sudo make menuselect.makeopts
sudo menuselect/menuselect --enable format_mp3 menuselect/menuselect.makeopts
```



Note: If building on a VPS, do ```menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts```. See [this](https://wiki.asterisk.org/wiki/display/AST/Building+and+Installing+Asterisk#BuildingandInstallingAsterisk-Buildingfornon-nativearchitectures) for more info.


**IMPORTANT - if updating and not building for the first time, then just `make && make install` - do not do `make config && make samples` as you will over-write your previous config**

```
sudo make
# sudo make config && sudo make samples && sudo make install-logrotate # do this ONLY first time install!
sudo make install
# sudo make progdocs # not really needed
sudo asterisk
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


## Ignore this bit

```
# apt install build-essential git-core pkg-config subversion autoconf automake libtool libxml2-dev libxslt1-dev libncurses5-dev libneon27-dev libsrtp0-dev uuid uuid-dev libsqlite3-dev libgnutls-dev libjansson-dev libcurl4-openssl-dev flac libio-socket-ssl-perl libjson-any-perl libedit-dev
```
