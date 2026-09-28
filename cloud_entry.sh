#!/bin/bash
set -u
cd /opt 2>/dev/null || cd /tmp
rm -rf golf-stream-master
curl -fsSL https://github.com/kidcohen/golf-stream/archive/refs/heads/master.tar.gz | tar xz
cd golf-stream-master
(python3 -m http.server 8000 >/tmp/web.log 2>&1 &)
sleep 3
exec google-chrome --kiosk --no-first-run --disable-infobars --start-fullscreen --use-gl=egl --password-store=basic "http://127.0.0.1:8000/index.html"
