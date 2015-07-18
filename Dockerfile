# DOCKER-VERSION 1.5.0
# VERSION 0.2

FROM mdillon/postgis:9.4
MAINTAINER James Badger <james@jamesbadger.ca>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y git git-core
RUN apt-get install -y autoconf automake g++ make
RUN apt-get install -y libtool
RUN apt-get install -y liblua5.2-dev lua5.2
RUN apt-get install -y libboost-dev
RUN apt-get install -y libboost-filesystem-dev
RUN apt-get install -y libboost-system-dev
RUN apt-get install -y libboost-thread-dev
RUN apt-get install -y libbz2-dev
RUN apt-get install -y libgeos++-dev libgeos-dev
RUN apt-get install -y libpq-dev
RUN apt-get install -y libproj-dev
RUN apt-get install -y libprotobuf-c0-dev protobuf-c-compiler
RUN apt-get install -y libxml2-dev
RUN apt-get install -y unzip

RUN rm -rf /var/lib/apt/lists/*

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.88.0

RUN mkdir src

ADD https://github.com/openstreetmap/osm2pgsql/archive/$OSM2PGSQL_VERSION.tar.gz  src/

RUN cd src && tar -zxvf $OSM2PGSQL_VERSION.tar.gz


RUN cd src/osm2pgsql-$OSM2PGSQL_VERSION &&\
    ./autogen.sh &&\
    ./configure

RUN cd src/osm2pgsql-$OSM2PGSQL_VERSION && make
RUN cd src/osm2pgsql-$OSM2PGSQL_VERSION && make install

ADD https://github.com/julien-noblet/download-geofabrik/releases/download/v0.0.1/download-geofabrik-linux32.zip src/
RUN cd src && unzip download-geofabrik-linux32.zip && mv download-geofabrik /usr/bin/

RUN    cd /root &&\
    rm -rf src

ENTRYPOINT ["/bin/bash"]
