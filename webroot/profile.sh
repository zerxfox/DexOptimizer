#!/system/bin/sh

LANG=$(settings get system system_locales)
SDK_VERSION=$(getprop ro.build.version.sdk)
DIRMOD="/storage/emulated/0/DexOptimizer"
DIRMOD_LOGS="/data/adb/modules/dex_optimizer/webroot"
LOGFILE="${DIRMOD_LOGS}/script_logs.out"
LOG_FILE="${DIRMOD}/script_log.txt"
STATS_FILE="${DIRMOD_LOGS}/stats.txt"
CURRENT_VERSION="8.0.0"

mkdir -p "$DIRMOD"
: > "$LOG_FILE" "$LOGFILE"

is_russian() {
  [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]
}

log_msg() {
  echo "$1" | tee -a "$LOGFILE" >> "$LOG_FILE"
}

compile_profile() {
  count_compile="$1"
  app_compile="$2"
  profile_name="$3" 
  package_count="$4"
  time_start=$(date +%s)

  output=$(case "$SDK_VERSION" in
    [2][3-8]) cmd package compile -m "$profile_name" --check-prof true -f "$app_compile" ;;
    [2][9]|3[0-3]) cmd package compile -m "$profile_name" -f "$app_compile" 2>&1 ;;
    [3][4-5]) cmd package compile -m "$profile_name" -p PRIORITY_INTERACTIVE_FAST -f --full "$app_compile" 2>&1 ;;
  esac)

  time_end=$(date +%s)
  time_diff=$((time_end - time_start))
  
  minutes=$((time_diff / 60))
  seconds=$((time_diff % 60))

  formatted_time="${minutes}m ${seconds}s"

  if echo "$output" | grep -q "Success"; then
    status=$(is_russian && echo "Успех" || echo "Success")
  else
    status=$(is_russian && echo "Ошибка" || echo "Failed")
  fi

  app_count[$count_compile]=$((app_count[$count_compile] + 1))

  log_msg "$(
  if is_russian; then
    cat << EOF
┌─ Прогресс: ${app_count[$count_compile]} | $package_count
├─ Приложение: $app_compile
├─ Профиль: $profile_name
├─ Статус: $status
├─ Время: $formatted_time
└─ Процесс: #$((count_compile + 1))
EOF
  else
    cat << EOF
┌─ Progress: ${app_count[$count_compile]} | $package_count
├─ App: $app_compile
├─ Profile: $profile_name
├─ Status: $status
├─ Time: $formatted_time
└─ Process: #$((count_compile + 1))
EOF
  fi
)"
}

select_app_by_name() {
  APPS_NAME="$1"
  APPS_PROFILE="$2"

  start_time=$(date +%s)

  log_msg "$(is_russian && echo "¦ Применение профиля" || echo "¦ Profile application")"

  packages_file=$(echo "$APPS_NAME" | sed 's/%2C/ /g')
  profile="$APPS_PROFILE" 

  packages_count=$(echo "$packages_file" | wc -w)

  for app in $packages_file; do
    compile_profile 0 "$app" "$profile" "$packages_count"
  done
  
  wait

  log_msg "$(is_russian && echo "¦ Профиль применён" || echo "¦ The profile has been applied")"
  execution_time=$(( $(date +%s) - start_time ))
  local message="$(is_russian && echo "Время работы скрипта: $((execution_time / 60)) минут и $((execution_time % 60)) секунд" || echo "Script execution time: $((execution_time / 60)) minutes and $((execution_time % 60)) seconds.")"
  log_msg "$message"
}

APP_PROFILE=$(echo "$1" | cut -d '=' -f2)
APP_NAME=$(echo "$2" | cut -d '=' -f2)

log_msg "$(is_russian && echo -e "Имя устройства: $(getprop ro.product.name)\nМодель устройства: $(getprop ro.product.system.model)\nВерсия модуля: $CURRENT_VERSION" || echo -e "Device Name: $(getprop ro.product.name)\nSystem Model: $(getprop ro.product.system.model)\nModule version: $CURRENT_VERSION")"

select_app_by_name "$APP_NAME" "$APP_PROFILE"

echo "$(date '+%Y-%m-%d %H:%M:%S')|profile|$execution_time" | tee -a "$STATS_FILE"

sleep 3

rm -f "$LOGFILE" 2>/dev/null