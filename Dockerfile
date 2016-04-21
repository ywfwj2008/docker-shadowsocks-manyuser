FROM ubuntu:14.04

MAINTAINER ywfwj2008 <ywfwj2008@163.com>

RUN apt-get update && \
    apt-get install -y python-pip python-m2crypto git-core
RUN pip install cymysql
RUN cd /home && \
    #git clone -b manyuser https://github.com/mengskysama/shadowsocks.git /home/shadowsocks
    #git clone -b manyuser https://github.com/mengskysama/shadowsocks-rm.git /home/shadowsocks
    git clone -b manyuser https://github.com/breakwa11/shadowsocks.git /home/shadowsocks


# Configure container to run as an executable
# nohup python /home/shadowsocks-rm/shadowsocks/server.py &
# ENTRYPOINT ["/usr/bin/python","/home/shadowsocks/server.py"]