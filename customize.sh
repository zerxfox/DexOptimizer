MODNAME="DexOptimizer"
DEVNAME="Magellan, ZerxFox, Гоша"
MODREQ="Android 9+ & Magisk 23+"
DEVLINK="@ZerxFox"
LINKPUB="t.me/mkamhub"
LANG=$(settings get system system_locales)

if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
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
ui_print " |"
ui_print " |"

unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
. $TMPDIR/addon/Volume-Key-Selector/install.sh

if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
    ui_print " | 1: everything-profile:выявляет узкие места в коде," 
    ui_print " | которые могут быть оптимизированы для улучшения"
    ui_print " | производительности."
    ui_print " |"
    ui_print " | 2: speed-profile: оптимизирует скорость выполнения"
    ui_print " | работы приложений, улучшает отклик интерфейса."
    ui_print " |"
    ui_print " | Выберите профиль [vol+ изменить | vol- выбрать]"
else
    ui_print " | 1: everything-profile: identifies bottlenecks in the"
    ui_print " | code, which can be optimized to improve performance."
    ui_print " |"
    ui_print " | 2: speed-profile: optimizes the execution speed of"
    ui_print " | applications, enhances interface responsiveness."
    ui_print " |"
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

ui_print " |"
if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
    ui_print " | Выбрано: $DVal"
else
    ui_print " | Selected: $DVal"
fi

ui_print " |"
if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
    ui_print " | 1: Пользовательские приложения" 
    ui_print " |"
    ui_print " | 2: Системные приложения"
    ui_print " |"
    ui_print " | 3: Все приложения"
    ui_print " |"
    ui_print " | Выберите приложения [vol+ изменить | vol- выбрать]"
else
    ui_print " | 1: User apps"
    ui_print " |"
    ui_print " | 2: System apps"
    ui_print " |"
    ui_print " | 3: All apps"
    ui_print " |"
    ui_print " | Select apps [vol+ change | vol- select]"
fi

DVal=1
while true; do
	ui_print "  $DVal"
	"$VKSEL" && DVal="$((DVal + 1))" || break
	[[ "$DVal" -gt "3" ]] && DVal=1
done

case $DVal in
	1 ) echo "1" > "$MODPATH/packages.cfg";;
	2 ) echo "2" > "$MODPATH/packages.cfg";;
    3 ) echo "3" > "$MODPATH/packages.cfg";;
esac

ui_print " |"
if [[ "$LANG" =~ "en-RU" ]] || [[ "$LANG" =~ "ru-" ]]; then
    ui_print " | Выбрано: $DVal"
else
    ui_print " | Selected: $DVal"
fi

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/service.sh 0 0 0777
}
