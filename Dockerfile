FROM ubuntu:bionic

ENV BIND_USER=bind \
    DATA_DIR=/data \
    DHCP_ENABLED=true \
    INTERFACES= \
    WEBMIN_ENABLED=true

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && apt-get install -y apt-transport-https rsyslog supervisor nano vim zsh gnupg2 wget dnsutils lnav \
 && wget http://www.webmin.com/jcameron-key.asc -qO - | apt-key add - \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bind9 bind9-host webmin isc-dhcp-server \
 && rm -rf /var/lib/apt/lists/*

COPY dhcpd.conf.exemple /etc/dhcp/dhcpd.conf
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /sbin/entrypoint.sh
# RUN touch /etc/network/interfaces
RUN chmod 755 /sbin/entrypoint.sh
RUN chmod 755 /etc/dhcp/dhcpd.conf
RUN touch /var/log/syslog
RUN chown syslog:adm /var/log/syslog

VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
