#!/system/bin/sh

MODNAME="DexOptimizer"
DEVNAME="ZerxFox"
MODREQ="Android 7+"
DEVLINK="@ZerxFox"
LINKPUB="t.me/OTATestersAndDevelopers"
LANG=$(settings get system system_locales)
IS_64BIT=$(getprop ro.product.cpu.abilist64)

is_language_supported() {
   [[ "$LANG" =~ "en-RU" || "$LANG" =~ "ru-" ]] && return 0 || return 1
}
            
install_wget() {
    SYSTEM_BIN="$MODPATH/system/bin"

    if [ -n "$IS_64BIT" ]; then
        SYSTEM_LIB="$MODPATH/system/lib64"
        SRC_BIN="$MODPATH/64/bin/wget"
        SRC_LIB="$MODPATH/64/lib64"
    else
        SYSTEM_LIB="$MODPATH/system/lib"
        SRC_BIN="$MODPATH/32/bin/wget"
        SRC_LIB="$MODPATH/32/lib"
    fi

    mkdir -p "$SYSTEM_LIB"

    cp "$SRC_BIN" "$SYSTEM_BIN"

    LIBS="libcrypto.so.3 libidn2.so libpcre2-8.so libssl.so.3 libunistring.so libuuid.so libz.so.1"
    for LIB in $LIBS; do
       cp "$SRC_LIB/$LIB" "$SYSTEM_LIB"
    done

    if [ -z "$IS_64BIT" ]; then 
        LIBS="libandroid-support.so libiconv.so"
        for LIB in $LIBS; do
            cp "$SRC_LIB/$LIB" "$SYSTEM_LIB"
        done  
   fi
}

print_info() {
    if is_language_supported; then
        ui_print " ├─ $MODNAME"
        ui_print " ├─ Информационный блок"
        ui_print " ├─ Этот модуль повышает производительность,"
        ui_print " ├─ экономит ресурсы и сокращает"
        ui_print " ├─ время запуска приложений"
        ui_print " ├─ • Разработчик:       $DEVNAME"
        ui_print " ├─ • Требования:        $MODREQ"
        ui_print " ├─ • Telegram:          $DEVLINK"
        ui_print " ├─ Отдельная благодарность за помощь в тестировании"
        ui_print " └─ TG-канал: $LINKPUB"
    else
        ui_print " ├─ $MODNAME"
        ui_print " ├─ Information block"
        ui_print " ├─ This module improves performance,"
        ui_print " ├─ saves resources and reduces"
        ui_print " ├─ application launch time"
        ui_print " ├─ • Developer:       $DEVNAME"
        ui_print " ├─ • Requirements:    $MODREQ"
        ui_print " ├─ • Telegram:        $DEVLINK"
        ui_print " ├─ Special thanks for help with testing"
        ui_print " └─ TG-channel: $LINKPUB"
    fi
}

set_permissions() {
    set_perm_recursive $MODPATH 0 0 0755 0644
    set_perm $SYSTEM_BIN/deop 0 0 0777
    set_perm $SYSTEM_BIN/wget 0 0 0755
}

is_language_supported && ui_print " ┌─ Начинаю процесс установки wget" || ui_print "┌─ Starting the wget installation process"
install_wget
is_language_supported && ui_print " ├─ wget успешно установлен!" || ui_print "├─ wget successfully install!"

print_info
set_permissions
