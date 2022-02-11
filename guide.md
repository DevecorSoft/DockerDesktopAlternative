# Alternatives to docker desktop

English | [简体中文](./guide.cn.md)

try to replace docker desktop on mac with `ubuntu and docker engine` via `multipass`

The purpose is:

1. use `docker cli` and `docker compose` on Mac OS as before
2. run testcontainer based integration test as usual

## Install

these is an convenient script that install alternative to docker automaticly.

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/DevecorSoft/DockerDesktopAlternative/main/install.sh)"
```

## Initialize ubuntu server with `multipass`

```
brew install multipass
multipass launch --disk 20G --mem 4G --cpus 2 --name primary
```
__Note that__ vm disk space must have more than 6GB.(test container need at least 2GB free disk space and os itself will take 4GB)

## Install Docker Engine on Ubuntu

As long as it launched, we can jump to ubuntu terminal with `multipass shell`, then please just follow [the docker official doc](https://docs.docker.com/engine/install/ubuntu/)

## Expose docker daemon to network via TCP

* Remote tcp config

    `sudo vim /etc/docker/daemon.json`

    ```json
    {
        "hosts": [
            "tcp://0.0.0.0:2375",
            "unix:///var/run/docker.sock"
        ]
    }
    ```

* Override docker service

    ```
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo vim /etc/systemd/system/docker.service.d/override.conf
    ```
    
    And type systemd service configuration as follows
    
    ```
    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd
    ```

    Remember to reload it

    ```
    systemctl daemon-reload
    systemctl restart docker.service
    ```

## Configure docker on MAC

* Add `DOCKER_HOST` env on your `~/.zshrc`
  ```shell
  export DOCKER_HOST="tcp://192.168.64.2:2375"
  ```

  `source ~/.zshrc`

After restarting your intellij idea, All `testcontainer`  based intergration test should just work.

## Install docker cli and compose on MAC

```
brew install docker docker-compose
```

## [optional] Configure `vmhost` for docker on MAC

We have to access to docker containner manually sometimes. And I hate to connect running containner with ip address.
A viable alternative to `localhost` is mapping your docker machine ip to `vmhost`:

```
sudo echo "192.168.64.2    vmhost" >> /etc/hosts
```

Everything with docker should be fine. However, Keep in mind that your VPN won't be shared with vm.
