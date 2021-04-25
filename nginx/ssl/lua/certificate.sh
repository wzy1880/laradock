#!/bin/bash

server_name=$1

#if [ $server_name = localhost ];then
#  cat /etc/nginx/ssl/localhost.pem && echo ',' && cat /etc/nginx/ssl/localhost-key.pem
#fi
curl http://localhost/api/system/domains/${server_name}
