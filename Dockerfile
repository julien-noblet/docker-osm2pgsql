# DOCKER-VERSION 1.5.0
# VERSION 0.2

FROM postgres:9.4
MAINTAINER julien-noblet



ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV PGSQL_VERSION 9.4
ENV POSTGIS_MAJOR 2.1
ENV POSTGIS_VERSION 2.1.7+dfsg-3~94.git954a8d0.pgdg80+1
ENV OSM2PGSQL_VERSION 0.88.0


RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
                        postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
                        postgis=$POSTGIS_VERSION &&\
    apt-get install -y  git\
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
                        unzip\
    && rm -rf /var/lib/apt/lists/*

RUN mkdir src

ADD https://github.com/openstreetmap/osm2pgsql/archive/$OSM2PGSQL_VERSION.tar.gz src/
ADD https://github.com/julien-noblet/download-geofabrik/releases/download/v0.0.1/download-geofabrik-linux32.zip src/

RUN cd /root/src/ &&\
    tar -zxvf $OSM2PGSQL_VERSION.tar.gz &&\
    cd osm2pgsql-$OSM2PGSQL_VERSION &&\
    ./autogen.sh &&\
    ./configure &&\
    make &&\
    make install &&\
    cd /root/src/ &&\
    unzip download-geofabrik-linux32.zip &&\
    mv download-geofabrik /usr/bin/ \
    && cd /root &&\
    rm -rf src

ENTRYPOINT ["/bin/bash"]
