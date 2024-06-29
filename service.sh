#!/system/bin/sh

while [[ -z $(ls /sdcard) ]]
do
  sleep 1
done

LANG=$(settings get system system_locales)
SDK_VERSION=$(getprop ro.build.version.sdk)
start_time=$(date +%s)

if [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]; then
  su -lp 2000 -c "cmd notification post -S bigtext -t 'DexOptimizer' 'Tag' 'Скрипт выполняется...'"
else
  su -lp 2000 -c "cmd notification post -S bigtext -t 'DexOptimizer' 'Tag' 'The script running...'"
fi

DIRMOD="/storage/emulated/0/DexOptimizer"
su -c mkdir -p "${DIRMOD}"
LOG_FILE="${DIRMOD}/script_log.txt"
touch "$LOG_FILE"
echo ">>> The script running..." > "$LOG_FILE"
echo "$(getprop ro.product.name) | $(getprop ro.product.system.model)" | tee -a "$LOG_FILE"

MODDIR="/data/adb/modules/dex_optimizer"
PACKAGES=$(cat "${MODDIR}/packages.cfg")
if [ "$PACKAGES" -eq 1 ]; then
  packages_file=$(pm list packages -3 | awk '{sub("^package:", ""); print}')
elif [ "$PACKAGES" -eq 2 ]; then
  packages_file=$(pm list packages -s | awk '{sub("^package:", ""); print}')
elif [ "$PACKAGES" -eq 3 ]; then
  packages_file=$(pm list packages | awk '{sub("^package:", ""); print}')
fi
echo "$packages_file" | wc -l >> "$LOG_FILE"

compile_profile() {
  local profile="$1"
  local apps="$2"

  echo "App: $apps" >> "$LOG_FILE"
  if [ "$SDK_VERSION" -ge 23 ] && [ "$SDK_VERSION" -le 33 ]; then
    cmd package compile -m "$profile" -f "$apps" 2>&1 | tee -a "$LOG_FILE"
  elif [ "$SDK_VERSION" -ge 34 ] && [ "$SDK_VERSION" -le 35 ]; then
    cmd package compile -m "$profile" -p PRIORITY_INTERACTIVE_FAST -f --full "$apps" 2>&1 | tee -a "$LOG_FILE"
  fi
}

SETTINGS=$(cat "${MODDIR}/settings.cfg")
if [ "$SETTINGS" -eq 1 ]; then
  echo ">>> Compiling everything-profile" >> "$LOG_FILE"
  for pack in $packages_file; do
    compile_profile everything-profile "$pack"
  done
elif [ "$SETTINGS" -eq 2 ]; then
  echo ">>> Compiling speed-profile" >> "$LOG_FILE"
  for pack in $packages_file; do
    compile_profile speed-profile "$pack"
  done
else
  echo "Error: Invalid value in settings.cfg" | tee -a "$LOG_FILE" >&2
fi
wait

echo ">>> Cleaning up" | tee -a "$LOG_FILE"
cmd package bg-dexopt-job 2>&1 | tee -a "$LOG_FILE"
echo ">>> Done" | tee -a "$LOG_FILE"

end_time=$(date +%s)
execution_time=$((end_time - start_time))
minutes=$((execution_time / 60))
seconds=$((execution_time % 60))

if [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]; then
  total_time="Время работы: ${minutes} минут и ${seconds} секунд"
else
  total_time="Working time: ${minutes} minutes and ${seconds} seconds"
fi
echo "$total_time" | tee -a "$LOG_FILE"

if [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]; then
  su -lp 2000 -c "cmd notification post -S bigtext -t 'DexOptimizer' 'Tag' 'Скрипт выполнился успешно за ${minutes} минут и ${seconds} секунд!'"
else
  su -lp 2000 -c "cmd notification post -S bigtext -t 'DexOptimizer' 'Tag' 'The script ran successfully in ${minutes} minutes and ${seconds} seconds!'"
fi

# Removing yourself from Magisk modules
rm -rf "$MODDIR"
rm "$0"
