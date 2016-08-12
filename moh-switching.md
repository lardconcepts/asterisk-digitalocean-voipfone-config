To use this demo:

    apt install crudini

Visit http://www.voicerss.org/ and get a free key and put it in the appropriate section below

```
[streamdemo]
exten => s,1,Set(radioarray=R.N.I.B.%20Connect,Eh.C.B.%20Radio,Mushroom%20F.M.,The%20VIP%20Lounge)
exten => s,2,Gosub(streammenu,1,1)
exten => _[2345],1,Dial(Local/${EXTEN}@play-radio,,gH(play-radio^${EXTEN}^2))
same => n,Goto(s,2)
exten => _[X,t,i],1,Goto(s,2)

[streammenu]
exten => 1,1,NoOp()
same => n,Set(n=2)
same => n,While($["${SET(station=${SHIFT(radioarray)})}" != ""])
same => n,BackGround(dir-multi1&digits/${n}&dir-multi2)
same => n,BackGround(/tmp/${station})
same => n,Set(n=$[${n}+1])
same => n,GoSubIf($["${BACKGROUNDSTATUS}"="FAILED"]?makespeech,1,1)
same => n,EndWhile
same => n,BackGround(vm-starmain)
same => n,WaitExten
exten => _[t,i],1,Goto(streamdemo,s,1)
exten => _N,1,Goto(streamdemo,${EXTEN},1)


[makespeech]
exten => 1,1,NoOp()
same => n,set(voicersskey=XXXXX ) ; GET FREE KEY FROM http://www.voicerss.org/
same => n,set(voiceurl="http://api.voicerss.org/?c=wav&f=alaw_8khz_mono&hl=en-gb&key=${voicersskey}&src=${station}")
same => n,System(/usr/bin/wget ${voiceurl} -O /tmp/${station}.al )
same => n,Wait(2)
same => n,BackGround(/tmp/${station})
same => n,Return()

[play-radio]
exten => _N,1,Answer
same => n,Set(lastmenu=${EXTEN})
same => n,Gosub(setmohvars,${EXTEN},1)
same => n,Gosub(setmoh,s,1)
same => n,Playback(connecting) ;  give it time to setup
same => n,MusicOnHold(${CALLERID(name)}${EXTEN})
exten => h,1,Gosub(clearmoh,${EXTEN},1)
exten => _[X,t,i],1,Return()

[setmohvars]
exten => 2,1,Set(streamvar="http://185.14.85.162:8020") ; rnib connect
same => n,Return()
exten => 3,1,Set(streamvar="http://stream.acbradio.org:8000/mainstream.mp3") ; acb
same => n,Return()
exten => 4,1,Set(streamvar="http://199.180.75.28:80") ; mushroom
same => n,Return()
exten => 5,1,Set(streamvar="http://206.225.87.121:8000/") ; VIP lounge
same => n,Return()
exten => _[X,t,i],1,Return()

[setmoh]
exten => s,1,System(/usr/bin/crudini --set /etc/asterisk/musiconhold.conf ${CALLERID(name)}${lastmenu} mode custom)
same => n,System(/usr/bin/crudini --set /etc/asterisk/musiconhold.conf ${CALLERID(name)}${lastmenu} application "/usr/bin/mpg123 -q -r 8000 -f 32768 --mono -s ${streamvar}")
same => n,System(/usr/sbin/asterisk -x "moh reload")
same => n,Return()

[clearmoh]
exten => h,1,NoOp()
same => n,System("/usr/bin/crudini --del /etc/asterisk/musiconhold.conf ${CALLERID(name)}${lastmenu}")
same => n,Return()
```
