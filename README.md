[简体中文](README.md) | [English](README.en-US.md)

# DPM

Docker Package Manager, 让你的 Docker 用起来跟包管理器（`apt`, `yum`, `brew`）一样简单。

## 安装

```bash
gem install dpmrb
```

## 使用

```bash
dpm pacakges                   # List all supported packages
dpm start mysql                # Start the package `mysql` by the config `packages/mysql.yml`
dpm stop mysql                 # Start the package `mysql`
dpm status mysql               # Show the status of the package `mysql`
dpm help                       # Get help to show all the features
```

## 创建新包

*TBD*

## 相关工具

- [Visual Studio Code 插件](https://marketplace.visualstudio.com/items?itemName=UoooBarry.dpm-vscode)
