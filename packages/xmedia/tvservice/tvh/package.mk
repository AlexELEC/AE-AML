# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="tvh"
PKG_VERSION="6be300c"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvheadend.org"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain avahi curl dvb-apps libdvbcsa libiconv openssl pngquant:host Python2:host"
PKG_LONGDESC="Tvheadend: a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources."
PKG_TOOLCHAIN="configure"

#colors
YELLOW="\033[1;33m"
ENDCOLOR="\033[0m"

unpack() {
  git clone -b 'master' https://github.com/tvheadend/tvheadend.git $PKG_BUILD
  cd $PKG_BUILD
  git reset --hard $PKG_VERSION
  TVH_VERSION_NUMBER=`git describe --match "v*" | sed 's/-g.*$//'`
  echo "-----------------------------------------------------------"
  echo -e $YELLOW"****** Tvheadend version: $TVH_VERSION_NUMBER ******"$ENDCOLOR
  echo "-----------------------------------------------------------"
  cd $ROOT
}

post_unpack() {
  sed -e 's|@TVH_VERSION_NUMBER@|'$TVH_VERSION_NUMBER'|g' -i $PKG_BUILD/support/version
  sed -e 's|'/usr/bin/pngquant'|'$TOOLCHAIN/bin/pngquant'|g' -i $PKG_BUILD/support/mkbundle
}

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                             --arch=$TARGET_ARCH \
                             --cpu=$TARGET_CPU \
                             --cc=$CC \
                             --disable-uriparser \
                             --disable-ffmpeg_static \
                             --disable-libav \
                             --disable-vaapi \
                             --disable-bintray_cache \
                             --disable-hdhomerun_static \
                             --disable-dbus_1 \
                             --disable-dvbscan \
                             --disable-libmfx_static \
                             --enable-avahi \
                             --enable-dvbcsa \
                             --enable-tvhcsa \
                             --enable-bundle \
                             --enable-epoll \
                             --enable-inotify \
                             --enable-pngquant \
                             --enable-ccdebug \
                             --nowerror \
                             --python=$TOOLCHAIN/bin/python"

# fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME

  export CROSS_COMPILE=$TARGET_PREFIX
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/iconv -L$SYSROOT_PREFIX/usr/lib/iconv"
}

post_make_target() {
  $CC -O -fbuiltin -fomit-frame-pointer -fPIC -shared -o capmt_ca.so src/extra/capmt_ca.c -ldl
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P capmt_ca.so $INSTALL/usr/lib

  mkdir -p $INSTALL/usr/bin
    cp -P $PKG_DIR/scripts/* $INSTALL/usr/bin
    cp -P support/sat_xml_scan.py $INSTALL/usr/bin/sat_xml_scan

  #sat files
  echo "-----------------------------------------------------------"
  echo -e $YELLOW"****** Tvheadend: get transponder files...******"$ENDCOLOR
  echo "-----------------------------------------------------------"
  git clone -b 'master' https://github.com/tvheadend/dtv-scan-tables.git data/dvb-scan
  mkdir -p $INSTALL/usr/config/tvheadend
  mkdir -p $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/atsc $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-c $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-s $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-t $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/isdb-t $INSTALL/usr/config/tvheadend/dvb-scan
  #config
    rm -f $INSTALL/usr/config/tvheadend/dvb-scan/dvb-t/ua-Kyiv
    rm -f $INSTALL/usr/config/tvheadend/dvb-scan/dvb-s/Amos-*
    rm -f $INSTALL/usr/config/tvheadend/dvb-scan/dvb-s/Sirius-*
    cp -a $PKG_DIR/config/* $INSTALL/usr/config/tvheadend
    cp $PKG_DIR/src/* $INSTALL/usr/config
  #DVB & TTV networks
  rm -fr $INSTALL/usr/share/tvheadend
  mkdir -p $INSTALL/usr/share/tvheadend
    cp -a $PKG_DIR/networks $INSTALL/usr/share/tvheadend
}

post_install() {
  enable_service tvheadend.service
}
