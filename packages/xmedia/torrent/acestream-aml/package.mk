# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="acestream-aml"
PKG_VERSION="latest"
PKG_LICENSE="GPL"
PKG_SITE="http://www.acestream.com/"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain M2Crypto"
PKG_LONGDESC="This is an innovative media platform of a new generation, which will take you to a new high-quality level of multimedia space on the Internet."
PKG_TOOLCHAIN="manual"

make_target() {
  : # nothing to make here
}

makeinstall_target() {
  mkdir -p $INSTALL
    cp -PR ./* $INSTALL
}

post_install() {
  enable_service acestream.service
  enable_service aceupd-playlist.service
}
