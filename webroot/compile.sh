#!/system/bin/sh

. "$(dirname "$0")/lib.sh"

begin_run compile

MODE=$(echo "$1" | cut -d '=' -f2)               #auto, manual
APPS=$(echo "$2" | cut -d '=' -f2)               #user, system, all
PROFILE=$(echo "$3" | cut -d '=' -f2)             #auto, everything-profile, speed-profile
PROCESSES=$(clamp_parts "$(echo "$4" | cut -d '=' -f2)")   #1-25
BACKGROUND=$(echo "$5" | cut -d '=' -f2)          # 1:0

log_device_info

case "$APPS" in
  user)   packages_file=$(list_packages -3) ;;
  system) packages_file=$(list_packages -s) ;;
  all)    packages_file=$(list_packages)    ;;
  *)      packages_file=$(list_packages)    ;;
esac

log_msg "$(t "¦ Сортировка приложений по размеру" "¦ Sorting applications by size")"
sorted=$(echo "$packages_file" | sort_by_size)
total_count=$(count_lines "$sorted")

partition_into "$PROCESSES" "$sorted"

echo ""
if [ "$MODE" = "auto" ]; then
  log_msg "$(t "¦ Выбран режим работы скрипта: Автоматический" "¦ Selected the script operation: Automatic")"
else
  log_msg "$(t "¦ Выбран режим работы скрипта: Ручной" "¦ Selected the script operation: Manual")"
  log_msg "$(t "¦ Выбранные пакеты: $APPS" "¦ Selected packages: $APPS")"
  log_msg "$(t "¦ Выбранный профиль: $PROFILE" "¦ Selected profile: $PROFILE")"
fi
log_msg "$(t "¦ Количество процессов: $PROCESSES" "¦ Count of processes: $PROCESSES")"
log_msg "$(t "¦ Количество приложений: $total_count" "¦ Count of apps: $total_count")"
echo ""
log_msg "$(t "¦ Скрипт запущен" "¦ The script is running")"
start_time=$(date +%s)

reset_success_counter
log_event "@RUN|compile|$MODE|$PROFILE|$PROCESSES|$total_count|$start_time"
dispatch_parallel compile "$PROCESSES" "$PROFILE"

if [ "$BACKGROUND" = "1" ]; then
  run_dexopt_job
fi

execution_time=$(( $(date +%s) - start_time ))
log_msg "$(t "Время работы скрипта: $((execution_time / 60)) минут и $((execution_time % 60)) секунд" \
             "Script execution time: $((execution_time / 60)) minutes and $((execution_time % 60)) seconds.")"

log_event "@END|$execution_time|$total_count|$(count_success)"
write_stats "compile" "$execution_time" "$total_count" "$(count_success)"

finish