# Alternatives to docker desktop

[![build](https://github.com/DevecorSoft/DockerDesktopAlternative/actions/workflows/ci.yml/badge.svg)](https://github.com/DevecorSoft/DockerDesktopAlternative/actions/workflows/ci.yml)  
English | [简体中文](./README.CN.md)

try to replace docker desktop on mac with `ubuntu and docker engine` via `multipass`

[Here](./guide.md) you can check more details.

The purpose is:

1. use `docker cli` and `docker compose` on Mac OS as before
2. run `testcontainer` based intergration test as usual

## Install

please make sure you have already install `zsh` and `HomeBrew`.
these is an convenient script that install alternative to docker automaticly.

```
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/DevecorSoft/DockerDesktopAlternative/main/install.sh)"
```

## [optional] Configure `vmhost` for docker on MAC

We have to access to docker containner manually sometimes. And I hate to connect running containner with ip address.
A viable alternative to `localhost` is mapping your docker machine ip to `vmhost`:

```
sudo echo "192.168.64.2    vmhost" >> /etc/hosts
```

Everything with docker should be fine. However, Keep in mind that your VPN won't be shared with vm. Please just enjoy!

And give me a star!
