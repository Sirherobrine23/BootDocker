FROM debian:latest AS core
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update && apt upgrade -y && apt install -y linux-image-amd64 systemd-sysv
