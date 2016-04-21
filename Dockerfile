FROM ubuntu:14.04

MAINTAINER ywfwj2008 <ywfwj2008@163.com>

ENV INSTALL_DIR=/home/shadowsocks

RUN apt-get update && \
    apt-get install -y python-pip python-m2crypto git-core
RUN pip install cymysql
RUN git clone -b manyuser https://github.com/breakwa11/shadowsocks.git $INSTALL_DIR && \
    cp $INSTALL_DIR/config.json $INSTALL_DIR/user-config.json

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 10000-15000

# Configure container to run as an executable
ENTRYPOINT ["/run.sh"]
