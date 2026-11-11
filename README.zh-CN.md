# openvpn-ui 简体中文版（zh-CN）

本分支在 [d3vilh/openvpn-ui](https://github.com/d3vilh/openvpn-ui) 上游 `main` 的基础上，增加了**简体中文界面**。

[English README](README.md) · 简体中文（当前）

## 做了什么

上游的管理面板是服务端渲染（Beego + Go template），界面文案在 **HTML 模板**里，Go 二进制不含文案。
因此本分支**不修改任何 Go 代码**，只提供中文模板 + 一个几行的 Dockerfile：

```dockerfile
FROM d3vilh/openvpn-ui:latest
COPY views/ /opt/openvpn-ui/views/
```

好处：
- 构建只需几秒（不编译 Go，不装依赖）
- 直接继承上游镜像的 arm64 / amd64 多架构
- 上游更新后重新 build 一次即可跟上

## 分支内容

```
views/                19 个已翻译的 HTML 模板（约 540 处文案）
Dockerfile            中文镜像：FROM 上游镜像 + 覆盖 views
translations.json     英文原文 → 中文 的映射表（412 条），便于跟进上游
contrib/
  docker-compose.yml  可直接用的 compose 示例（中文面板 + 服务端）
  .env.example        全部参数模板（端口、网段、DNS、EasyRSA 字段）
  server.conf.example 服务端配置示例（分流：只把家庭内网推给客户端）
```

## 已汉化范围

- 登录页、仪表盘（CPU / 内存 / 负载 / 在线客户端 / 流量）
- 证书列表、签发、续期、吊销、2FA 二维码
- EasyRSA 变量页及每个参数的说明
- 服务端配置模板（`server.conf` 全部选项说明）
- 客户端配置模板（`.ovpn` 生成参数）
- 维护页（条件重启 / 完整重启 / PKI 初始化 / 危险操作）
- 日志、用户管理、个人资料

**未翻译**（保持原样，避免破坏功能）：配置值本身（`tun` / `udp` / `subnet` / `pki/*.crt` / `nobody` 等）、文件路径、示例邮箱。
前端 `static/js` 中极少量动态校验提示仍为英文。

## 构建与使用

```bash
# 构建（本机架构）
docker build -t openvpn-ui-zh:1.0 .

# 或指定多架构
docker buildx build --platform linux/arm64,linux/amd64 -t your-registry/openvpn-ui-zh:1.0 --push .
```

`docker-compose.yml` 里的面板镜像改成构建出来的即可，其余（服务端容器、`server.conf`、证书目录）与上游完全一致：

```yaml
  openvpn-ui:
    image: openvpn-ui-zh:1.0
    ports: ["8080:8080/tcp"]
    environment:
      OPENVPN_ADMIN_USERNAME: admin
      OPENVPN_ADMIN_PASSWORD: 改成你自己的
    volumes:
      - ./:/etc/openvpn
      - ./db:/opt/openvpn-ui/db
      - ./pki:/usr/share/easy-rsa/pki
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

## 跟进上游更新

```bash
git fetch origin main
git rebase origin/main        # 或 merge
# 若有新增英文模板，用 translations.json 补词条后重新套用
```

## 注意

- 只覆盖 HTML 模板，不改动二进制与协议，已签发的证书、`server.conf` 不受影响，替换面板后客户端无需重新导入配置。
- 不要在本分支里提交证书、私钥、`.ovpn`、`.env`（已加入 `.gitignore`）。
