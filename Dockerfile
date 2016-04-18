FROM ubuntu:14.04

MAINTAINER ywfwj2008 <ywfwj2008@163.com>

RUN apt-get update && \
    apt-get install -y python-pip python-m2crypto git-core
RUN pip install cymysql
RUN cd $INSTALL_DIR && \
    git clone -b manyuser https://github.com/mengskysama/shadowsocks-rm.git && \
# RUN nohup python /home/shadowsocks-rm/shadowsocks/server.py &

# Configure container to run as an executable
# ENTRYPOINT ["python","/home/shadowsocks-rm/shadowsocks/server.py"]