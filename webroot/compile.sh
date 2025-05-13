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

app_count=()
lengths=()

is_russian() {
  [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]
}

log_msg() {
  echo "$1" | tee -a "$LOGFILE" >> "$LOG_FILE"
}

choose_profile() {
  package_profile=$1
  bucket_value=$(am get-standby-bucket "$package_profile")
  [ -n "$bucket_value" ] && [ "$bucket_value" -gt 10 ] && echo "speed-profile" || echo "everything-profile"
}

choose_profile_old() {
  package_profile_old=$1

  bucket_value=$(dumpsys usagestats | grep "package=$package_profile_old" | grep -o 'lastUsedElapsed=+[0-9d]*[0-9h]*[0-9m]*[0-9s]*[0-9]*ms*' | head -n 1 | tr -d 'lastUsedElapsed=+')

  if [ -n "$bucket_value" ]; then
    total_seconds=0

    for unit in d h m s ms; do
      if [[ "$bucket_value" == *"$unit"* ]]; then
        value=$(echo "$bucket_value" | cut -d"$unit" -f1)
        case "$unit" in
          d) total_seconds=$((total_seconds + value * 86400)) ;;
          h) total_seconds=$((total_seconds + value * 3600)) ;;
          m) total_seconds=$((total_seconds + value * 60)) ;;  
          s) total_seconds=$((total_seconds + value)) ;;           
          ms) :
        esac
        bucket_value=${bucket_value#*$unit}
      fi
    done

    [ "$total_seconds" -gt 600 ] && echo "speed-profile" || echo "everything-profile"
  else
    echo "everything-profile"
  fi
}

compile_profile() {
  count_compile="$1"
  app_compile="$2"
  profile_name="$3" 

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
┌─ Прогресс: ${app_count[$count_compile]} | ${lengths[$count_compile]}
├─ Приложение: $app_compile
├─ Профиль: $profile_name
├─ Статус: $status
├─ Время: $formatted_time
└─ Процесс: #$((count_compile + 1))
EOF
  else
    cat << EOF
┌─ Progress: ${app_count[$count_compile]} | ${lengths[$count_compile]}
├─ App: $app_compile
├─ Profile: $profile_name
├─ Status: $status
├─ Time: $formatted_time
└─ Process: #$((count_compile + 1))
EOF
  fi
)"
}

process_part() {
  count_part="$1"
  app_part="$2"
  profile_process="$3"
  
  for pack in $app_part; do
    if [ "$profile_process" = "auto" ]; then
      if [ "$SDK_VERSION" -ge 23 ] && [ "$SDK_VERSION" -le 27 ]; then
        selected_profile=$(choose_profile_old "$pack")
      else
        selected_profile=$(choose_profile "$pack")
      fi
    else
      selected_profile="$profile_process"
    fi
    compile_profile "$count_part" "$pack" "$selected_profile"
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

script_mode() {
  mode_script="$1" #MODE
  PACKAGES="$2" #APPS
  profile_script="$3" #PROFILE
  PARTS="$4" #PROCESSES
  bgdj="$5" #BACKGROUND

  case "$PACKAGES" in
    user) packages_file=$(pm list packages -3 | cut -d':' -f2) ;;  # user
    system) packages_file=$(pm list packages -s | cut -d':' -f2) ;;  # system
    all) packages_file=$(pm list packages | cut -d':' -f2) ;;     # all
  esac

  log_msg "$(is_russian && echo "¦ Сортировка приложений по размеру" || echo "¦ Sorting applications by size")"

  sorted_packages=$(while read -r pkg; do
    [ -n "$pkg" ] || continue
    size=$(get_package_size "$pkg")
    [ -z "$size" ] && size=0
    echo "$size $pkg"
  done <<< "$packages_file" | sort -nr)

  total_count=$(echo "$sorted_packages" | wc -l)
  part_size=$(( (total_count + PARTS - 1) / PARTS ))

  echo ""

  if [ "$mode_script" = "auto" ]; then
    log_msg "$(is_russian && echo "¦ Выбран режим работы скрипта: Автоматический" || echo "¦ Selected the script operation: Automatic")"
  else
    log_msg "$(is_russian && echo "¦ Выбран режим работы скрипта: Ручной" || echo "¦ Selected the script operation: Manual")"
    log_msg "$(is_russian && echo "¦ Выбранные пакеты: $PACKAGES" || echo "¦ Selected packages: $PACKAGES")"
    log_msg "$(is_russian && echo "¦ Выбранный профиль: $profile_script" || echo "¦ Selected profile: $profile_script")"
  fi
  log_msg "$(is_russian && echo "¦ Количество процессов: $PARTS" || echo "¦ Count of processes: $PARTS")"
  log_msg "$(is_russian && echo "¦ Количество приложений: $total_count" || echo "¦ Count of apps: $total_count")"
  echo ""
  log_msg "$(is_russian && echo "¦ Скрипт запущен" || echo "¦ The script is running")"
  start_time=$(date +%s)

  parts=()
  i=0
  while [ $i -lt $PARTS ]; do
    parts[$i]=""
    app_count[$i]=0
    lengths[$i]=0
    i=$((i + 1))
  done

  i=0
  while read -r size pkg; do
    part_index=$((i % PARTS))
    parts[$part_index]="${parts[$part_index]} $pkg"
    lengths[$part_index]=$(echo "${parts[$part_index]}" | wc -w)
    i=$((i + 1))
  done <<< "$sorted_packages"

  log_msg "$(is_russian && echo "¦ Компиляция пакетов" || echo "¦ Compiling packages")"
  i=0
  while [ $i -lt $PARTS ]; do
    process_part "$i" "${parts[$i]}" "$profile_script" &
    i=$((i + 1))
  done
  wait

  if [ "$bgdj" -eq 1 ]; then
    log_msg "$(is_russian && echo "¦ Выполнение задачи оптимизации DEX" || echo "¦ Executing DEX Optimization Task")"
    output=$(cmd package bg-dexopt-job 2>&1) 
    if echo "$output" | grep -q "Job finished"; then
      log_msg "$(is_russian && echo "¦ Задача завершена" || echo "¦ Task finished")"
    else
      log_msg "$(is_russian && echo "¦ Ошибка выполнения задачи" || echo "¦ Task execution error")"
    fi
  fi

  execution_time=$(( $(date +%s) - start_time ))
  local message="$(is_russian && echo "Время работы скрипта: $((execution_time / 60)) минут и $((execution_time % 60)) секунд" || echo "Script execution time: $((execution_time / 60)) minutes and $((execution_time % 60)) seconds.")"
  log_msg "$message"
}

MODE=$(echo "$1" | cut -d '=' -f2) #auto, manual
APPS=$(echo "$2" | cut -d '=' -f2) #sys, user, all
PROFILE=$(echo "$3" | cut -d '=' -f2) #auto, every, speed
PROCESSES=$(echo "$4" | cut -d '=' -f2) #1-25
BACKGROUND=$(echo "$5" | cut -d '=' -f2) # 1:0

log_msg "$(is_russian && echo -e "Имя устройства: $(getprop ro.product.name)\nМодель устройства: $(getprop ro.product.system.model)\nВерсия модуля: $CURRENT_VERSION" || echo -e "Device Name: $(getprop ro.product.name)\nSystem Model: $(getprop ro.product.system.model)\nModule version: $CURRENT_VERSION")"

script_mode $MODE $APPS $PROFILE $PROCESSES $BACKGROUND

echo "$(date '+%Y-%m-%d %H:%M:%S')|compile|$execution_time" | tee -a "$STATS_FILE"

sleep 3

rm -f "$LOGFILE" 2>/dev/null