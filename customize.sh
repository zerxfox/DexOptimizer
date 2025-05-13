#!/system/bin/sh

MODNAME="DexOptimizer"
DEVNAME="@ZerxFox"
MODREQ="Android 7+"
DEVLINK="t.me/GhostCISProject_TaD"
LINKPUB="t.me/GhostCISProject"
LANG=$(settings get system system_locales)
WEBROOT_DIR="$MODPATH/webroot"
WEBROOT_MODULE="/data/adb/modules/webroot"
SYSTEM_BIN="$MODPATH/system/bin"
MODVERSION="8.0.0"
ARCH=$(uname -m)

is_language_supported() {
   [[ "$LANG" =~ "en-RU" || "$LANG" =~ "ru-" ]] && return 0 || return 1
}

install_wget() {
    case $ARCH in
        aarch32|armv7*|armv8l|armhf)
            SRC_DIR="armv7"
            LIB_DIR="lib"
            ;;
        aarch64|armv8)
            SRC_DIR="armv8"
            LIB_DIR="lib64"
            ;;
        *)
            ui_print "$(is_language_supported && echo ' └─ Неподдерживаемая архитектура' || echo ' └─ Unsupported architecture'): $ARCH"
            exit 1
            ;;
    esac

    mkdir -p "$MODPATH/system/$LIB_DIR"
    cp -r "$MODPATH/$SRC_DIR/$LIB_DIR/"* "$MODPATH/system/$LIB_DIR/"
    
    cp -r "$MODPATH/$SRC_DIR/bin/"* "$MODPATH/system/bin/"

    ui_print "$(is_language_supported && echo ' ├─ Файлы успешно скопированы для архитектуры' || echo ' ├─ Files have been copied successfully for architecture'): $ARCH"

    rm -r $MODPATH/armv8 $MODPATH/armv7
}

print_info() {
    if [ -d "$WEBROOT_MODULE" ]; then
        WEBROOT_STATUS=$(is_language_supported && echo "установлен" || echo "installed")
        WEBROOT_ICON="🟢"
    else
        WEBROOT_STATUS=$(is_language_supported && echo "не установлен" || echo "not installed")
        WEBROOT_ICON="🔴"
    fi

    if is_language_supported; then
        ui_print " "
        ui_print "⚡ ${MODNAME} - ускоряет загрузку приложений через оптимизацию DEX-кода"
        ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        ui_print " "
        ui_print "📦 Основная информация"
        ui_print "  👨‍💻 Разработчик:    $DEVNAME"
        ui_print "  📅 Версия:         $MODVERSION"
        ui_print " "
        ui_print "⚙️ Системные данные"
        ui_print "  ${WEBROOT_ICON} Webroot Manager: $WEBROOT_STATUS"
        ui_print "  📱 Требования:     $MODREQ"
        ui_print "  🏗️ Архитектура:    ${ARCH}"
        ui_print " "
        ui_print "🌍 Связь и обновления"
        ui_print "  📢 Telegram-чат:   $DEVLINK"
        ui_print "  📣 Новостной канал: $LINKPUB"
        ui_print " "
        ui_print "🙏 Благодарности"
        ui_print "  Спасибо всем тестерам и участникам сообщества!"
        ui_print " "
        ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        ui_print " "
        ui_print "⚡ ${MODNAME} - boosts app launch speed through DEX code optimization"
        ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        ui_print " "
        ui_print "📦 Core Information"
        ui_print "  👨‍💻 Developer:     $DEVNAME"
        ui_print "  📅 Version:       $MODVERSION"
        ui_print " "
        ui_print "⚙️ System Data:"
        ui_print "  ${WEBROOT_ICON} Webroot Manager: $WEBROOT_STATUS"
        ui_print "  📱 Requirements:   $MODREQ"
        ui_print "  🏗️ Architecture:   ${ARCH}"
        ui_print " "
        ui_print "🌍 Communication"
        ui_print "  📢 Telegram Chat:  $DEVLINK"
        ui_print "  📣 News Channel:   $LINKPUB"
        ui_print " "
        ui_print "🙏 Acknowledgments"
        ui_print "  Thanks to all testers and community members!"
        ui_print " "
        ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
}

set_permissions() {
    set_perm_recursive $MODPATH 0 0 0755 0644
    set_perm $SYSTEM_BIN/deop 0 0 0777
    set_perm $SYSTEM_BIN/wget 0 0 0755
    set_perm $WEBROOT_DIR/compile.sh 0 0 0777
    set_perm $WEBROOT_DIR/clean.sh 0 0 0777
    set_perm $WEBROOT_DIR/profile.sh 0 0 0777
    set_perm $WEBROOT_DIR/update.sh 0 0 0777
}

is_language_supported && ui_print " ┌─ Начинаю процесс установки wget" || ui_print "┌─ Starting the wget installation process"
install_wget
is_language_supported && ui_print " └─ wget успешно установлен!" || ui_print "└─ wget successfully install!"

print_info
set_permissions
