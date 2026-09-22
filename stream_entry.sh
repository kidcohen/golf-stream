#!/bin/bash
# Launched by Selkies (START_XDG_APP) inside the GPU desktop: serve the baked
# courses locally, then kiosk Chrome on the library. Chrome stays foreground so
# this shell (and the http server) live for the session.
set -u
cd /opt/courses
# tiny static server so Chrome loads over http (avoids file:// texture quirks)
(python3 -m http.server 8000 >/tmp/web.log 2>&1 &)
sleep 2
exec google-chrome \
  --kiosk --no-first-run --disable-infobars --start-fullscreen \
  --use-gl=egl --enable-features=VaapiVideoEncoder \
  --disable-gpu-vsync --password-store=basic \
  "http://127.0.0.1:8000/index.html"
