# Container running Event Store
#
# VERSION               0.1
FROM ubuntu
MAINTAINER Alexander "iam.asm89@gmail.com"

# make sure the package repository is up to date
RUN apt-get update

# install packages required to build mono and the eventstore
RUN apt-get install -y git subversion
RUN apt-get install -y autoconf automake libtool gettext libglib2.0-dev libfontconfig1-dev mono-gmcs
RUN apt-get install -y build-essential

# download mono 3.1.2
RUN (cd /var/local; curl -O http://download.mono-project.com/sources/mono/mono-3.1.2.tar.bz2)
RUN (cd /var/local; tar -xjvf mono-3.1.2.tar.bz2)

# build and install mono
RUN (cd /var/local/mono-3.1.2; ./configure --prefix=/usr/local; make; make install)

# get eventstore and build it
RUN git clone https://github.com/EventStore/EventStore.git /var/local/EventStore --depth=1
RUN (cd /var/local/EventStore; ./build.sh full configuration=release)

# setup directory structure
ENV EVENTSTORE_OUT /var/local/EventStore/bin/eventstore/release/anycpu
ENV EVENTSTORE_BIN /var/local/EventStore/bin/eventstore/release/anycpu
ENV EVENTSTORE_DB /opt/eventstore/db
ENV EVENTSTORE_LOG /opt/eventstore/logs

# make directories
RUN mkdir -p $EVENTSTORE_BIN
RUN mkdir -p $EVENTSTORE_LOG
RUN mkdir -p $EVENTSTORE_DB

# expose LD library path
ENV LD_LIBRARY_PATH $EVENTSTORE_BIN

# export the http and tcp port
EXPOSE 2113
EXPOSE 1113

# set entry point to eventstore executable
ENTRYPOINT ["mono-sgen", "/var/local/EventStore/bin/eventstore/release/anycpu/EventStore.SingleNode.exe", "--log=/opt/eventstore/logs", "--db=/opt/eventstore/db"]

# bind it to all interfaces by default
CMD ["--ip=0.0.0.0", "--http-prefix=http://*:2113/"]
