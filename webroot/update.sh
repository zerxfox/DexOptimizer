#!/system/bin/sh

LANG=$(settings get system system_locales)
DIRMOD="/storage/emulated/0/DexOptimizer"
LOG_FILE="${DIRMOD}/script_log.txt"
CURRENT_VERSION="8.0.0"
UPDATE_URL="https://raw.githubusercontent.com/zerxfox/DexOptimizer/main/update.json"

is_russian() {
  [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]
}

log_msg() {
  echo "$1" | tee -a "$LOG_FILE"
}

module_update() {
  if ping -c 1 google.com &> /dev/null; then
    ZIP_FILE="/data/local/tmp/dex_optimizer.zip"
    : > "$ZIP_FILE"
    
    log_msg "$(is_russian && echo "Проверка обновлений" || echo "Checking for updates")"
    LATEST_VERSION=$(wget --no-check-certificate -qO- "$UPDATE_URL" | grep '"version":' | cut -d '"' -f 4)

    if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
      ZIP_URL=$(wget --no-check-certificate -qO- "$UPDATE_URL" | grep '"zipUrl":' | cut -d '"' -f 4)

      log_msg "$(is_russian && echo "Загрузка новой версии с: \n$ZIP_URL" || echo "Downloading new version from: \n$ZIP_URL")"

      wget --no-check-certificate -O "$ZIP_FILE" "$ZIP_URL"

      if [ -f "$ZIP_FILE" ]; then
        log_msg "$(is_russian && echo "Установка новой версии" || echo "Installing new version")"

        if [ -d "/data/adb/magisk" ]; then
          magisk --install-module "$ZIP_FILE"
        elif ksud --version >/dev/null 2>&1 && [ -d "/data/adb/ksu" ]; then
          ksud module install "$ZIP_FILE"
        elif apd --version >/dev/null 2>&1 && [ -d "/data/adb/ap" ]; then
          apd module install "$ZIP_FILE"
        else
          log_msg "$(is_russian && echo "Не удалось определить менеджер модулей" || echo "Failed to determine the module manager")"
          exit 1
        fi

        log_msg "$(is_russian && echo "Модуль обновлен до версии: $LATEST_VERSION" || echo "Module updated to version: $LATEST_VERSION")"
      else
        log_msg "$(is_russian && echo "Не удалось загрузить обновление" || echo "Failed to download update")" 
      fi
    else
      log_msg "$(is_russian && echo "Обновлений нет" || echo "No updates available")"
    fi
  else
    log_msg "$(is_russian && echo "Нет подключения к интернету. Проверьте соединение." || echo "No internet connection. Please check your connection.")"
  fi
}
module_update