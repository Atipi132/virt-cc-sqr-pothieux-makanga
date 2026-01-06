FROM debian:latest

RUN apt update && apt install -y apt-transport-https 
RUN apt -y install bash htop vim net-tools

RUN useradd nonroot
USER nonroot

ENV OWNER "Hugo"

CMD sleep 3600
