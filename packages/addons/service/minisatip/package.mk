# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="minisatip"
PKG_VERSION="5b9ea54"
PKG_SHA256="5548933fe9092ec2dcb2cf3b3ae0f2025070d8bebbd8be829b05444e50b2a35e"
PKG_VERSION_NUMBER="0.7.16"
PKG_REV="100"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/catalinii/minisatip"
PKG_URL="https://github.com/catalinii/minisatip/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain dvb-apps libdvbcsa libxml2"
PKG_SECTION="service"
PKG_SHORTDESC="minisatip: a Sat>IP streaming server for Linux"
PKG_LONGDESC="minisatip($PKG_VERSION_NUMBER): is a Sat>IP streaming server for Linux supporting DVB-C, DVB-S/S2, DVB-T/T2, ATSC and ISDB-T"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Minisatip"
PKG_ADDON_TYPE="xbmc.service"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-netcv \
                           --enable-dvbca \
                           --enable-dvbaes \
                           --enable-dvbcsa \
                           --with-xml2=$(get_build_dir libxml2)"

pre_configure_target() {
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME

  # enables Common Interface (DVBEN50221)
  CFLAGS="$CFLAGS -I$(get_build_dir dvb-apps)/lib"
  LDFLAGS="$LDFLAGS -L$(get_build_dir dvb-apps)/lib/libdvbapi -L$(get_build_dir dvb-apps)/lib/libdvben50221 -L$(get_build_dir dvb-apps)/lib/libucsi"
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/minisatip $ADDON_BUILD/$PKG_ADDON_ID/bin
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/webif
    cp -PR $PKG_BUILD/html/* $ADDON_BUILD/$PKG_ADDON_ID/webif
}
