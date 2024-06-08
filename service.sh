#!/system/bin/sh

sleep 10
LANG=$(settings get system system_locales)
start_time=$(date +%s)

# Ожидание загрузки устройства | Waiting for the device to boot
while [[ -z $(ls /sdcard) ]]
do
  sleep 1
done

# Функция проверки root-прав доступа | Root check function
if [ "$(id -u)" -ne 0 ]; then
  echo "No Root Access" 1>&2
  exit 1
fi

# Функция установки разрешений на файлы и папки | Function for setting permissions on files and folders
su -c mkdir /storage/emulated/0/DexOptimizer
touch /storage/emulated/0/DexOptimizer/script_log.txt
touch /storage/emulated/0/DexOptimizer/log_speedprofile.txt
touch /storage/emulated/0/DexOptimizer/log_profile.txt

# Выбор параметра компилирования | Selecting a Compile Option
SETTINGS=$(cat /data/adb/modules/dex_optimizer/settings.cfg)
# Функция инициализации лог-файла и логирование в реальном времени | Log file initialization function and real-time logging
LOG_FILE="/storage/emulated/0/DexOptimizer/script_log.txt"
LOG_FILE_FM="/storage/emulated/0/DexOptimizer/log_speedprofile.txt"
LOG_FILE_P="/storage/emulated/0/DexOptimizer/log_profile.txt"
echo ">>> Starting compilation" > "$LOG_FILE"

# Компилирование всех dex файлов (full: primary-dex и secondary-dex) (Fast режим) | Compiling all dex files (full: primary-dex and secondary-dex) (Fast mode).
echo ">>> Compiling ALL dex (FAST mode)" | tee -a "$LOG_FILE"
(cmd package compile -a -p PRIORITY_INTERACTIVE_FAST -f --full 2>&1 | tee -a "$LOG_FILE_FM") &

if [ "$SETTINGS" -eq 1 ]; then
# Компилирование всех dex файлов с использованием профиля для оптимизации | Compiling all dex files using profile for optimization
  echo ">>> Compiling everything-profile" | tee -a "$LOG_FILE"
  (cmd package compile -a -m everything-profile -f 2>&1 | tee -a "$LOG_FILE_P") &
elif [ "$SETTINGS" -eq 2 ]; then
# Компилирование всех dex файлов (Максимизация скорости выполнения приложений с учетом профилирования) | Compiling all dex files (Maximizing application execution speed with profiling in mind)
  echo ">>> Compiling speed-profile" | tee -a "$LOG_FILE"
  (cmd package compile -a -m speed-profile -f 2>&1 | tee -a "$LOG_FILE_P") &
else
# Обработка недопустимых значений | Handling invalid values
  echo "Error: Invalid value" | tee -a "$LOG_FILE" >&2
fi

# Ожидание завершения всех фоновых процессов | Waiting for all background processes to complete
wait

# Функция очистки системных кэшей для оптимизации dex | Function to clear system caches for dex optimization
echo ">>> Cleaning up" | tee -a "$LOG_FILE"
cmd package bg-dexopt-job 2>&1 | tee -a "$LOG_FILE"

# Вывод сообщения о завершении всех задач | Display a message about the completion of all tasks
echo ">>> Done" | tee -a "$LOG_FILE"

end_time=$(date +%s)
execution_time=$((end_time - start_time))
minutes=$((execution_time / 60))
seconds=$((execution_time % 60))

if [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]; then
  total_time="Время работы: ${minutes} минут и ${seconds} секунд"
else
  total_time="Working hours: ${minutes} minutes and ${seconds} seconds"
fi

echo "$(getprop ro.product.name) | $(getprop ro.product.system.model)" | tee -a "$LOG_FILE"
pm list packages | wc -l >> "$LOG_FILE"
echo "$total_time" | tee -a "$LOG_FILE"

# Функция уведомления об успешном завершении с более информативным сообщением | Success notification function with more informative message
if [[ "$LANG" == *"en-RU"* ]] || [[ "$LANG" == *"ru-"* ]]; then
  su -lp 2000 -c "cmd notification post -S bigtext -t 'DexOptimizer' 'Tag' 'Скрипт выполнился успешно за ${minutes} минут и ${seconds} секунд!'"
else
  su -lp 2000 -c "cmd notification post -S bigtext -t 'DexOptimizer' 'Tag' 'The script ran successfully in ${minutes} minutes and ${seconds} seconds!'"
fi

#Удаление самого себя из модулей Magisk | Removing yourself from Magisk modules
# rm /data/adb/modules/dex_optimizer/service.sh
# rm -rf /data/adb/modules/dex_optimizer
# rm "$0"
