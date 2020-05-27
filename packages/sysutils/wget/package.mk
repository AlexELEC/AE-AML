# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="wget"
PKG_VERSION="1.18"
PKG_SHA256="b5b55b75726c04c06fe253daec9329a6f1a3c0c1878e3ea76ebfebc139ea9cc1"
PKG_LICENSE="GPL"
PKG_SITE="http://www.wget-editor.org/"
PKG_URL="http://ftp.gnu.org/gnu/wget/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl pcre"
PKG_LONGDESC="wget: A non-interactive network retriever"

PKG_CONFIGURE_OPTS_TARGET="--disable-nls \
                           --disable-rpath \
                           --with-gnu-ld \
                           --with-ssl=openssl \
                           --with-openssl=yes"

post_makeinstall_target() {
  rm -rf $INSTALL/etc
}
