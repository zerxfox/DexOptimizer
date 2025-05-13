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

app_reset_count=()
lengths_reset=()

is_russian() {
  [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]
}

log_msg() {
  echo "$1" | tee -a "$LOGFILE" >> "$LOG_FILE"
}

reset_profiles() {
  count_reset="$1"
  app_reset="$2"

  time_start=$(date +%s)

  output=$(cmd package compile --reset "$app_reset" 2>&1)

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

  app_reset_count[$count_reset]=$((app_reset_count[$count_reset] + 1))

  log_msg "$(
  if is_russian; then
    cat << EOF
┌─ Прогресс: ${app_reset_count[$count_reset]} | ${lengths_reset[$count_reset]}
├─ Приложение: $app_reset
├─ Статус: $status
├─ Время: $formatted_time
└─ Процесс: #$((count_reset + 1))
EOF
  else
    cat << EOF
┌─ Progress: ${app_reset_count[$count_reset]} | ${lengths_reset[$count_reset]}
├─ App: $app_compile
├─ Status: $status
├─ Time: $formatted_time
└─ Process: #$((count_reset + 1))
EOF
  fi
)"
}

process_reset_part() {
  count_reset_part="$1"
  app_reset_part="$2"
  
  for pack in $app_reset_part; do
    reset_profiles "$count_reset_part" "$pack"
  done
}

get_package_size() {
  package_name=$1
  apk_path=$(pm path "$package_name" | cut -d':' -f2)
  if [ -n "$apk_path" ]; then
    size=$(stat -c%s "$apk_path" 2>/dev/null)
    echo "$size"
  else
    echo 0
  fi
}

reset_mode(){
  PACKAGES="$1" #APP_TYPE
  PARTS="$2" #PROCESS_COUNT
  APPS_NAME="$3" #APP_NAME 
  
  start_time=$(date +%s)

  case "$PACKAGES" in
    user) packages_file=$(pm list packages -3 | cut -d':' -f2) ;;  # user
    system) packages_file=$(pm list packages -s | cut -d':' -f2) ;;  # system
    all) packages_file=$(pm list packages | cut -d':' -f2) ;;     # all
    selectively) packages_file=$(echo "$APPS_NAME" | sed 's/%2C/ /g') ;; # selectively
  esac

  log_msg "$(is_russian && echo "¦ Сортировка приложений по размеру" || echo "¦ Sorting applications by size")"
  sorted_packages=$(while read -r pkg; do
    size=$(get_package_size "$pkg")
    echo "$size $pkg"
  done <<< "$packages_file" | sort -nr)

  total_count=$(echo "$sorted_packages" | wc -l)
  part_size=$(( (total_count + PARTS - 1) / PARTS ))

  parts=()
  i=0
  while [ $i -lt $PARTS ]; do
    parts[$i]=""
    app_reset_count[$i]=0
    lengths_reset[$i]=0
    i=$((i + 1))
  done

  i=0
  while read -r size pkg; do
    part_index=$((i % PARTS))
    parts[$part_index]="${parts[$part_index]} $pkg"
    lengths_reset[$part_index]=$(echo "${parts[$part_index]}" | wc -w)
    i=$((i + 1))
  done <<< "$sorted_packages"

  log_msg "$(is_russian && echo "¦ Очистка профиля приложений" || echo "¦ Clearing apps profile")"
  i=0
  while [ $i -lt $PARTS ]; do
    process_reset_part "$i" "${parts[$i]}" &
    i=$((i + 1))
  done
  wait

  log_msg "$(is_russian && echo "¦ Профиль приложений очищен" || echo "¦ Apps profile cleared")"
  execution_time=$(( $(date +%s) - start_time ))
  local message="$(is_russian && echo "Время работы скрипта: $((execution_time / 60)) минут и $((execution_time % 60)) секунд" || echo "Script execution time: $((execution_time / 60)) minutes and $((execution_time % 60)) seconds.")"
  log_msg "$message"
}

APP_TYPE=$(echo "$1" | cut -d '=' -f2)
PROCESS_COUNT=$(echo "$2" | cut -d '=' -f2)
APP_NAME=$(echo "$3" | cut -d '=' -f2)

log_msg "$(is_russian && echo -e "Имя устройства: $(getprop ro.product.name)\nМодель устройства: $(getprop ro.product.system.model)\nВерсия модуля: $CURRENT_VERSION" || echo -e "Device Name: $(getprop ro.product.name)\nSystem Model: $(getprop ro.product.system.model)\nModule version: $CURRENT_VERSION")"

reset_mode "$APP_TYPE" "$PROCESS_COUNT" "$APP_NAME"

echo "$(date '+%Y-%m-%d %H:%M:%S')|clean|$execution_time" | tee -a "$STATS_FILE"

sleep 3

rm -f "$LOGFILE" 2>/dev/null