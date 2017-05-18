# docker-nmcontrol

Automated dockerhub build for [NMControl](https://github.com/namecoin/nmcontrol)

## Prerequisites

### Start a docker namecoin container.
See https://github.com/acejam/docker-namecoin
Make sur docker instance of namecoin container has name 'namecoin'

## How to launch

```
./build_local.sh

./create-docker-network.sh

./run-nmcontrol-docker.sh namecoin

```
