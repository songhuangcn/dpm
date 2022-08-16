[简体中文](README.md) | [English](README.en-US.md)

# DPM

Docker Package Manager, 让你的容器用起来跟包管理器（`apt`, `yml`, `brew`）一样简单。

## 安装

```bash
gem install dpmrb
```

## 使用

```bash
dpm help                       # Show help
dpm list                       # docker ps --filter "name=dpm-"
dpm start mysql                # docker run --name=dpm-mysql -d --rm -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes ...
dpm stop mysql                 # docker stop dpm-mysql
dpm status mysql               # docker ps --filter "name=dpm-mysql"
dpm start elasticsearch:7.10.2 # docker run --name=dpm-elasticsearch-7.10.2 -d --rm -p 9200:9200 -e discovery.type=single-node ...
dpm start mysql:5.7            # docker run --name=dpm-mysql-5.7 -d --rm -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes ...
```

## 为项目添加新包

DPM 跟 [Homebrew](https://brew.sh/) 一样，需要完善更多的包配置，欢迎为 `packages` 目录添加你需要的包配置。

### 配置级别

容器配置都是通用的 YAML 格式，有三个级别：

1. 默认级别：`packages/default.yml`
1. 包级别：`packages/PACKAGE/default.yml`
1. 版本级别：`packages/PACKAGE/tag-TAG.yml`

配置是合并机制，如果一个包没有自定义配置，他就会根据默认级别配置跑起来。

### 配置示例

例如有配置如下：

1. `packages/default.yml`：
    ```yml
    run_options:
      rm: true
      d: true
    ```
1. `packages/mysql/default.yml`：
    ```yml
    run_options:
      e: "MYSQL_ALLOW_EMPTY_PASSWORD=yes"
      p: "3306:3306"
    ```
1. `packages/mysql/tag-5.7.yml`：
    ```yml
    run_options:
      p: "3307:3307"
    ```

则最终这些包配置的启动命令为：

- `mysql:5.7` 的配置：
    ```bash
    docker run --rm -d -p 3307:3307 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql:5.7
    ```
- `mysql` 的配置：
    ```bash
    docker run --rm -d -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql
    ```
- `not-exist-pkg` 的配置：
    ```bash
    docker run --rm -d not-exist-pkg
    ```

### 其他配置

有一些其他配置项，例如 `image`：

`packages/elasticsearch/default.yml`
```yml
image: "docker.elastic.co/elasticsearch/elasticsearch"
```

则 `elasticsearch` 包的镜像将不在按约定自动计算，而是变成了：

```bash
docker.elastic.co/elasticsearch/elasticsearch
```

还有一些配置，例如：`args`，这个是传入到容器的参数，例如有配置文件 `packages/mysql/default.yml`：

```yml
args:
  character-set-server: "utf8mb4"
  collation-server: "utf8mb4_unicode_ci"
```

则所有版本的 `mysql` 包将会多这两个启动参数：

```bash
docker run mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```
