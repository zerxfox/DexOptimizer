#!/system/bin/sh

DEVICE_LOCALE=$(settings get system system_locales)
SDK_VERSION=$(getprop ro.build.version.sdk)
DIRMOD="/storage/emulated/0/DexOptimizer"
DIRMOD_LOGS="/data/adb/modules/dex_optimizer/webroot"
LOGFILE="${DIRMOD_LOGS}/script_logs.out"
LOG_FILE="${DIRMOD}/script_log.txt"
STATS_FILE="${DIRMOD_LOGS}/stats.txt"
CURRENT_VERSION="9.0.0"

SUCCESS_FILE="${DIRMOD_LOGS}/.run_success.$$"

OPRESTY_HOST="127.0.0.1"
OPRESTY_PORT="8080"

UPDATE_STATE_FILE="${DIRMOD_LOGS}/update_state"

is_russian() {
  [[ "$DEVICE_LOCALE" == *"en-RU"* ]] || [[ "$DEVICE_LOCALE" == *"ru-"* ]]
}

t() { is_russian && echo "$1" || echo "$2"; }

log_msg() { echo "$1" | tee -a "$LOGFILE" >> "$LOG_FILE"; }

log_done() { log_msg "[DONE]"; }

log_event() { printf '%s\n' "$*" >> "$LOGFILE"; }

RUN_LOCK="${DIRMOD_LOGS}/.run.lock"
BOOT_ID_FILE="/proc/sys/kernel/random/boot_id"

run_lock_alive() {
  local p b
  p=$(cat "$RUN_LOCK/pid" 2>/dev/null)
  if [ -z "$p" ]; then sleep 1; p=$(cat "$RUN_LOCK/pid" 2>/dev/null); fi
  [ -n "$p" ] || return 1
  b=$(cat "$RUN_LOCK/boot" 2>/dev/null)
  [ "$b" = "$(cat "$BOOT_ID_FILE" 2>/dev/null)" ] || return 1
  kill -0 "$p" 2>/dev/null
}

release_run() {
  [ "$(cat "$RUN_LOCK/pid" 2>/dev/null)" = "$$" ] && rm -rf "$RUN_LOCK"
  return 0
}

acquire_run() {
  local kind="$1" attempt=0
  while [ "$attempt" -lt 2 ]; do
    if mkdir "$RUN_LOCK" 2>/dev/null; then
      echo "$kind" > "$RUN_LOCK/kind"
      date +%s > "$RUN_LOCK/since"
      cat "$BOOT_ID_FILE" > "$RUN_LOCK/boot" 2>/dev/null
      echo "$$" > "$RUN_LOCK/pid"
      trap release_run EXIT
      trap 'kill $(jobs -p) 2>/dev/null; exit 143' HUP INT TERM
      return 0
    fi
    run_lock_alive && return 1
    rm -rf "$RUN_LOCK"
    attempt=$((attempt + 1))
  done
  return 1
}

begin_run() {
  mkdir -p "$DIRMOD"
  if ! acquire_run "$1"; then
    echo "BUSY"
    exit 3
  fi
  : > "$LOG_FILE"
  : > "$LOGFILE"
  log_event "@BEGIN|$(date +%s)|$$"
  : > "$RUN_LOCK/ready"
}

is_number() { case "$1" in ''|*[!0-9]*) return 1 ;; esac; }

clamp_parts() {
  local v="$1" def="${2:-4}"
  is_number "$v" || { echo "$def"; return; }
  [ "$v" -lt 1 ]  && { echo 1;  return; }
  [ "$v" -gt 25 ] && { echo 25; return; }
  echo "$v"
}

decode_app_list() {
  echo "$1" | sed -e 's/%2C/,/g' | tr ',' '\n'
}

list_packages() {
  pm list packages ${1:+"$1"} | cut -d':' -f2
}

get_package_size() {
  local pkg="$1" path size
  path=$(pm path "$pkg" 2>/dev/null | head -n1 | cut -d':' -f2)
  [ -z "$path" ] && { echo 0; return; }
  size=$(stat -c%s "$path" 2>/dev/null)
  echo "${size:-0}"
}

sort_by_size() {
  while read -r pkg; do
    [ -n "$pkg" ] || continue
    echo "$(get_package_size "$pkg") $pkg"
  done | sort -nr
}

