FROM ubuntu:latest

ENV MOSQUITTO_VERSION=1.5.4

RUN set -x
RUN apt-get update && apt-get install -y --no-install-recommends \
    libc-ares-dev git libmysqlclient-dev libssl-dev uuid-dev build-essential wget ca-certificates \
    curl libcurl4-openssl-dev libc-ares2 libcurl4 libwebsockets-dev

RUN cd /tmp \
    && wget http://mosquitto.org/files/source/mosquitto-$MOSQUITTO_VERSION.tar.gz -O mosquitto.tar.gz \    
    && mkdir mosquitto-src && tar xfz mosquitto.tar.gz --strip-components=1 -C mosquitto-src \
    && cd mosquitto-src \
    && make WITH_SRV=yes WITH_MEMORY_TRACKING=no WITH_WEBSOCKETS=yes \
    && make install && ldconfig

RUN git clone https://github.com/jpmens/mosquitto-auth-plug.git \        
    && cd mosquitto-auth-plug \
    && cp config.mk.in config.mk \
    && sed -i "s/BACKEND_HTTP ?= no/BACKEND_HTTP ?= yes/" config.mk \
    && sed -i "s/BACKEND_MYSQL ?= yes/BACKEND_MYSQL ?= no/" config.mk \
    && sed -i "s/CFG_LDFLAGS =/CFG_LDFLAGS = -lcares/" config.mk \
    && sed -i "s/MOSQUITTO_SRC =/MOSQUITTO_SRC = \/tmp\/mosquitto-src\//" config.mk \
    && make \
    && cp np /usr/bin/np \
    && mkdir /mqtt && cp auth-plug.so /mqtt/ \
    && cp auth-plug.so /usr/local/lib/ 

RUN useradd -r mosquitto \
    && apt-get purge -y build-essential git wget ca-certificates \
    && apt-get autoremove -y \
    && apt-get -y autoclean \
    && rm -rf /var/cache/apt/* \
    && rm -rf /tmp/*

ADD mosquitto.conf /etc/mosquitto/mosquitto.conf

EXPOSE 1883 9001

ADD run.sh run.sh
RUN chmod +x run.sh
ENTRYPOINT ["./run.sh"]
CMD ["mosquitto-verbose"]