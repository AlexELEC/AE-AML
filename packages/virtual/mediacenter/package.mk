# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present AlexELEC (http://alexelec.in.ua)

PKG_NAME="mediacenter"
PKG_VERSION=""
PKG_LICENSE="GPL"
PKG_SITE="https://alexelec.in.ua"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain $MEDIACENTER"
PKG_SECTION="virtual"
PKG_LONGDESC="Mediacenter: Metapackage"

PKG_DEPENDS_TARGET+=" $MEDIACENTER-theme-$SKIN_DEFAULT"
for i in $SKINS; do
  PKG_DEPENDS_TARGET+=" $MEDIACENTER-theme-$i"
done

# python-based tool for kodi management
  PKG_DEPENDS_TARGET+=" texturecache.py"

# some python stuff needed for various addons
  PKG_DEPENDS_TARGET+=" Pillow simplejson pycryptodome"

# settings addon
  PKG_DEPENDS_TARGET+=" $DISTRO_PKG_SETTINGS"

# other packages
  PKG_DEPENDS_TARGET+=" xmlstarlet"

  if [ "$JOYSTICK_SUPPORT" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" peripheral.joystick"
  fi

# pvr addons
  PKG_DEPENDS_TARGET+=" pvr.hts pvr.iptvsimple"
