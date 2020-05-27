# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="actkbd"
PKG_VERSION="0.2.8"
PKG_SHA256="95ea643b8e1b6bd8b9bc342d4a01eb4639498e15329aa42329f7cc83cb3cebc6"
PKG_LICENSE="GPL"
PKG_SITE="http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd"
PKG_URL="http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/files/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A keyboard shortcut daemon."

make_target() {
  make prefix="/usr" sysconfdir="/storage/.config/actkbd"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/sbin
    cp actkbd $INSTALL/usr/sbin

  mkdir -p $INSTALL/usr/config/actkbd
    cp $PKG_DIR/config/actkbd.conf $INSTALL/usr/config/actkbd/actkbd.conf.sample
}

post_install() {
  enable_service actkbd.service
}
