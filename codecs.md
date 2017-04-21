# Who supports what codecs

As of 21/04/2017 sip2sip, Chrome, Firefox and Edge supports G722

Voipfone does not

### Voipfone 

```
a=rtpmap:8 PCMA/8000
a=rtpmap:111 G726-32/8000
a=rtpmap:97 iLBC/8000
a=rtpmap:3 GSM/8000
a=rtpmap:110 speex/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
```

### Asterisk

```
5 audio g726  g726(G.726 RFC3551)
3 audio alaw  alaw(G.711 a-law)
1 audio g723  g723(G.723.1)
19 audio speex speex     (SpeeX)
20 audio speex speex16   (SpeeX 16khz)
21 audio speex speex32   (SpeeX 32khz)
23 audio g722  g722(G722)
18 audio g729  g729(G.729A)
22 audio ilbc  ilbc(iLBC)
37 text  red   red(T.140 Realtime Text with redundancy)
38 text  t140  t140(Passthrough T.140 Realtime Text)
28 audio opus  opus(Opus Codec)
29 image jpeg  jpeg(JPEG image)
```
