# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="ImageMagick"
PKG_VERSION="7.0.8-23"
PKG_SHA256="a5c4c13ae5e87063539f5ccc66417210ec5efaa49561126e0ba066bd0cb53be4"
PKG_ARCH="any"
PKG_LICENSE="http://www.imagemagick.org/script/license.php"
PKG_SITE="http://www.imagemagick.org"
PKG_URL="https://github.com/ImageMagick/ImageMagick/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ImageMagick is a software suite to create, edit, and compose bitmap images. It can read, convert and write images in a variety of formats (over 100)."

PKG_CONFIGURE_OPTS_TARGET="--disable-openmp \
                           --disable-static \
                           --enable-shared \
                           --with-pango=no \
                           --with-x=no"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/share/fonts/liberation
    cp -PR $PKG_DIR/config/truetype/* $INSTALL/usr/share/fonts/liberation
}
