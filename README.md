# Envoy Proxy Playground
 
This repository was created to serve as a sandbox for experimenting with Envoy Proxy built using Docker Compose.  Three containers, `client`, `proxy`, and `server` work together to interact with the proxy.

* Client - container provides a terminal for performing network activities intended to manipulate and verify proxy behavior
* Proxy - container running Envoy Proxy
* Server - container hosting a Flask web application

Features:

* Support for iptables networking control from the client 
* Dynamic configuration updating and validation
* Hot-restarting Envoy Proxy with a new configuration

## Default Configuration

Out of the box, outbound traffic on port `80` from the `client` is routed to the `proxy` on port `10000` via an `iptables` rule where the `proxy` redirects non-whitelisted domains to the `server` container on port `80`.

```
      ┌──────────┐                         ┌──────────┐
      │ proxy    │  host rewrite port 80   │ server   │
      │          ├────────────────────────►│          │
      │          │                         │          │
      └──────────┘                         └─────┬────┘
           ▲                                     │
inbound    │                                     │ server response
port 10000 │             ┌─────────┐             │ to client
           │  (iptables) │ client  │             │
           └─────────────┤         │◄────────────┘
               outbound  │         │
               port 80   └─────────┘
```

```text
(client) $ curl -i http://www.github.com
HTTP/1.1 200 OK
content-type: text/html; charset=utf-8
content-length: 13
server: envoy
date: Fri, 17 Dec 2021 19:25:49 GMT
x-envoy-upstream-service-time: 5

envoy redirects to server container: 1
```

## Included in the Repo

The files in this repository and their purpose are described here.

```Text
./
├─ client/
│  ├─ Dockerfile ........ Docker build instructions
│  └─ client.py ......... Python application that waits for SIGTERM to keep container running
├─ proxy/
│  ├─ Dockerfile ........ Docker build instructions
│  ├─ envoy.yaml ........ Envoy Proxy configuration
│  └─ proxy.py .......... Python application to handle (hot-re)starting Envoy Proxy
├─ server/
│  ├─ Dockerfile ........ Docker build instructions
│  ├─ requirements.txt .. Package requirements for Flask web app
│  └─ server.py ......... Web server application
├─ .gitignore ........... Git untracked files list
├─ README.md ............ This file
├─ connect_client.sh .... Script for establishing an interactive TTY in the client container
├─ connect_proxy.sh ..... Script for establishing an interactive TTY in the proxy container
├─ connect_server.sh .... Script for establishing an interactive TTY in the server container
├─ docker-compose.yaml .. Docker container definitions
├─ hot_restart_proxy.sh . Script to perform Envoy hot restart
├─ push_proxy_config.sh . Script to publish a new Envoy config to the proxy container
└─ setup_iptables.sh .... Script for configuring iptables rules on the client container
```

## Brining up the Containers

Docker Compose is used for bringing up the containers.

```shell
$ docker compose up --build
```

## Configuring the Client

Once the containers are running, you can configure the client's routing tables using the provided shell script.

```shell
$ ./setup_iptables.sh
```

The script works by finding the IP address of the `proxy` container, connecting to the `client` container, and writing the iptables rule(s).

## Connecting and Testing

After applying the iptables rules, you can connect to the `client` container and use `curl` for testing traffic and proxy behavior.

```shell
$ ./connect_client.sh
```

Once connected:

```shell
$ curl -i http://www.github.com
```

## Updating the Envoy Config

Modify the `envoy.yaml` file in the `proxy` directory on the host computer with your desired changes and push the config.

```shell
$ ./push_envoy_config.sh
```

Verify the config is valid looking for a configuration ok message in the output:

```shell
configuration '/etc/envoy/envoy.yaml' OK
```

## Hot-Restarting Envoy

The `hot_restart_proxy.sh` script connects to the `proxy` container and sends the `SIGHUP` signal which causes the Python application to initiate a hot restart.

```
$ ./hot_restart_proxy.sh
```

## Stopping the Containers

```shell
$ docker compose down
```
