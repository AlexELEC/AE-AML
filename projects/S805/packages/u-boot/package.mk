# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="u-boot"
PKG_VERSION="box"
PKG_SHA256=""
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain gcc-linaro-arm-eabi:host"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems."
PKG_TOOLCHAIN="manual"

PKG_NEED_UNPACK="$PROJECT_DIR/$PROJECT/bootloader"

make_target() {
    : # nothing
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader

    # Always install the update script
    find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} $INSTALL/usr/share/bootloader

    # Replace partition names in update.sh
    if [ -f "$INSTALL/usr/share/bootloader/update.sh" ] ; then
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i $INSTALL/usr/share/bootloader/update.sh
    fi
}
