FROM ubuntu:14.04

MAINTAINER ywfwj2008 <ywfwj2008@163.com>

RUN apt-get update && \
    apt-get install -y python-pip python-m2crypto git-core iptables
RUN pip install cymysql
RUN git clone -b manyuser https://github.com/breakwa11/shadowsocks.git /home/shadowsocks
    #git clone -b manyuser https://github.com/mengskysama/shadowsocks.git /home/shadowsocks
    #git clone -b manyuser https://github.com/mengskysama/shadowsocks-rm.git /home/shadowsocks

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 50000-60000

# Configure container to run as an executable
ENTRYPOINT ["/run.sh"]
CMD ["server.py"]
