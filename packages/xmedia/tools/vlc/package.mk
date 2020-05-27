# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present AlexELEC (http://alexelec.in.ua)

PKG_NAME="vlc"
PKG_VERSION="3.0.6"
PKG_SHA256="18c16d4be0f34861d0aa51fbd274fb87f0cab3b7119757ead93f3db3a1f27ed3"
PKG_LICENSE="GPL"
PKG_SITE="http://www.videolan.org"
PKG_URL="https://download.videolan.org/pub/videolan/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libdvbpsi gnutls ffmpeg libmpeg2 zlib"
PKG_LONGDESC="VideoLAN multimedia player and streamer."

PKG_CONFIGURE_OPTS_TARGET="--host=$TARGET_NAME \
            --build=$HOST_NAME \
            --enable-silent-rules \
            --disable-dependency-tracking \
            --without-contrib \
            --disable-nls \
            --disable-rpath \
            --disable-dbus \
            --disable-gprof \
            --disable-cprof \
            --disable-debug \
            --enable-run-as-root \
            --disable-coverage \
            --enable-sout \
            --disable-lua \
            --enable-vlm \
            --disable-notify \
            --disable-taglib \
            --disable-live555 \
            --disable-dc1394 \
            --disable-dvdread \
            --disable-dvdnav \
            --disable-opencv \
            --disable-decklink \
            --disable-sftp \
            --enable-v4l2 \
            --disable-vcd \
            --disable-libcddb \
            --enable-dvbpsi \
            --disable-screen \
            --disable-ogg \
            --disable-shout\
            --disable-mod \
            --enable-mpc \
            --disable-gme \
            --disable-wma-fixed \
            --disable-shine \
            --disable-omxil \
            --disable-mad \
            --disable-merge-ffmpeg \
            --enable-avcodec \
            --enable-avformat \
            --enable-swscale \
            --enable-postproc \
            --disable-faad \
            --disable-flac \
            --disable-aa \
            --disable-twolame \
            --disable-realrtsp \
            --disable-libtar \
            --disable-a52 \
            --disable-dca \
            --enable-libmpeg2 \
            --disable-vorbis \
            --disable-tremor \
            --disable-speex \
            --disable-theora \
            --disable-schroedinger \
            --disable-png \
            --disable-x264 \
            --disable-fluidsynth \
            --disable-zvbi \
            --disable-telx \
            --disable-libass \
            --disable-kate \
            --disable-tiger \
            --disable-libva \
            --disable-vdpau \
            --without-x \
            --disable-xcb \
            --disable-xvideo \
            --disable-sdl-image \
            --disable-freetype \
            --disable-fribidi \
            --disable-fontconfig \
            --enable-libxml2 \
            --disable-svg \
            --disable-directx \
            --disable-caca \
            --disable-oss \
            --disable-pulse \
            --enable-alsa \
            --disable-jack \
            --disable-upnp \
            --disable-skins2 \
            --disable-kai \
            --disable-macosx \
            --disable-macosx-qtkit \
            --disable-ncurses \
            --disable-goom \
            --disable-projectm \
            --enable-udev \
            --disable-mtp \
            --disable-lirc \
            --disable-libgcrypt \
            --enable-gnutls \
            --disable-update-check \
            --disable-kva \
            --disable-bluray \
            --disable-samplerate \
            --disable-sid \
            --disable-crystalhd \
            --disable-dxva2 \
            --disable-vnc \
            --enable-vlc"

post_makeinstall_target() {
  rm -fr $INSTALL/usr/share
  rm -f $INSTALL/usr/bin/rvlc
  rm -f $INSTALL/usr/bin/vlc-wrapper

  mkdir -p $INSTALL/usr/config
    mv -f $INSTALL/usr/lib/vlc $INSTALL/usr/config
    ln -sf /storage/.config/vlc $INSTALL/usr/lib/vlc
}
