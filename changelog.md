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
- Изменены команды оптимизации dex.
- Добавлен таймер выполнения скрипта.
- Список команд оптимизации dex:
1. cmd package compile -a -m everything -f --check-prof false: компилирует все dex файлы для всех приложений, но без использования профиля
2. cmd package compile -a -m everything-profile -f: компилирует все dex файлы для всех приложений, используя профиль для оптимизации кода
3. cmd package compile -a -p PRIORITY_INTERACTIVE_FAST -f --full: компилирует все dex файлы для всех приложений в режиме 'Fast' с высоким приоритетом интерактивности
4. cmd package compile -a -m speed-profile -f: компилирует все dex файлы для всех приложений с использованием профиля для оптимизации скорости
