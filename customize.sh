#!/bin/bash

MODNAME="DexOptimizer"
DEVNAME="ZerxFox, Magellan"
MODREQ="Android 6+"
DEVLINK="@ZerxFox"
LINKPUB="t.me/OTATestersAndDevelopers"
LANG=$(settings get system system_locales)

print_info() {
    if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
        ui_print " | $MODNAME"
        ui_print " | Информационный блок"
        ui_print " | Этот модуль повышает производительность,"
        ui_print " | экономит ресурсы и сокращает"
        ui_print " | время запуска приложений"
        ui_print " | • Разработчик:       $DEVNAME"
        ui_print " | • Требования:        $MODREQ"
        ui_print " | • Telegram:          $DEVLINK"
        ui_print " | Отдельная благодарность за помощь в тестировании"
        ui_print " | TG-канал: $LINKPUB"
    else
        ui_print " | $MODNAME"
        ui_print " | Information block"
        ui_print " | This module improves performance,"
        ui_print " | saves resources and reduces"
        ui_print " | application launch time"
        ui_print " | • Developer:       $DEVNAME"
        ui_print " | • Requirements:    $MODREQ"
        ui_print " | • Telegram:        $DEVLINK"
        ui_print " | Special thanks for help with testing"
        ui_print " | TG-channel: $LINKPUB"
    fi
}
print_info

set_permissions() {
    set_perm_recursive $MODPATH 0 0 0755 0644
    set_perm $MODPATH/system/bin/deop 0 0 0777
}
set_permissions
