# Xiaomi AC2100 ImmortalWrt firmware

Reproducible GitHub Actions build for the **Xiaomi Mi Router AC2100** (not the
Redmi AC2100). It uses the stable ImmortalWrt 24.10 branch and includes:

- LuCI with Simplified Chinese and HTTPS
- OpenClash with the V-Ninja `mipsle-softfloat` core
- PassWall with the Xray backend and nftables transparent proxying
- SQM, UPnP, Watchcat, TTYD and a small set of diagnostic tools

OpenClash and PassWall are installed but disabled on first boot. The router has
only 128 MB RAM, so enable one proxy suite at a time.

## Build

Open **Actions**, choose **Build Xiaomi AC2100 firmware**, and select **Run
workflow**. Download the artifact when the job finishes. The artifact contains
the firmware images, the effective build configuration and `SHA256SUMS`.

Build artifacts expire after 30 days. Run the workflow again whenever a fresh
download is needed.

## Images and flashing

- `*squashfs-sysupgrade.bin`: upgrade from an existing OpenWrt/ImmortalWrt
  installation for this exact model. Do not keep settings when switching from a
  different firmware family.
- `*kernel1.bin` and `*rootfs0.bin`: low-level installation images used by the
  Xiaomi AC2100 OpenWrt installation procedure or a compatible recovery
  bootloader.

Do **not** flash the Redmi AC2100 image. Before writing anything, back up the
bootloader, factory, Bdata and full MTD partitions. The phrase "unbrick
firmware" does not identify the bootloader or partition layout; verify the
current bootloader and its accepted image type before flashing.

After first boot, set a root password, verify WAN/LAN and Wi-Fi, then enable
either OpenClash (for a V-Ninja subscription) or PassWall. Never enable both
transparent proxy services at the same time on this device.

## Pinned components

- Base: `immortalwrt/immortalwrt`, branch `openwrt-24.10`, commit `253a70f1`
- OpenClash: commit `a9e5d98c`
- PassWall: commit `3e3cf508`; packages commit `9d391e56`
- V-Ninja core: release `9a5dd535`, SHA-256
  `6b0f3faab400862deccb50001dc2b63afa7117300299653ee887d914c631d7f7`
