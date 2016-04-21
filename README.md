# docker-shadowsocks-manyuser

### 用法:
    docker run -d --name=ShadowSocks \
    -p 10000-20000:10000-20000 \
    -p 10000-20000:10000-20000/udp \
    -e MANYUSER=R \
    -e MYSQL_HOST=1.2.3.4 \
    -e MYSQL_PORT=3306 \
    -e MYSQL_USER=mysqlroot \
    -e MYSQL_PASSWORD=mysqlpasswd \
    -e MYSQL_DBNAME=shadowsocks \
    -e METHOD=rc4-md5 \
    -e PROTOCOL=auth_simple \
    -e OBFS=http_simple_compatible \
    -e OBFS_PARAM="youku.com" \
    ywfwj2008/shadowsocks-manyuser:latest

### 参数
|变量名      	|默认参数   	|说明   |
| ------------- |:-------------:| :---|
|MANYUSER       |	            |	可用参数有：R/On <br> 当参数是R的时候则使用ShadowSocksR模式的多用户版本，否则用ShadowSocks原版的多用户模式。|
|MYSQL_HOST |	|当MANYUSER变量有参数时，才会启用。|
|MYSQL_PORT	|	|当MANYUSER变量有参数时，才会启用。|
|MYSQL_USER	|   |	当MANYUSER变量有参数时，才会启用。|
|MYSQL_PASSWORD	| |	当MANYUSER变量有参数时，才会启用。|
|MYSQL_DBNAME	| |	当MANYUSER变量有参数时，才会启用。|
|METHOD|	aes-256-cfb|	可用选项有：<br> aes-256-cfb/aes-192-cfb/aes-128-cfb/chacha20/salsa20/rc4-md5|
|PROTOCOL|	origin|	可用参数有：<br> origin/verify_simple/verify_deflate/auth_simple|
|OBFS	|http_simple_compatible|	可用参数有：<br> plain/http_simple/http_simple_compatible/tls_simple/tls_simple_compatible/random_head/random_head_compatible/OBFS_PARAM|
|DNS_IPV6|	false|	可用参数有：false/true|
|SPAM|  | 可用参数有：On/Off|