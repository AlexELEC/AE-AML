# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="tvh42"
PKG_VERSION="0a60f73"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/tvheadend/tvheadend"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain avahi curl dvb-apps libdvbcsa libiconv openssl pngquant:host Python2:host"
PKG_LONGDESC="Tvheadend: a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources."
PKG_TOOLCHAIN="configure"

#colors
YELLOW="\033[1;33m"
ENDCOLOR="\033[0m"

unpack() {
  git clone -b 'release/4.2' https://github.com/tvheadend/tvheadend.git $PKG_BUILD
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
                             --nowerror \
                             --python=$TOOLCHAIN/bin/python"

# fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME

  export CROSS_COMPILE=$TARGET_PREFIX
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/iconv -L$SYSROOT_PREFIX/usr/lib/iconv"
}

post_makeinstall_target() {
  mv -f $INSTALL/usr/bin/tvheadend $INSTALL/usr/bin/tvheadend42
  rm -rf $INSTALL/usr/share/tvheadend
# config
  mkdir -p $INSTALL/usr/config/tvheadend42
    cp -a $PKG_DIR/config/* $INSTALL/usr/config/tvheadend42
}
