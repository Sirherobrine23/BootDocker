FROM debian:latest AS core
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update && apt upgrade -y && apt install -y linux-image-amd64 systemd-sysv
RUN apt install -y curl wget mingetty
COPY ./CudoInstall.sh /bin/CudoInstaller
ENV CUDOORG="russian-harrier"
RUN bash /bin/CudoInstaller
RUN mkdir -p /etc/systemd/system/getty@tty1.service.d
COPY ./TTy.conf /etc/systemd/system/getty@tty1.service.d/override.conf
RUN systemctl enable getty@tty1.service