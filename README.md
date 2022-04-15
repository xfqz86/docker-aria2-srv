# docker-aria2-srv
一个运行在 Podman（Docker）中的 Aria2 服务端


## 快速开始

```
$ git clone https://github.com/xfqz86/docker-aria2-srv.git
$ cd docker-aria2-srv
$ podman build -t aria2-srv .
$ podman run -d \
  --name aria2-srv \
  --restart unless-stopped \
  -v $HOME/downloads:/downloads \
  -v $HOME/.config/aria2:/config \
  -p 6800:6800 \
  -p 6888:6888/tcp \
  -p 6888:6888/udp \
  aria2-srv
```


## 配置

- `-v $HOME/downloads:/downloads` 参数用于绑定宿主机实际下载目录。如：将文件下载到 `/var/www/Shared` 则改为 `-v /var/www/Shared:/downloads`

- `-v $HOME/.config/aria2:/config` 参数用于绑定存放配置文件的目录。如：将配置文件储存到 `/opt/aira2` 则改为 `-v /opt/aria2:/config`

- `-p 6800:6800` 参数用于映射 RPC 端口，对应配置文件中的 `rpc-listen-port`

- `-p 6888:6888/tcp` 参数用于映射 BT 下载的本地接收端口，对应配置文件中的 `listen-port`

- `-p 6888:6888/udp` 参数用于映射连接 DHT 网络的端口，对应配置文件中的 `dht-listen-port`

- aria2 运行配置文件保存在 `[配置文件目录]/aria2.conf` 。您可以根据实际需要进行设置，若文件不存在则会在启动容器时自动建立。具体配置项请参考：[aria2c OPTIONS](https://aria2.github.io/manual/en/html/aria2c.html#options)


## 注意

- 生成默认配置文件时会自动生成一个 UUID 作为 RPC 密钥。可以使用 `grep -E '^rpc-secret=' [配置文件目录]/aria2.conf` 查询。

- 配置文件目录中 **包含重要的敏感信息**（如 RPC 密钥、代理服务器密码等），建议将目录权限设置成 **700** 以避免泄密。

- 新建下载任务或设置配置文件中的下载目录时，请不要设置到 `/downloads` 目录外，否则将无法在宿主机实际下载目录中找到。


## 许可证

本存储库根据 [MIT License](http://opensource.org/licenses/MIT) 条款开源。
