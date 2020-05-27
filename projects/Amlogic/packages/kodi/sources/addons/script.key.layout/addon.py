# -*- coding: utf-8 -*-

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

import xbmc
import xbmcaddon
import json

__author__ = 'AlexELEC'
__scriptid__ = 'script.key.layout'
__addon__ = xbmcaddon.Addon(id=__scriptid__)
__cwd__ = __addon__.getAddonInfo('path')

def notify(message):
    xbmc.executebuiltin('Notification("Keybord", "%s", 5000, "%s/icon.png")' % (message, __cwd__))

def main():
    kodi_json = {}
    params = {}
    params["setting"] = "input.libinputkeyboardlayout"
    kodi_json["jsonrpc"] = "2.0"
    kodi_json["method"] = "Settings.GetSettingValue"
    kodi_json["params"] = params
    kodi_json["id"] = 1

    request = xbmc.executeJSONRPC(json.dumps(kodi_json).encode("utf-8"))
    response = json.loads(request.decode('utf-8', 'replace'))

    if 'result' in response:
        kodi_json["method"] = "Settings.SetSettingValue"
        params["setting"] = "input.libinputkeyboardlayout"
        if response['result']['value'] == 'us':
            params["value"] = "ru"
            request = xbmc.executeJSONRPC(json.dumps(kodi_json).encode("utf-8"))
            response = json.loads(request.decode('utf-8', 'replace'))
            if response['result']:
                notify("set keyboard layout: Russian (RU)")
            else:
                notify("Error set keyboard layout!")
        else:
            params["value"] = "us"
            request = xbmc.executeJSONRPC(json.dumps(kodi_json).encode("utf-8"))
            response = json.loads(request.decode('utf-8', 'replace'))
            if response['result']:
                notify("set keyboard layout: English (US)")
            else:
                notify("Error set keyboard layout!")

if (__name__ == '__main__'):
    main()
