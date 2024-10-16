# CFnat-Docker

 1. 创建
    `docker-compose.yml`

    ```yaml
    services:
      cfnat:
        container_name: cfnat
        image: gdfsnhsw/cfnat:latest
        restart: always
        volumes:
          - ./cfnat:/config  # 映射主机的 cfnat 目录到容器的 /config
        ports:
          - "1234:1234"  # 将主机的 1234 端口映射到容器的 1234 端口
        environment:
          - colo=HKG,SJC,LAX  # 筛选数据中心例如 HKG,SJC,LAX.电信 推荐 SJC,LAX.移动/联通 推荐 HKG"
          - delay=300  # 有效延迟（毫秒），超过此延迟将断开连接
          - domain=cloudflaremirrors.com/debian  # 响应状态码检查的域名地址
          - code=200  # 默认HTTP/HTTPS 响应状态码
          - ipnum=20  # 提取的有效IP数量
          - ips=4  # 指定生成IPv4还是IPv6地址
          - num=10  # 目标负载 IP 数量
          - port=443  # 转发的目标端口
          - random=true  # 是否随机生成IP，如果为false，则从CIDR中拆分出所有IP
          - task=100  # 并发请求最大协程数
          - tls=true  # 是否为 TLS 端口
          - coloip=true  #是否开启colo扫描优选ip

    ```
 2. 运行容器
    ```
    docker-compose up -d
    ```
 3. 停止容器
    ```
    docker-compose down
    ```
 4. 查看日志
    ```
    docker logs -f cfnat
    ```
