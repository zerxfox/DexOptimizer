MODNAME="DexOptimizer"
DEVNAME="Magellan, ZerxFox, Гоша"
MODREQ="Android 9+ & Magisk 23+"
DEVLINK="@ZerxFox"
LINKPUB="t.me/mkamhub"

LANG=$(settings get system system_locales)
unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
. $TMPDIR/addon/Volume-Key-Selector/install.sh
if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
    ui_print " | 1: everything-profile: включает профилирование при компиляции" 
    ui_print " | всего приложения. Профиль выявляет узкие места в коде," 
    ui_print " | которые могут быть оптимизированы для улучшения производительности."
    ui_print " | "
    ui_print " | 2: speed-profile: сконцентрирован на оптимизации скорости выполнения кода."
    ui_print " | Может быть полезно, если ваша основная цель - максимально ускорить работу приложений."
    ui_print " | "
    ui_print " | Выберите профиль [vol+ изменить | vol- выбрать]"
else
    ui_print " | 1: everything-profile: enables profiling when compiling"
    ui_print " | the entire application. The profile identifies bottlenecks"
    ui_print " | in the code that can be optimized to improve performance."
    ui_print " | "
    ui_print " | 2: speed-profile: focused on optimizing code execution speed."
    ui_print " | May be useful if your main goal is to speed up your applications as much as possible"
    ui_print " | "
    ui_print " | Select profile [vol+ change | vol- select]"
fi

DVal=1
while true; do
	ui_print "  $DVal"
	"$VKSEL" && DVal="$((DVal + 1))" || break
	[[ "$DVal" -gt "2" ]] && DVal=1
done

case $DVal in
	1 ) echo "1" > "$MODPATH/settings.cfg";;
	2 ) echo "2" > "$MODPATH/settings.cfg";;
esac

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/service.sh 0 0 0777
}

if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
    ui_print " |"
    ui_print " | Выбрано: $DVal"
    ui_print " |"
    ui_print " | Модуль: $MODNAME"
    ui_print " |"
    ui_print " | Информационный блок"
    ui_print " |"
    ui_print " | Этот модуль повышает производительность,"
    ui_print " | экономит ресурсы и сокращает"
    ui_print " | время запуска приложений"
    ui_print " |"
    ui_print " | • Разработчик:       $DEVNAME"
    ui_print " | • Требования:        $MODREQ"
    ui_print " | • Telegram:          $DEVLINK"
    ui_print " |"
    ui_print " | Отдельная благодарность за помощь в тестировании"
    ui_print " |"
    ui_print " | TG-канал: $LINKPUB"
else
    ui_print " |"
    ui_print " | Selected: $DVal"
    ui_print " |"
    ui_print " | Module: $MODNAME"
    ui_print " |"
    ui_print " | Information block"
    ui_print " |"
    ui_print " | This module improves performance,"
    ui_print " | saves resources and reduces"
    ui_print " | application launch time"
    ui_print " |"
    ui_print " | • Developer:       $DEVNAME"
    ui_print " | • Requirements:    $MODREQ"
    ui_print " | • Telegram:        $DEVLINK"
    ui_print " |"
    ui_print " | Special thanks for help with testing"
    ui_print " |"
    ui_print " | TG-channel: $LINKPUB"
fi
ui_print ""
ui_print ""
