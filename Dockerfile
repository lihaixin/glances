FROM --platform=${TARGETPLATFORM} tsl0922/ttyd:alpine

FROM --platform=${TARGETPLATFORM} nicolargo/glances:alpine-3.3.0.2

LABEL name=glances
MAINTAINER sanjin
ENV TZ=Asia/Shanghai
ENV DOCKERID=GLANCES

ENV DOMAIN youdomain.com
ENV HOSTNAME hostname
ENV XMLRPC_PORT 61209
ENV WebUI_PORT 61208
ENV USERNAME root
ENV PASSWORD password

COPY --from=0 /usr/bin/ttyd /usr/bin/ttyd
RUN apk add --no-cache tzdata ca-certificates figlet bash tini net-tools openssh-client openssl

# EXPOSE PORT (XMLRPC / WebUI)
EXPOSE $XMLRPC_POR $WebUI_PORT

ADD ./.bashrc /root/.bashrc
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
# ENTRYPOINT ["/entrypoint.sh"]
