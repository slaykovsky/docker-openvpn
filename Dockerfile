# Original credit: https://github.com/jpetazzo/dockvpn
# Forked from: https://github.com/kylemanna/docker-openvpn

# Smallest base image
FROM debian:8

MAINTAINER Alexey Slaykovsky <alexey@slaykovsky.com>

RUN echo "deb http://deb.i2p2.no/ jessie main" >> /etc/apt/sources.list.d/i2p.list && \
    echo "deb-src http://deb.i2p2.no/ jessie main" >> /etc/apt/sources.list.d/i2p.list && \
    apt update && apt install -y --force-yes i2p-keyring && apt full-upgrade -y && \
    apt install -y --force-yes openvpn iptables easy-rsa tor i2p unbound privoxy && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apt/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

WORKDIR /etc/openvpn
CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
