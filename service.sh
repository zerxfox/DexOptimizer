#!/system/bin/sh

start_time=$(date +%s)
# Функция проверки root-прав доступа
if [ "$(id -u)" -ne 0 ]; thenч
  echo "No Root Access" 1>&2
  exit 1
fi

# Функция установки разрешений на файлы и папки
chmod 755 /sdcard/documents/script_log.txt
chmod 755 /data/adb/modules/dex_optimizer
chmod 755 /data/adb/modules/dex_optimizer/service.sh

# Ожидание загрузки устройства
while [[ -z $(ls /sdcard) ]]
do
    sleep 1
done

# Функция инициализации лог-файла и логирование в реальном времени
LOG_FILE="/sdcard/documents/script_log.txt"
echo ">>> Starting compilation" > "$LOG_FILE"

# Основной выполнение скрипта
# Последовательно запускаем каждую команду компиляции в фоновом режиме

# Компилирание всех dex файлов без проверки профиля.
echo ">>> Compiling everything" | tee -a "$LOG_FILE"
(cmd package compile -a -m everything 2>&1 | tee -a "$LOG_FILE")

# Ожидание завершения всех фоновых процессов
wait

# Компилирование всех dex файлов с использованием профиля для оптимизации.
echo ">>> Compiling everything-profile" | tee -a "$LOG_FILE"
(cmd package compile -a -m everything-profile -f 2>&1 | tee -a "$LOG_FILE")

# Ожидание завершения всех фоновых процессов
wait

# Компилирование всех dex файлов (full: primary-dex и secondary-dex) (Fast режим).
echo ">>> Compiling ALL dex (FAST mode)" | tee -a "$LOG_FILE"
(cmd package compile -a -p PRIORITY_INTERACTIVE_FAST -f --full 2>&1 | tee -a "$LOG_FILE")

# Ожидание завершения всех фоновых процессов
wait

# Компилирование всех dex файлов (Максимизация скорости выполнения приложений с учетом профилирования).
echo ">>> Compiling speed-profile" | tee -a "$LOG_FILE"
(cmd package compile -a -m speed-profile -f 2>&1 | tee -a "$LOG_FILE")

# Ожидание завершения всех фоновых процессов
wait

# Функция очистки системных кэшей для оптимизации dex
echo ">>> Cleaning up" | tee -a "$LOG_FILE"
cmd package bg-dexopt-job 2>&1 | tee -a "$LOG_FILE"

# Вывод сообщения о завершении всех задач.
echo ">>> Done" | tee -a "$LOG_FILE"

end_time=$(date +%s)
execution_time=$((end_time - start_time))
minutes=$((execution_time / 60))
seconds=$((execution_time % 60))
# Функция уведомления об успешном завершении с более информативным сообщением
su -lp 2000 -c "cmd notification post -S bigtext -t 'Dex2Oat' 'Tag' 'Скрипт выполнился успешно за ${minutes} минут и ${seconds} секунд!'"
