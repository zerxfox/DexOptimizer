#!/system/bin/sh

. "$(dirname "$0")/lib.sh"

begin_run profile

APP_PROFILE=$(echo "$1" | cut -d '=' -f2)
APP_NAME=$(echo "$2" | cut -d '=' -f2)

log_device_info

log_msg "$(t "¦ Применение профиля" "¦ Profile application")"
start_time=$(date +%s)

packages_file=$(decode_app_list "$APP_NAME")
total_count=$(echo "$packages_file" | wc -w)

worker_total[0]="$total_count"
worker_count[0]=0

reset_success_counter
log_event "@RUN|profile|manual|$APP_PROFILE|1|$total_count|$start_time"
for app in $packages_file; do
  [ -n "$app" ] || continue
  compile_one 0 "$app" "$APP_PROFILE"
done

log_msg "$(t "¦ Профиль применён" "¦ The profile has been applied")"

execution_time=$(( $(date +%s) - start_time ))
log_msg "$(t "Время работы скрипта: $((execution_time / 60)) минут и $((execution_time % 60)) секунд" \
             "Script execution time: $((execution_time / 60)) minutes and $((execution_time % 60)) seconds.")"

log_event "@END|$execution_time|$total_count|$(count_success)"
write_stats "profile" "$execution_time" "$total_count" "$(count_success)"

finish