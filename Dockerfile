# version 1.0

FROM ubuntu:latest
MAINTAINER Jose G. Faisca <jose.faisca@gmail.com>

ENV IMAGE nmcontrol/nmcontrol 

# -- NMcontrol configuration variable --
ENV NM_DNS_HOST 127.0.0.1
ENV NM_DNS_PORT 5333
ENV NM_DNS_RESOLVER1 8.8.8.8
ENV NM_DNS_RESOLVER2 8.8.4.4
ENV NM_DNS_DISABLE_STD_LOOKUPS 0
ENV NM_HTTP_HOST 127.0.0.1
ENV NM_HTTP_PORT 8080
ENV NM_RPC_HOST 127.0.0.1
ENV NM_RPC_PORT 9000
ENV NM_CONF_DIR /etc/nmcontrol/conf

# -- Namecoin configuration variables --
ENV RPC_USER rpc
ENV RPC_PASS secret
ENV RPC_PORT 8336
ENV RPC_CONNECT 127.0.0.1
ENV NMC_DATA_DIR /data/namecoin

# -- PATH --   
ENV PATH /usr/local/bin/nmcontrol:$PATH

# -- Terminal --
ENV TERM xterm

ARG DEBIAN_FRONTEND=noninteractive

# -- Install main independencies -- 
RUN apt-get update && apt-get install -y \
curl git python python-pip iproute2 dnsutils \ 
	&& pip install --upgrade pip \
	&& pip install bottle 

# -- Install NMcontrol --
RUN cd /usr/local/bin \
	&& git clone https://github.com/namecoin/nmcontrol/ \
	&& mkdir -p /etc/nmcontrol/conf

# -- Clean --
RUN cd / \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY run.sh /usr/local/bin/
ENTRYPOINT ["run.sh"]

EXPOSE $NM_DNS_PORT/udp $NM_HTTP_PORT/tcp $NM_RPC_PORT/tcp
VOLUME ["$NM_CONF_DIR", "$NMC_DATA_DIR"]
CMD ["nmcontrol.py", "--daemon=0", "--debug=0", "--confdir=/etc/nmcontrol/conf", "start"]
