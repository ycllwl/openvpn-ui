# 中文版 OpenVPN 管理面板
# 上游：d3vilh/openvpn-ui（Go 后端 + 服务端渲染模板）
# 汉化方式：替换镜像内 /opt/openvpn-ui/views 下的 HTML 模板，不改二进制
FROM d3vilh/openvpn-ui:latest

LABEL org.opencontainers.image.title="openvpn-ui-zh" \
      org.opencontainers.image.description="d3vilh/openvpn-ui with Simplified Chinese UI" \
      org.opencontainers.image.source="https://github.com/d3vilh/openvpn-ui"

COPY views/ /opt/openvpn-ui/views/
