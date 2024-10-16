# 第一阶段：构建阶段
FROM --platform=$TARGETPLATFORM alpine:3.18 AS builder

# 设置构建参数
ARG TARGETPLATFORM
ARG TARGETARCH

# 设置工作目录
WORKDIR /app

# 复制二进制文件
COPY ./bin/cfnat/cfnat-linux-amd64 /app/cfnat-linux-amd64
COPY ./bin/cfnat/cfnat-linux-arm64 /app/cfnat-linux-arm64
COPY ./bin/colo/colo-linux-amd64 /app/colo-linux-amd64
COPY ./bin/colo/colo-linux-arm64 /app/colo-linux-arm64

# 复制配置文件
COPY ./ips-v4.txt /app/ips-v4.txt
COPY ./ips-v6.txt /app/ips-v6.txt
COPY ./locations.json /app/locations.json

# 将 entrypoint.sh 复制到 /usr/local/bin 目录
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# 根据目标架构重命名二进制文件并设置执行权限
RUN case "$TARGETARCH" in \
        amd64) mv /app/cfnat-linux-amd64 /app/cfnat ;; \
        arm64) mv /app/cfnat-linux-arm64 /app/cfnat ;; \
    esac && \
    case "$TARGETARCH" in \
        amd64) mv /app/colo-linux-amd64 /app/colo ;; \
        arm64) mv /app/colo-linux-arm64 /app/colo ;; \
    esac && \
    chmod +x /app/colo && \
    chmod +x /app/cfnat && \
    chmod +x /usr/local/bin/entrypoint.sh

# 第二阶段：运行阶段
FROM --platform=$TARGETPLATFORM alpine:3.18

# 设置工作目录
WORKDIR /config

# 复制构建阶段的文件到运行阶段
COPY --from=builder /app/cfnat /app/cfnat
COPY --from=builder /app/colo /app/colo
COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=builder /app/ips-v4.txt /app/ips-v4.txt
COPY --from=builder /app/ips-v6.txt /app/ips-v6.txt
COPY --from=builder /app/locations.json /app/locations.json

# 暴露需要使用的端口
EXPOSE 1234

# 映射 /config 目录
VOLUME ["/config"]

# 设置默认环境变量
ENV addr="0.0.0.0:1234" \
    code=200 \
    colo=HKG,SJC,LAX \
    delay=300 \
    domain="cloudflaremirrors.com/debian" \
    ipnum=20 \
    ips="4" \
    num=10 \
    port=443 \
    random=true \
    task=100 \
    tls=true \
    coloip=false

# 设置 ENTRYPOINT 为 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
