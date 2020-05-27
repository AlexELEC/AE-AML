# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="aceproxy"
PKG_VERSION="2561431"
PKG_SHA256="6238623e0e9e4a5fe4c41261dbffeb954725fe0a879ccb7e8b26c0a75bedc4cc"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/AndreyPavlenko/aceproxy"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gevent psutil M2Crypto requests"
PKG_LONGDESC="AceProxy: Ace Stream HTTP Proxy."
PKG_TOOLCHAIN="manual"

make_target() {
  : # nothing to make here
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/aceproxy
    cp -PR $PKG_BUILD/aceclient \
           $PKG_BUILD/plugins \
           $PKG_BUILD/vlcclient \
           $PKG_BUILD/*.py \
           $INSTALL/usr/config/aceproxy

  rm -f $INSTALL/usr/config/aceproxy/setup_win32.py
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
}

post_install() {
  enable_service aceproxy.service
}