count_lines() {
  [ -z "$1" ] && { echo 0; return; }
  echo "$1" | grep -c .
}

reset_success_counter() {
  local f pid
  for f in "${DIRMOD_LOGS}"/.run_success.*; do
    [ -e "$f" ] || continue
    pid=${f##*.}
    kill -0 "$pid" 2>/dev/null || rm -f "$f"
  done
  : > "$SUCCESS_FILE"
}

count_success() {
  [ -f "$SUCCESS_FILE" ] && wc -l < "$SUCCESS_FILE" | tr -d ' ' || echo 0
}

worker_count=()
worker_total=()
parts=()

partition_into() {
  local n="$1" sorted="$2" i=0 idx size pkg
  while [ $i -lt "$n" ]; do
    parts[$i]=""; worker_count[$i]=0; worker_total[$i]=0
    i=$((i + 1))
  done
  i=0
  while read -r size pkg; do
    [ -n "$pkg" ] || continue
    idx=$((i % n))
    parts[$idx]="${parts[$idx]} $pkg"
    worker_total[$idx]=$((worker_total[$idx] + 1))
    i=$((i + 1))
  done <<< "$sorted"
}

choose_profile() {
  local pkg="$1" bucket
  bucket=$(am get-standby-bucket "$pkg" 2>/dev/null | head -n 1 | tr -d '[:space:]')
  if is_number "$bucket" && [ "$bucket" -gt 10 ]; then
    echo "speed-profile"
  else
    echo "everything-profile"
  fi
}

elapsed_to_seconds() {
  local raw="${1%ms}" total=0 num
  while [ -n "$raw" ]; do
    num=${raw%%[!0-9]*}
    [ -n "$num" ] || break
    raw=${raw#"$num"}
    num=${num#"${num%%[!0]*}"}; num=${num:-0}
    case "$raw" in
      d*) total=$((total + num * 86400)); raw=${raw#d} ;;
      h*) total=$((total + num * 3600));  raw=${raw#h} ;;
      m*) total=$((total + num * 60));    raw=${raw#m} ;;
      s*) total=$((total + num));         raw=${raw#s} ;;
      *)  break ;;
    esac
  done
  echo "$total"
}

choose_profile_old() {
  local pkg="$1" raw total
  raw=$(dumpsys usagestats 2>/dev/null \
        | grep -F "package=$pkg " \
        | grep -o 'lastUsedElapsed=+[0-9a-z]*' \
        | head -n 1 \
        | sed 's/^lastUsedElapsed=+//')
  [ -z "$raw" ] && { echo "everything-profile"; return; }
  total=$(elapsed_to_seconds "$raw")
  [ "$total" -gt 600 ] && echo "speed-profile" || echo "everything-profile"
}

auto_profile() {
  if [ "$SDK_VERSION" -ge 23 ] && [ "$SDK_VERSION" -le 27 ]; then
    choose_profile_old "$1"
  else
    choose_profile "$1"
  fi
}

NL='
'

_log_result() {
  local count="$1" total="$2" app="$3" ok="$4" secs="$5" profile="$6" widx="$7"
  local status prof_ru="" prof_en=""
  if [ "$ok" = "1" ]; then status=$(t "Успех" "Success"); else status=$(t "Ошибка" "Failed"); fi
  [ -n "$profile" ] && { prof_ru="├─ Профиль: $profile$NL"; prof_en="├─ Profile: $profile$NL"; }
  t "┌─ Прогресс: $count | $total
├─ Приложение: $app
${prof_ru}├─ Статус: $status
├─ Время: $((secs / 60))m $((secs % 60))s
└─ Процесс: #$((widx + 1))" \
    "┌─ Progress: $count | $total
├─ App: $app
${prof_en}├─ Status: $status
├─ Time: $((secs / 60))m $((secs % 60))s
└─ Process: #$((widx + 1))" >> "$LOG_FILE"
  log_event "@APP|$widx|$count|$total|$app|$ok|$secs|$profile"
}

run_compile() {
  local profile="$1" app="$2"
  if ! is_number "$SDK_VERSION" || [ "$SDK_VERSION" -lt 23 ]; then
    echo "Unsupported SDK: $SDK_VERSION"
    return 1
  elif [ "$SDK_VERSION" -ge 34 ]; then
    cmd package compile -m "$profile" -p PRIORITY_INTERACTIVE_FAST -f --full "$app" 2>&1
  elif [ "$SDK_VERSION" -ge 29 ]; then
    cmd package compile -m "$profile" -f "$app" 2>&1
  else
    cmd package compile -m "$profile" --check-prof true -f "$app" 2>&1
  fi
}

compile_one() {
  local widx="$1" app="$2" profile="$3" output ok=0 t0 t1
  log_event "@START|$widx|$app"
  t0=$(date +%s)
  output=$(run_compile "$profile" "$app")
  t1=$(date +%s)

  if echo "$output" | grep -q "Success"; then
    ok=1
    echo 1 >> "$SUCCESS_FILE"
  fi

  worker_count[$widx]=$((worker_count[$widx] + 1))
  _log_result "${worker_count[$widx]}" "${worker_total[$widx]}" "$app" "$ok" "$((t1 - t0))" "$profile" "$widx"
}

reset_one() {
  local widx="$1" app="$2" output ok=0 t0 t1
  log_event "@START|$widx|$app"
  t0=$(date +%s)
  output=$(cmd package compile --reset "$app" 2>&1)
  t1=$(date +%s)

  if echo "$output" | grep -q "Success"; then
    ok=1
    echo 1 >> "$SUCCESS_FILE"
  fi

  worker_count[$widx]=$((worker_count[$widx] + 1))
  _log_result "${worker_count[$widx]}" "${worker_total[$widx]}" "$app" "$ok" "$((t1 - t0))" "" "$widx"
}

run_worker() {
  local widx="$1" kind="$2" profile="$3" pack
  for pack in ${parts[$widx]}; do
    if [ "$kind" = "compile" ]; then
      if [ "$profile" = "auto" ]; then
        compile_one "$widx" "$pack" "$(auto_profile "$pack")"
      else
        compile_one "$widx" "$pack" "$profile"
      fi
    else
      reset_one "$widx" "$pack"
    fi
  done
}

dispatch_parallel() {
  local kind="$1" n="$2" profile="${3:-}" i=0
  while [ $i -lt "$n" ]; do
    run_worker "$i" "$kind" "$profile" &
    i=$((i + 1))
  done
  wait
}

run_dexopt_job() {
  local t0 out ok=0 secs
  log_msg "$(t "¦ Выполнение задачи оптимизации DEX" "¦ Executing DEX Optimization Task")"
  t0=$(date +%s)
  log_event "@DEXOPT|start|$t0"
  out=$(cmd package bg-dexopt-job 2>&1)
  echo "$out" | grep -q "Job finished" && ok=1
  secs=$(( $(date +%s) - t0 ))
  log_event "@DEXOPT|end|$ok|$secs"
  if [ "$ok" = "1" ]; then
    log_msg "$(t "¦ Задача завершена ($((secs / 60))m $((secs % 60))s)" "¦ Task finished ($((secs / 60))m $((secs % 60))s)")"
  else
    log_msg "$(t "¦ Ошибка выполнения задачи" "¦ Task execution error")"
  fi
}

log_device_info() {
  log_msg "$(is_russian \
    && echo -e "Имя устройства: $(getprop ro.product.name)\nМодель устройства: $(getprop ro.product.system.model)\nВерсия модуля: $CURRENT_VERSION" \
    || echo -e "Device Name: $(getprop ro.product.name)\nSystem Model: $(getprop ro.product.system.model)\nModule version: $CURRENT_VERSION")"
}

write_stats() {
  echo "$(date +%s)|$1|$2|$3|${4:-0}" | tee -a "$STATS_FILE" >/dev/null
}

finish() {
  log_done
  rm -f "$SUCCESS_FILE" 2>/dev/null
  release_run
}

http_local() {
  printf '%s %s HTTP/1.0\r\nHost: %s\r\nContent-Length: 0\r\nConnection: close\r\n\r\n' \
    "$1" "$2" "$OPRESTY_HOST" \
    | nc -w 300 "$OPRESTY_HOST" "$OPRESTY_PORT" 2>/dev/null \
    | tr -d '\r' | sed '1,/^$/d'
}
