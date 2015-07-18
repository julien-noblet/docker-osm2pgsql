# DOCKER-VERSION 1.5.0
# VERSION 0.2

FROM mdillon/postgis:9.4
MAINTAINER James Badger <james@jamesbadger.ca>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y  git\
                        git-core\
                        autoconf\
                        automake\
                        g++\
                        make\
                        libtool\
                        liblua5.2-dev\
                        lua5.2\
                        libboost-dev\
                        libboost-filesystem-dev\
                        libboost-system-dev\
                        libboost-thread-dev\
                        libbz2-dev\
                        libgeos++-dev\
                        libgeos-dev\
                        libpq-dev\
                        libproj-dev\
                        libprotobuf-c0-dev\
                        protobuf-c-compiler\
                        libxml2-dev\
                        ca-certificates\
                        libpsl0\
                        unzip

RUN rm -rf /var/lib/apt/lists/*

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.88.0

RUN mkdir src

ADD https://github.com/openstreetmap/osm2pgsql/archive/$OSM2PGSQL_VERSION.tar.gz src/

RUN cd src &&\
    tar -zxvf $OSM2PGSQL_VERSION.tar.gz &&\
    cd osm2pgsql-$OSM2PGSQL_VERSION &&\
    ./autogen.sh &&\
    ./configure &&\
    make &&\
    make install

ADD https://github.com/julien-noblet/download-geofabrik/releases/download/v0.0.1/download-geofabrik-linux32.zip src/
RUN cd src &&\
    unzip download-geofabrik-linux32.zip &&\
    mv download-geofabrik /usr/bin/

RUN cd /root &&\
    rm -rf src

ENTRYPOINT ["/bin/bash"]
