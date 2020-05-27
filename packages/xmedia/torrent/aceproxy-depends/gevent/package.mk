# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="gevent"
PKG_VERSION="1.4.0"
PKG_SHA256="7dee57c362240b3c15d2f9c50d4b0bb13f4cca25a9fe7adf3ae7c76ddc5e73f4"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/gevent/gevent"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host greenlet cython:host"
PKG_LONGDESC="gevent is a coroutine-based Python networking library."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION"
  export LDSHARED="$CC -shared"
  export CPPFLAGS="$CPPFLAGS $PYTHON_CPPFLAGS"
  export LDFLAGS="$LDFLAGS $PYTHON_LDFLAGS"

  cd $PKG_BUILD
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' deps/libev/configure
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' deps/c-ares/configure
}


make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}

