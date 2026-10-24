#!/system/bin/sh
. "$(dirname "$0")/lib.sh"
. "$(dirname "$0")/modmgr.sh"

ZIP_FILE="/data/local/tmp/dex_optimizer.zip"
MODE=$(echo "${1:-mode=download}" | cut -d '=' -f2)

mkdir -p "$DIRMOD"
LOGFILE="/dev/null"

set_state() { echo "$1" > "$UPDATE_STATE_FILE"; }

phase_download() {
  set_state "checking"
  log_msg "$(t "Проверка обновлений" "Checking for updates")"
  rm -f "$ZIP_FILE"

  local json latest_version zip_url resp
  json=$(http_local GET /dex_optimizer/check-update)
  latest_version=$(echo "$json" | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')
  zip_url=$(echo "$json" | sed -n 's/.*"zip_url":"\([^"]*\)".*/\1/p')
  if [ -z "$latest_version" ]; then
    log_msg "$(t "Не удалось получить данные об обновлении (нет интернета или локальный сервер недоступен)" \
                 "Failed to fetch update info (no internet or local server unavailable)")"
    set_state "error|nonet"
    return 1
  fi
  if [ "$latest_version" = "$CURRENT_VERSION" ]; then
    log_msg "$(t "Обновлений нет" "No updates available")"
    set_state "noupdate"
    return 0
  fi

  # Есть ли чем ставить — узнаём до скачивания, а не после
  if ! find_module_managers; then
    log_msg "$(t "Не удалось определить менеджер модулей. Проверено:" "Failed to determine the module manager. Checked:")"
    log_msg "$(modmgr_searched)"
    set_state "error|nomanager"
    return 1
  fi

  set_state "downloading|$latest_version"
  log_msg "$(t "Загрузка новой версии с: $zip_url" "Downloading new version from: $zip_url")"
  resp=$(http_local POST /dex_optimizer/download-update)
  case "$resp" in
    OK*) ;;
    *)
      log_msg "$(t "Не удалось загрузить обновление: $resp" "Failed to download update: $resp")"
      set_state "error|download"
      return 1
      ;;
  esac

  if [ ! -s "$ZIP_FILE" ]; then
    log_msg "$(t "Загруженный файл повреждён или пуст" "Downloaded file is corrupted or empty")"
    set_state "error|empty"
    return 1
  fi

  log_msg "$(t "Обновление $latest_version загружено, ожидается подтверждение установки" \
               "Update $latest_version downloaded, waiting for install confirmation")"
  set_state "ready|$latest_version"
}

phase_install() {
  local ver rc
  ver=$(sed -n 's/^[a-z]*|//p' "$UPDATE_STATE_FILE" 2>/dev/null | head -n 1)

  if [ ! -s "$ZIP_FILE" ]; then
    log_msg "$(t "Файл обновления не найден" "Update file not found")"
    set_state "error|nozip"
    return 1
  fi

  if ! find_module_managers; then
    log_msg "$(t "Не удалось определить менеджер модулей. Проверено:" "Failed to determine the module manager. Checked:")"
    log_msg "$(modmgr_searched)"
    set_state "error|nomanager"
    return 1
  fi

  set_state "installing|$ver"
  log_msg "$(t "Установка новой версии" "Installing new version")"
  if ! install_module_zip "$ZIP_FILE"; then
    set_state "error|install"
    return 1
  fi

  rm -f "$ZIP_FILE"
  log_msg "$(t "Модуль обновлен до версии: $ver" "Module updated to version: $ver")"
  set_state "installed|$ver"
}

phase_cancel() {
  rm -f "$ZIP_FILE"
  set_state "idle"
  log_msg "$(t "Установка обновления отменена" "Update installation cancelled")"
}

case "$MODE" in
  install) phase_install ;;
  cancel)  phase_cancel ;;
  *)       phase_download ;;
esac
