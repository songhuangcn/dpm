[简体中文](README.md) | [English](README.en-US.md)

# DPM

Docker Package Manager, 让你的 Docker 用起来跟包管理器（`apt`, `yum`, `brew`）一样简单。

## 安装

依赖：
- Docker
- Ruby >= 2.6

安装命令：
```bash
gem install dpmrb
```

## 使用

```bash
dpm pacakges                   # 列出所有支持的包
dpm start mysql                # 通过配置 `packages/mysql.yml` 运行 `mysql` 包
dpm stop mysql                 # 停止运行 `mysql` 包
dpm status mysql               # 展示 `mysql` 包的运行状态
dpm help                       # 展示帮助，查看所有功能
```

## 包配置

DPM 支持两种包配置：
1. 项目 repo 目录 `packages/` 的 "系统包配置"
1. 用户目录 `~/.dpm/packages` 的 "用户包配置"

### 系统包配置

"系统包配置" 目标是让一个 Docker 服务跑起来跟原生安装的软件一致，拿 MySQL 来举例：
- 原生软件 MySQL 安装好运行后，会默认绑定好 3306 端口，那我们的 MySQL 包配置就要做到默认也暴露该服务端口到主机
- 原生软件 MySQL 安装好后，有固定的配置目录和日志目录，那我们的 MySQL 包配置就要做到也将容器里的这些目录映射到固定的目录

### 用户包配置

"用户包配置" 有以下使用场景：
1. DPM 默认包配置不合理想更改，可以先用 "用户包配置" 调试查看结果，然后给 repo 提 MR。
2. DPM 没有提供你需要的包，需要添加自己包配置。（欢迎给 DPM 贡献你的新包配置）。
3. DPM 默认包配置不适合本地环境，需要覆盖 "系统包配置"。比如我本地需要跑两个 MySQL 服务，那我就需要把其中一个服务的端口改成其他避免冲突。

"用户包配置" 提供了以下命令快速创建：
```bash
dpm configure PACKAGE
```

该命令功能就是在用户目录 `~/.dpm/` 下添加一个新的包配置文件 `PACKAGE.yml`。如果该包在 "系统包配置" 已经存在，则会将内容初始化到该文件里。

## 相关工具

- [Visual Studio Code 插件](https://marketplace.visualstudio.com/items?itemName=UoooBarry.dpm-vscode)

## 开发调试

### 搭建环境

```bash
git clone git@github.com:songhuangcn/dpm.git
cd dpm
bin/setup # 需要 Ruby >= 2.6
```

### 调试

- 给所有命令添加 ENV `DEBUG` 会展示详细错误堆栈，帮助定位问题
- 开发完后，请使用命令 `bin/check` 检查代码规范和测试，提前解决一些 CI 失败的情况
