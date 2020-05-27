# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2019, McMCC <mcmcc@mail.ru>

PKG_NAME="9082xs"
PKG_VERSION="v1.2.0_0046.20160328"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.alexelec.in.ua"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="9082xs: Linux drivers for SCI s9082c WLAN chips used in some devices based on Amlogic SoCs."
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

pre_make_target() {
  mkdir -p $PKG_BUILD/9082xs
  cp $PKG_DIR/source/* $PKG_BUILD/9082xs
  unset LDFLAGS
}

make_target() {
  make V=1 -C $(kernel_path) M=$PKG_BUILD/9082xs \
    ARCH=$TARGET_KERNEL_ARCH \
    CROSS_COMPILE=$TARGET_KERNEL_PREFIX
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    find $PKG_BUILD/ -name \*.ko -not -path '*/\.*' -exec cp {} $INSTALL/$(get_full_module_dir)/$PKG_NAME \;
}
