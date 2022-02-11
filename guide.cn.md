# docker desktop的替代方案

[![build](https://github.com/DevecorSoft/DockerDesktopAlternative/actions/workflows/ci.yml/badge.svg)](https://github.com/DevecorSoft/DockerDesktopAlternative/actions/workflows/ci.yml)

本文中笔者将会尝试使用ubuntu + docker引擎的方式在mac电脑上替代docker desktop

笔者的基本目标是:

1. 能够在Mac上正常使用docker cli和docker compose
2. 同时能够直接运行基于testcontainer的集成测试

# 安装

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/DevecorSoft/DockerDesktopAlternative/main/install.sh)"
```

## 使用multipass初始化ubuntu

```
brew install multipass
multipass launch --disk 20G --mem 4G --cpus 2 --name primary
```

注意：请至少配置6G的磁盘空间，testcontainer要求至少2GB的剩余空间，ubuntu server操作系统自己会占用4GB左右的空间。

## 在ubuntu上安装docker引擎

只要成功初始化了ubuntu，就可以使用`multipass shell`进入ubuntu的终端, 然后请根据[docker官方文档](https://docs.docker.com/engine/install/ubuntu/)安装docker引擎

## 通过Tcp暴露docker守护进程

* 编辑docker的守护进程配置文件

    `sudo vim /etc/docker/daemon.json`

    ```json
    {
        "hosts": [
            "tcp://0.0.0.0:2375",
            "unix:///var/run/docker.sock"
        ]
    }
    ```

* 重写docker的systemd服务

    ```
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo vim /etc/systemd/system/docker.service.d/override.conf
    ```
    
    
    ```
    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd
    ```

    记得重启服务

    ```
    systemctl daemon-reload
    systemctl restart docker.service
    ```

## Mac上配置环境变量

* 在 `~/.zshrc`文件里配置`DOCKER_HOST`变量
  ```shell
  export DOCKER_HOST="tcp://192.168.64.2:2375"
  ```
  使环境变量立即生效
  `source ~/.zshrc`

重启你的ide，所有的集成测试应该能够正常运行了

## Mac上安装docker cli和docker compose

只需要一行命令：`brew install docker docker-compose`

## [可选]为docker主机配置vmhost

编辑`/etc/hosts`文件

```
sudo echo "192.168.64.2    vmhost" >> /etc/hosts
```

至此，所有安装和配置工作都已完成，尽情享受吧！
