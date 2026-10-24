#!/system/bin/sh

. "$(dirname "$0")/lib.sh"

begin_run clean

APP_TYPE=$(echo "$1" | cut -d '=' -f2)
PROCESS_COUNT=$(clamp_parts "$(echo "$2" | cut -d '=' -f2)")
APP_NAME=$(echo "$3" | cut -d '=' -f2)

log_device_info

case "$APP_TYPE" in
  user)        packages_file=$(list_packages -3) ;;
  system)      packages_file=$(list_packages -s) ;;
  all)         packages_file=$(list_packages)    ;;
  selectively) packages_file=$(decode_app_list "$APP_NAME") ;;
  *)           packages_file=$(list_packages)    ;;
esac

log_msg "$(t "¦ Сортировка приложений по размеру" "¦ Sorting applications by size")"
sorted=$(echo "$packages_file" | sort_by_size)
total_count=$(count_lines "$sorted")

partition_into "$PROCESS_COUNT" "$sorted"

start_time=$(date +%s)
log_msg "$(t "¦ Очистка профиля приложений" "¦ Clearing apps profile")"
reset_success_counter
log_event "@RUN|clean|-|-|$PROCESS_COUNT|$total_count|$start_time"
dispatch_parallel reset "$PROCESS_COUNT"
log_msg "$(t "¦ Профиль приложений очищен" "¦ Apps profile cleared")"

execution_time=$(( $(date +%s) - start_time ))
log_msg "$(t "Время работы скрипта: $((execution_time / 60)) минут и $((execution_time % 60)) секунд" \
             "Script execution time: $((execution_time / 60)) minutes and $((execution_time % 60)) seconds.")"

log_event "@END|$execution_time|$total_count|$(count_success)"
write_stats "clean" "$execution_time" "$total_count" "$(count_success)"

finish