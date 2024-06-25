## 构建

```
docker buildx build --platform linux/arm64,linux/amd64 -t lihaixin/glances . --push
```

# [glances](https://github.com/nicolargo/glances/)

一款Python编写的跨平台系统监控工具

![](https://nicolargo.github.io/glances/public/images/screenshot-wide.png)

## 此镜像优点

- 可视化的终端功能提示（见下图）
- 基于alpine 构建的 amd64 arm64 镜像 (<30M)
- 默认开启https访问，确保数据传输安全
- 支持在爱快 x86_64 路由器上部署
- 支持 ORACE arm64 CPU架构部署
- 默认自签证书或者调用已有证书 （/etc/cert/$DOMAIN/fullchain.crt /etc/cert/$DOMAIN/private.key）

```
     __          __         _                                               _                                     
      \ \        / /        | |                                             | |                                    
       \ \  /\  / /    ___  | |   ___    ___    _ __ ___     ___      __ _  | |   __ _   _ __     ___    ___   ___ 
        \ \/  \/ /    / _ \ | |  / __|  / _ \  | '_ ` _ \   / _ \    / _` | | |  / _` | | '_ \   / __|  / _ \ / __|
         \  /\  /    |  __/ | | | (__  | (_) | | | | | | | |  __/   | (_| | | | | (_| | | | | | | (__  |  __/ \__ \
          \/  \/      \___| |_|  \___|  \___/  |_| |_| |_|  \___|    \__, | |_|  \__,_| |_| |_|  \___|  \___| |___/
                                                                      __/ |                                        
                                                                     |___/                                         
 # ----------------------------------------------------------------------------------------------------------- #
 # 一款Python编写的跨平台系统监控工具, 如更改映射的端口，请使用对应端口替换 61208 
 # GLANCES 面板域名管理地址:          https://hostname.youdomain.com:61208  账户：root 密码：password 
 # GLANCES 面板外网管理地址:          https://*.*.*.*:61208   账户：root 密码：password 
 # GLANCES 面板内网管理地址:          https://*.*.*.*:61208  账户：root 密码：password 
 # 
 # 更多信息访问网页查看： https://hub.docker.com/r/lihaixin/glances 
 # ----------------------------------------------------------------------------------------------------------- #
```


## 运行

### CLI

```bash
docker run -itd --restart=always \
  --name=glances \
  --hostname glances \
  --pid host \
  --network host \
  --privileged \
  -v /etc/cert:/etc/cert \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DOMAIN=youdomain.com \
  -e HOSTNAME=hostname \
  -e WEBUI_PORT=61208 \
  -e USERNAME=root \
  -e PASSWORD=password \
   lihaixin/glances

```

### docker-compose

```
version: "3.7"
services:
  glances:
    image: lihaixin/glances
    container_name: glances
    hostname: glances
    restart: unless-stopped
    pid: host
    network_mode: "host"
    privileged: true
    volumes:
      - /etc/cert:/etc/cert
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DOMAIN=youdomain.com                  # 你的域名   首先调用/etc/cert/$DOMAIN/fullchain.crt /etc/cert/$DOMAIN/private.key 证书，没有就使用openssl自签
      - HOSTNAME=hostname                     # 你的主机名
      - WEBUI_PORT=61208                      # web页面端口
      - USERNAME=root                         # web页面授权账户,变量调整为：noauth 设置不需要账号和密码就能登陆网页界面
      - PASSWORD=password                     # web页面授权密码,变量调整为：noauth 设置不需要账号和密码就能登陆网页界面
      
```
