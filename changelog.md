v1.0.0
- Начальная инициализация.
- Добавлены команды оптимизации dex:
1. cmd package compile -a -f -m everything-profile: компилирует все dex файлы с использованием профиля для оптимизации.
2. cmd package compile -a -f --compile-layouts: компилирует dex файлы, включая компиляцию макетов (layouts).
3. cmd package compile -a -f --secondary-dex: компилирует дополнительные dex файлы (secondary dex).
4. cmd package compile -a -f --check-prof false -m everything: компилирует все dex файлы без проверки профиля.
5. cmd package compile -a -f --compile-new: компилирует только новые dex файлы.
6. cmd package bg-dexopt-job: очищает системные кэши для оптимизации dex.
- Добавлено логирование.

v2.0.0
- Добавлено обновления модуля через репозиторий GitHub.
- Добавлены команды оптимизации dex:
1. cmd package compile -a -f --optimize-profiles specific: оптимизирует dex файлы с использованием определенных профилей.
2. cmd package compile -a -f --optimize-devices specific: оптимизирует dex файлы для конкретных устройств.
3. cmd package compile -a -f --auto-resource-allocation: автоматически распределяет ресурсы для оптимизации.
4. cmd package manage-cache -a --optimize-cache: управляет кэшем приложения с оптимизацией кэша.
5. cmd package schedule-optimize -a -t 3:00am: планирует оптимизацию dex файлов на определенное время (3:00 утра).
6. cmd package monitor -a --report-results: мониторит и отчитывается о результатах оптимизации.