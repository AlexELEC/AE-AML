# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="requests"
PKG_VERSION="2.22.0"
PKG_SHA256="dcacea1b6a7bfd2cbb6c6a05743606b428f2739f37825e41fbf79af3cc2fd240"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/requests/requests"
PKG_URL="$PKG_SITE/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host urllib3 idna chardet"
PKG_LONGDESC="Python HTTP for Humans."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
}
