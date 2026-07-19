#!/usr/bin/env bash
set -euo pipefail

cat >> feeds.conf.default <<'EOF'
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^PASSWALL_PACKAGES_COMMIT_PLACEHOLDER
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git^PASSWALL_COMMIT_PLACEHOLDER
EOF
sed -i "s/PASSWALL_PACKAGES_COMMIT_PLACEHOLDER/${PASSWALL_PACKAGES_COMMIT}/" feeds.conf.default
sed -i "s/PASSWALL_COMMIT_PLACEHOLDER/${PASSWALL_COMMIT}/" feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a

git init /tmp/OpenClash
git -C /tmp/OpenClash remote add origin https://github.com/vernesong/OpenClash.git
git -C /tmp/OpenClash fetch --depth 1 origin "${OPENCLASH_COMMIT}"
git -C /tmp/OpenClash checkout --detach "${OPENCLASH_COMMIT}"
cp -a /tmp/OpenClash/luci-app-openclash package/luci-app-openclash

mkdir -p files/etc/openclash/core files/etc/uci-defaults
curl --fail --location --retry 3 \
  --output files/etc/openclash/core/clash_meta \
  "https://github.com/kachetong1314/mihomo-ninja/releases/download/${NINJA_VERSION}/ninja-linux-mipsle-softfloat"
echo "${NINJA_SHA256}  files/etc/openclash/core/clash_meta" | sha256sum --check --strict
chmod 0755 files/etc/openclash/core/clash_meta
cp ../files/etc/uci-defaults/90-proxy-safe-defaults files/etc/uci-defaults/
