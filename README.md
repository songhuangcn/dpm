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

## 创建新包

*TBD*

## 相关工具

- [Visual Studio Code 插件](https://marketplace.visualstudio.com/items?itemName=UoooBarry.dpm-vscode)
