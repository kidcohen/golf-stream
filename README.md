# golf-stream

GPU pixel-streaming build for the golf sim. RunPod builds this Dockerfile;
it bakes the course sims in and streams a GPU Chrome kiosk over WebRTC (Selkies/NVENC).
Expose port 8080, env PASSWD. See deploy/PORTABLE_STREAM.md in the main repo.
