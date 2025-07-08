#!/bin/bash

# 删除feeds中的插件
rm -rf ./feeds/packages/net/{geoview,shadowsocks-libev,chinadns-ng,mosdns}
rm -rf ./feeds/luci/applications/luci-app-mosdns

# 克隆依赖插件
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/pwpage

# 克隆的源码放在 small 文件夹
mkdir -p package/small
pushd package/small

# adguardhome
git clone -b 2024.09.05 --depth 1 https://github.com/XiaoBinin/luci-app-adguardhome.git

# lucky
git clone -b main --depth 1 https://github.com/gdy666/luci-app-lucky.git

# passwall2
git clone -b main --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git

# mosdns
git clone -b v5 --depth 1 https://github.com/sbwml/luci-app-mosdns.git

# nikki 工具集
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git

# 添加 python3-netifaces（作为 mqttled 依赖）
mkdir -p python3-netifaces
cat > python3-netifaces/Makefile << "EOF"
include \$(TOPDIR)/rules.mk

PKG_NAME:=python3-netifaces
PKG_VERSION:=0.11.0
PKG_RELEASE:=1
PYPI_NAME:=netifaces
PKG_HASH:=1c5df95648589d44b6bb49cc9be8bdcecf4793c238d19826f87f0d289b4b0a79

PKG_SOURCE:=$(PYPI_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://files.pythonhosted.org/packages/source/n/netifaces
PKG_BUILD_DIR:=$(BUILD_DIR)/$(BUILD_VARIANT)-$(PKG_NAME)-$(PKG_VERSION)

include \$(INCLUDE_DIR)/package.mk
include \$(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/python3-netifaces
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=Python netifaces module
  DEPENDS:=+python3-light
endef

\$(eval \$(call Py3Package,python3-netifaces))
\$(eval \$(call BuildPackage,python3-netifaces))
EOF

popd

echo "packages python3-netifaces executed successfully!"
