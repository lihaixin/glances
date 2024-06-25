#!/bin/bash

if [ -t 1 ]; then
	export PS1="\e[1;34m[\e[1;33m\u@\e[1;32mD-\h\e[1;37m:\w\[\e[1;34m]\e[1;36m\\$ \e[0m"
fi

if [ -f "/etc/envfile" ]; then
export $(grep -v '^#' /etc/envfile | xargs)
fi

# Aliases
alias l='ls -lAsh --color'
alias ls='ls -C1 --color'
alias cp='cp -ip'
alias rm='rm -i'
alias mv='mv -i'
alias tmux='tmux -u'
alias h='cd ~;clear;'
alias glanceslogs='tail -F  /tmp/*.log'
alias reboot='pkill -s 1;sleep 1;pkill -s 1'
. /etc/os-release

IP=$(curl -s  ip.sb)
: ${MainINF:=$(ip route | grep "default via" |awk '{ print $5}')}
: ${MainIP:=$(/sbin/ifconfig $MainINF | grep 'inet' | awk '{ print $2}' | awk -F ":" '{print $2 }' | head -n 1)}

echo -e -n '\E[1;34m'
figlet -k -f big -c -m-1 -w 120 "Welcome `hostname`"
echo " # ----------------------------------------------------------------------------------------------------------- #"
echo " # 一款Python编写的跨平台系统监控工具, 如更改映射的端口，请使用对应端口替换 $WEBUI_PORT "
echo " # $DOCKERID 面板域名管理地址:          https://$HOSTNAME.$DOMAIN:$WebUI_PORT  账户：$USERNAME 密码：$PASSWORD "
echo " # $DOCKERID 面板外网管理地址:          https://$IP:$WebUI_PORT   账户：$USERNAME 密码：$PASSWORD "
echo " # $DOCKERID 面板内网管理地址:          https://$MainIP:$WebUI_PORT  账户：$USERNAME 密码：$PASSWORD "
echo " # "
echo " # 更多信息访问网页查看： https://hub.docker.com/r/lihaixin/glances "
echo " # ----------------------------------------------------------------------------------------------------------- #"
if [ -f "/etc/member" ]; then
echo " # "
QQ=`cat /etc/envfile | grep QQ | awk -F "=" '{ print $2}'`
echo " # 技术支持QQ: $QQ"
fi
echo -e -n '\E[1;34m'
echo -e '\E[0m'
