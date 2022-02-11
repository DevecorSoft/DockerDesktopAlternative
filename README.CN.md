# docker desktop的替代方案

[![build](https://github.com/DevecorSoft/DockerDesktopAlternative/actions/workflows/ci.yml/badge.svg)](https://github.com/DevecorSoft/DockerDesktopAlternative/actions/workflows/ci.yml)  

本文中笔者将会尝试使用ubuntu + docker引擎的方式在mac电脑上替代docker desktop

[这里](./guide.cn.md)是具体的实现方案。

笔者的基本目标是:

1. 能够在Mac上正常使用docker cli和docker compose
2. 同时能够直接运行基于testcontainer的集成测试

# 安装

请确认你的PC已经安装了`zsh`和`HomeBrew`，若没有，请预先安装。
提供一个自动化脚本，可使用以下命令直接安装：

```
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/DevecorSoft/DockerDesktopAlternative/main/install.sh)"
```

## [可选]为docker主机配置vmhost

我们经常使用端口映射来暴露某些服务，然后通过`localhost:port`访问服务。我猜你一定不想每次手动输入ip地址，所以你值得在本地拥有一个vmhost：

macos下编辑`/etc/hosts`文件

```
sudo echo "192.168.64.2    vmhost" >> /etc/hosts
```

至此，所有安装和配置工作都已完成，尽情享受吧！
