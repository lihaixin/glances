#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "/etc/envfile" ]; then
env | grep -v " " | grep -v DOCKERID > /etc/envfile
else
export $(grep -v '^#' /etc/envfile | xargs)
fi

install_cert() {
mkdir -p /etc/cert/$DOMAIN
openssl genrsa 1024 > /etc/cert/$DOMAIN/private.key
openssl req -new -key /etc/cert/$DOMAIN/private.key -subj "/C=CN/ST=GD/L=SZ/O=$DOMAIN/CN=$HOSTNAME" > /etc/cert/$DOMAIN/private.csr
openssl req -x509 -days 3650 -key /etc/cert/$DOMAIN/private.key -in /etc/cert/$DOMAIN/private.csr > /etc/cert/$DOMAIN/fullchain.crt
}

# 查看证书，没有就自签
if [ ! -f "/etc/cert/$DOMAIN/fullchain.crt" ]; then
  install_cert
fi

if [ ! -f "/etc/server.crt" ]; then
  echo ln -s /etc/cert/$DOMAIN/fullchain.crt to /etc/server.crt
  echo ln -s /etc/cert/$DOMAIN/private.key to /etc/server.key
  ln -s /etc/cert/$DOMAIN/fullchain.crt /etc/server.crt
  ln -s /etc/cert/$DOMAIN/private.key /etc/server.key
fi

alias glances='python3 -m glances -C /etc/glances.conf $GLANCES_OPT'

if [[ $USERNAME = "noauth" ]] || [[ $PASSWORD = "noauth" ]]; then
  /usr/bin/ttyd -p $WebUI_PORT --ssl --ssl-cert /etc/server.crt --ssl-key /etc/server.key -t cursorStyle=bar -t lineHeight=1.1 -t fontSize=15 -t rendererType=webgl -t titleFixed=$HOSTNAME -t disableReconnect=true -P 360000 glances
else
  /usr/bin/ttyd -p $WebUI_PORT -c $USERNAME:$PASSWORD --ssl --ssl-cert /etc/server.crt --ssl-key /etc/server.key -t cursorStyle=bar -t lineHeight=1.1 -t fontSize=15 -t rendererType=webgl -t titleFixed=$HOSTNAME -t disableReconnect=true -P 360000 glances
fi
