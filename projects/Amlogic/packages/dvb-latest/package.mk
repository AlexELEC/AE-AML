# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="dvb-latest"
PKG_VERSION="8c181825fa4b157679e600565c310841be9f1890"
PKG_SHA256="ed658d8f65bb31b5f0667f305de09b62d18ff9b4403cdb2e7e460a942a07aec4"
PKG_LICENSE="GPL"
PKG_SITE="http://git.linuxtv.org/media_build.git"
PKG_URL="https://git.linuxtv.org/media_build.git/snapshot/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux media_tree media_tree_aml"
PKG_NEED_UNPACK="$LINUX_DEPENDS media_tree"
PKG_SECTION="driver.dvb"
PKG_LONGDESC="media_build DVB drivers"

PKG_IS_ADDON="embedded"
PKG_IS_KERNEL_PKG="yes"
PKG_ADDON_IS_STANDALONE="yes"
PKG_ADDON_NAME="media_build DVB drivers"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_VERSION="${ADDON_VERSION}.${PKG_REV}"

configure_package() {
  if [ "$PROJECT" = "Amlogic" -o "$PROJECT" = "Amlogic-dbl" ]; then
    PKG_PATCH_DIRS="amlogic"
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET media_tree_aml"
    PKG_NEED_UNPACK="$PKG_NEED_UNPACK media_tree_aml"
  fi
}

pre_make_target() {
  export KERNEL_VER=$(get_module_dir)
  export LDFLAGS=""
}

make_target() {
  cp -RP $(get_build_dir media_tree)/* $PKG_BUILD/linux
  if [ "$PROJECT" = "Amlogic" -o "$PROJECT" = "Amlogic-dbl" ]; then
    cp -Lr $(get_build_dir media_tree_aml)/* $PKG_BUILD/linux
    echo "obj-y += video_dev/" >> "$PKG_BUILD/linux/drivers/media/platform/meson/Makefile"
    echo "obj-y += dvb/" >> "$PKG_BUILD/linux/drivers/media/platform/meson/Makefile"
  fi 

  # make config all
  kernel_make VER=$KERNEL_VER SRCDIR=$(kernel_path) allyesconfig

  # hack to workaround media_build bug
  if [ "$PROJECT" = "Amlogic" -o "$PROJECT" = "Amlogic-dbl" ]; then
    sed -e 's/CONFIG_DVB_LGDT3306A=m/# CONFIG_DVB_LGDT3306A is not set/g' -i v4l/.config
    sed -e 's/CONFIG_VIDEO_S5C73M3=m/# CONFIG_VIDEO_S5C73M3 is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_SAA7146_VV=m/# CONFIG_VIDEO_SAA7146_VV is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_OV2659=m/# CONFIG_VIDEO_OV2659 is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_OV5647=m/# CONFIG_VIDEO_OV5647 is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_S5K5BAF=m/# CONFIG_VIDEO_S5K5BAF is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_VIVID=m/# CONFIG_VIDEO_VIVID is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_TVP514X=m/# CONFIG_VIDEO_TVP514X is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_TVP7002=m/# CONFIG_VIDEO_TVP7002 is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_CADENCE_CSI2RX=m/# CONFIG_VIDEO_CADENCE_CSI2RX is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/CONFIG_VIDEO_CADENCE_CSI2TX=m/# CONFIG_VIDEO_CADENCE_CSI2TX is not set/g' -i $PKG_BUILD/v4l/.config
    sed -e 's/# CONFIG_MEDIA_TUNER_TDA18250 is not set/CONFIG_MEDIA_TUNER_TDA18250=m/g' -i $PKG_BUILD/v4l/.config
  fi

  kernel_make VER=$KERNEL_VER SRCDIR=$(kernel_path)
}

makeinstall_target() {
  install_driver_addon_files "$PKG_BUILD/v4l/"
}
