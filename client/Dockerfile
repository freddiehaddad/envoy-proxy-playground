# syntax=docker/dockerfile:1

FROM python:3.10-slim-bullseye

WORKDIR /client

COPY client.py client.py
RUN apt update && apt install -y curl iptables python3

# Workaround for docker issue: 2331
# https://github.com/moby/libnetwork/issues/2331
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

CMD ["python3", "/client/client.py"]
