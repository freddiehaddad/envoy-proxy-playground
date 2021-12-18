# syntax=docker/dockerfile:1

FROM envoyproxy/envoy-dev:latest

WORKDIR /proxy

COPY envoy.yaml /etc/envoy/envoy.yaml
COPY proxy.py proxy.py
RUN apt update && apt install -y python3

CMD ["python3", "/proxy/proxy.py"]
