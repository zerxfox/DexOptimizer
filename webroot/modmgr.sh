#!/system/bin/sh

MODMGR_TABLE='
KernelSU:ksud /data/adb/ksud /data/adb/ksu/bin/ksud:module install
APatch:apd /data/adb/apd /data/adb/ap/bin/apd:module install
Magisk:magisk /data/adb/magisk/magisk64 /data/adb/magisk/magisk32 /data/adb/magisk/magisk:--install-module
'

MODMGR_FOUND=""

find_module_managers() {
  local name bins args b bin
  MODMGR_FOUND=""

  case ":$PATH:" in
    *":/data/adb/ksu/bin:"*) ;;
    *) PATH="$PATH:/data/adb/ksu/bin:/data/adb/ap/bin:/data/adb/magisk" ;;
  esac

  while IFS=':' read -r name bins args; do
    [ -n "$name" ] || continue
    for b in $bins; do
      bin=""
      case "$b" in
        /*) [ -x "$b" ] && bin="$b" ;;
        *)  bin=$(command -v "$b" 2>/dev/null)
            case "$bin" in /*) ;; *) bin="" ;; esac ;;
      esac
      [ -n "$bin" ] || continue
      MODMGR_FOUND="${MODMGR_FOUND}${name}|${bin}|${args}
"
      break
    done
  done <<EOT
$MODMGR_TABLE
EOT

  [ -n "$MODMGR_FOUND" ]
}

modmgr_searched() {
  echo "$MODMGR_TABLE" | while IFS=':' read -r name bins args; do
    [ -n "$name" ] && echo "  $name -> $bins"
  done
  echo "  PATH=$PATH"
}

MODMGR_USED=""
install_module_zip() {
  local zip="$1" name bin args rc
  MODMGR_USED=""
  while IFS='|' read -r name bin args; do
    [ -n "$bin" ] || continue
    log_msg "$(t "Менеджер модулей: $name ($bin)" "Module manager: $name ($bin)")"
    "$bin" $args "$zip"
    rc=$?
    if [ "$rc" -eq 0 ]; then
      MODMGR_USED="$name"
      return 0
    fi
    log_msg "$(t "Ошибка установки через $name (код $rc)" "Installation via $name failed (code $rc)")"
  done <<EOT
$MODMGR_FOUND
EOT
  return 1
}
