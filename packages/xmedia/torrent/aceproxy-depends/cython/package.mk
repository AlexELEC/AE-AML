# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

PKG_NAME="cython"
PKG_VERSION="0.29.10"
PKG_LICENSE="Apache-2.0"
PKG_SITE="http://cython.org/"
PKG_URL="https://github.com/cython/cython/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host setuptools:host"
PKG_LONGDESC="Cython is a language specially designed for writing Python extension modules."
PKG_TOOLCHAIN="manual"

make_host() {
  python setup.py build
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
