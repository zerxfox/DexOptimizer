#!/system/bin/sh

# Функция проверки root-прав доступа
if [ "$(id -u)" -ne 0 ]; then
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

# Компилирование всех dex файлов с использованием профиля для оптимизации.
echo ">>> Compiling everything-profile" | tee -a "$LOG_FILE"
(cmd package compile -a -f -m everything-profile 2>&1 | tee -a "$LOG_FILE") &

# Компилирование dex файлов, включая компиляцию макетов (layouts).
echo ">>> Compiling layouts" | tee -a "$LOG_FILE"
(cmd package compile -a -f --compile-layouts 2>&1 | tee -a "$LOG_FILE") &

# Компилирование дополнительных dex файлов (secondary dex).
echo ">>> Compiling secondary dex" | tee -a "$LOG_FILE"
(cmd package compile -a -f --secondary-dex 2>&1 | tee -a "$LOG_FILE") &

# Компилирание всех dex файлов без проверки профиля.
echo ">>> Compiling everything" | tee -a "$LOG_FILE"
(cmd package compile -a -f --check-prof false -m everything 2>&1 | tee -a "$LOG_FILE") &

# Компилирование только новых dex файлов.
echo ">>> Compiling new" | tee -a "$LOG_FILE"
(cmd package compile -a -f --compile-new 2>&1 | tee -a "$LOG_FILE") &

# Ожидание завершения всех фоновых процессов
wait

# Функция очистки системных кэшей для оптимизации dex
echo ">>> Cleaning up" | tee -a "$LOG_FILE"
cmd package bg-dexopt-job 2>&1 | tee -a "$LOG_FILE"

# Дополнительные функции оптимизации dex
# Оптимизация dex файлов с использованием определенных профилей.
echo ">>> Optimizing by specific profiles" | tee -a "$LOG_FILE"
(cmd package compile -a -f --optimize-profiles specific 2>&1 | tee -a "$LOG_FILE") &

# Оптимизация dex файлов для конкретных устройств.
echo ">>> Optimizing for specific devices" | tee -a "$LOG_FILE"
(cmd package compile -a -f --optimize-devices specific 2>&1 | tee -a "$LOG_FILE") &

# Автоматическое распределение ресурсов для оптимизации.
echo ">>> Automatic resource allocation" | tee -a "$LOG_FILE"
(cmd package compile -a -f --auto-resource-allocation 2>&1 | tee -a "$LOG_FILE") &

# Управление кэшем приложения с оптимизацией кэша.
echo ">>> Managing application cache" | tee -a "$LOG_FILE"
(cmd package manage-cache -a --optimize-cache 2>&1 | tee -a "$LOG_FILE") &

# Планирование оптимизации dex файлов на определенное время (3:00 утра).
echo ">>> Scheduling optimization" | tee -a "$LOG_FILE"
(cmd package schedule-optimize -a -t 3:00am 2>&1 | tee -a "$LOG_FILE") &

# Ожидание завершения всех фоновых процессов
wait

# Мониторинг и отчёт о результатах оптимизации.
echo ">>> Monitoring and reporting" | tee -a "$LOG_FILE"
(cmd package monitor -a --report-results 2>&1 | tee -a "$LOG_FILE")

# Вывод сообщения о завершении всех задач.
echo ">>> Done" | tee -a "$LOG_FILE"

# Функция уведомления об успешном завершении с более информативным сообщением
su -lp 2000 -c "cmd notification post -S bigtext -t 'Dex2Oat' 'Tag' 'Скрипт выполнился успешно!'"