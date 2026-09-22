# Portable GPU pixel-streamer for the golf sim — runs on ANY GPU host
# (RunPod, Lambda, Vast.ai, or a rented GPU box). No GCP dependency: the built
# courses are baked into the image. GPU-accelerated headless Chrome kiosks the
# course library and Selkies streams it over WebRTC (NVENC) to any browser.
#
# Build (from this folder, which holds the *.html sims):
#   docker build -t <yourname>/golf-stream:latest .
# Run locally on a GPU box:
#   docker run -d --gpus all --shm-size=2g -p 8080:8080 \
#     -e PASSWD=golfstream25 <yourname>/golf-stream:latest
# Then open https://<host-ip>:8080  (basic auth: user "ubuntu" / PASSWD).
FROM ghcr.io/selkies-project/nvidia-egl-desktop:24.04
USER root

# Bake the built course sims + launcher into the image
RUN mkdir -p /opt/courses
COPY index.html /opt/courses/index.html
COPY *.html /opt/courses/
COPY stream_entry.sh /opt/stream_entry.sh
RUN chmod +x /opt/stream_entry.sh

# Selkies WebRTC config: NVENC h264, resize on, TCP TURN for restrictive nets.
# One GPU packs many concurrent sessions (NVENC has no session cap).
ENV SELKIES_ENCODER=nvh264enc \
    SELKIES_ENABLE_RESIZE=true \
    SELKIES_PORT=8080 \
    SELKIES_TURN_PROTOCOL=tcp \
    SIZEW=1600 SIZEH=900 REFRESH=60 TZ=UTC \
    START_XDG_APP="/opt/stream_entry.sh"

EXPOSE 8080
