#!/bin/bash
#########################################################################
# File Name: run.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: 2015年11月18日 星期三 02时49分12秒
#########################################################################
PATH=/bin:/sbin:$PATH

set -e

if [ -n "$MANYUSER" ]; then
        if [ -z "$MYSQL_PASSWORD" ]; then
                echo >&2 'error:  missing MYSQL_PASSWORD'
                echo >&2 '  Did you forget to add -e MYSQL_PASSWORD=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_USER" ]; then
                echo >&2 'error:  missing MYSQL_USER'
                echo >&2 '  Did you forget to add -e MYSQL_USER=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_PORT" ]; then
                echo >&2 'error:  missing MYSQL_PORT'
                echo >&2 '  Did you forget to add -e MYSQL_PORT=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_HOST" ]; then
                echo >&2 'error:  missing MYSQL_HOST'
                echo >&2 '  Did you forget to add -e MYSQL_HOST=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_DBNAME" ]; then
                echo >&2 'error:  missing MYSQL_DBNAME'
                echo >&2 '  Did you forget to add -e MYSQL_DBNAME=... ?'
                exit 1
        fi

        for i in $MYSQL_USER $MYSQL_PORT $MYSQL_HOST $MYSQL_DBNAME $MYSQL_PASSWORD; do
                if grep '@' <<<"$i" >/dev/null 2>&1; then
                        echo >&2 "error:  missing -e $i"
                        echo >&2 "  You can't special characters '@'"
                        exit 1
                fi
        done

        sed -ri "s@^(MYSQL_HOST = ).*@\1'$MYSQL_HOST'@" $INSTALL_DIR/Config.py
        sed -ri "s@^(MYSQL_PORT = ).*@\1$MYSQL_PORT@" $INSTALL_DIR/Config.py
        sed -ri "s@^(MYSQL_USER = ).*@\1'$MYSQL_USER'@" $INSTALL_DIR/Config.py
        sed -ri "s@^(MYSQL_PASS = ).*@\1'$MYSQL_PASSWORD'@" $INSTALL_DIR/Config.py
        sed -ri "s@^(MYSQL_DB = ).*@\1'$MYSQL_DBNAME'@" $INSTALL_DIR/Config.py
else
        echo >&2 'error:  missing MANYUSER'
        echo >&2 '  Did you forget to add -e MANYUSER=... ?'
        exit 1
fi

if [ "$MANYUSER" = "R" ]; then
        if [ -z "$PROTOCOL" ]; then
                echo >&2 'error:  missing PROTOCOL'
                echo >&2 '  Did you forget to add -e PROTOCOL=... ?'
                exit 1
        elif [[ ! "$PROTOCOL" =~ ^(origin|verify_simple|verify_deflate|verify_sha1|verify_sha1_compatible|auth_simple|auth_sha1|auth_sha1_compatible|auth_sha1_v2|auth_sha1_v2_compatible)$ ]]; then
                echo >&2 'error : missing PROTOCOL'
                echo >&2 '  You must be used -e PROTOCOL=[origin|verify_simple|verify_deflate|verify_sha1|verify_sha1_compatible|auth_simple|auth_sha1|auth_sha1_compatible|auth_sha1_v2|auth_sha1_v2_compatible]'
                exit 1
        fi

        if [ -z "$OBFS" ]; then
                echo >&2 'error:  missing OBFS'
                echo >&2 '  Did you forget to add -e OBFS=... ?'
                exit 1
        elif [[ ! "$OBFS" =~ ^(plain|http_simple|http_simple_compatible|tls_simple|tls_simple_compatible|random_head|random_head_compatible|tls1.0_session_auth|tls1.0_session_auth_compatible)$ ]]; then
                echo >&2 'error:  missing OBFS'
                echo >&2 '  You must be used -e OBFS=[plain|http_simple|http_simple_compatible|tls_simple|tls_simple_compatible|random_head|random_head_compatible|tls1.0_session_auth|tls1.0_session_auth_compatible]'
                exit 1
        fi

        if [ -z "$OBFS_PARAM" ]; then
                echo >&2 'error:  missing OBFS_PARAM'
                echo >&2 '  Did you forget to add -e OBFS_PARAM=... ?'
                exit 1
        fi

        if [ -n "$METHOD" ]; then
                if [[ ! "$METHOD" =~ ^(aes-(256|192|128)-cfb|(chacha|salsa)20|rc4-md5)$ ]]; then
                        echo >&2 'error:  missing METHOD'
                        echo >&2 '  You must be used -e METHOD=[aes-256-cfb|aes-192-cfb|aes-128-cfb|chacha20|salsa20|rc4-md5]'
                        exit 1
                else
                        sed -ri "s@^(.*\"method\": ).*@\1\"$METHOD\",@" $INSTALL_DIR/user-config.json
                fi
        fi

        if [ -n "$DNS_IPV6" ]; then
                if [[ ! "$DNS_IPV6" =~ ^(false|true)$ ]]; then
                        echo >&2 'error:  missing DNS_IPV6'
                        echo >&2 '  You must be used -e DNS_IPV6=[false|true]'
                        exit 1
                else
                        sed -ri "s@^(.*\"dns_ipv6\": ).*@\1\"$DNS_IPV6\",@" $INSTALL_DIR/user-config.json
                fi
        fi

        sed -ri "s@^(.*\"protocol\": ).*@\1\"$PROTOCOL\",@" $INSTALL_DIR/user-config.json
        sed -ri "s@^(.*\"obfs\": ).*@\1\"$OBFS\",@" $INSTALL_DIR/user-config.json
        sed -ri "s@^(.*\"obfs_param\": ).*@\1\"$OBFS_PARAM\",@" $INSTALL_DIR/user-config.json
fi

if [ -n "$SPAM" ]; then
        if [ "$SPAM" = "On" ]; then
                iptables -t mangle -A OUTPUT -m string --string "Subject" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "HELO" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "SMTP" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "torrent" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string ".torrent" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "peer_id=" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "announce" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "info_hash" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "get_peers" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "find_node" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "announce_peer" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "protocol" --algo bm --to 65535 -j DROP
                iptables -t mangle -A OUTPUT -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
                iptables -t filter -A OUTPUT -p tcp -m multiport --dports 25,26,465 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable
                iptables -t filter -A OUTPUT -p tcp -m multiport --dports 109,110,995 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable
                iptables -t filter -A OUTPUT -p tcp -m multiport --dports 143,218,220,993 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable
                iptables -t filter -A OUTPUT -p tcp -m multiport --dports 24,50,57,105,106,158,209,587,1109,24554,60177,60179 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable
                iptables -t mangle -L -nvx --lin
                iptables -t filter -L -nvx --lin
        fi
else
        echo >&2 'error:  missing SPAM'
        echo >&2 '  You must be used -e SPAM=[On|Off]'
fi

exec "$@"