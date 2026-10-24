const translations = {
  ru: {
    noData:             'Нет данных',
    never:              'Никогда',
    lessThanMinuteAgo:  'Только что',
    daysAgo:            '{days} дн назад',
    hoursAgo:           '{hours} ч назад',
    minutesAgo:         '{minutes} мин назад',
    lastRunTimeLabel:   'Последний запуск:',
    errorRequest:       'Ошибка запроса:',
    copyLabel:          'Скопировано!',
    updateMsg:          'Обновление модуля...',
    updateMsgError:     'Ошибка обновления',
    updateNone:         'Обновлений нет',
    updateDialogTitle:  'Установить обновление?',
    updateDialogText:   'Версия {version} загружена и готова к установке.',
    updateYes:          'Да',
    updateNo:           'Нет',
    updateOk:           'ОК',
    updateInstalling:   'Установка...',
    updateDoneTitle:    'Модуль обновлён',
    updateDoneText:     'Версия {version} установлена. Перезагрузите устройство, чтобы изменения вступили в силу.',
    updateErr_nonet:    'Нет интернета или сервер недоступен',
    updateErr_download: 'Не удалось скачать обновление',
    updateErr_empty:    'Файл обновления повреждён',
    updateErr_nozip:    'Файл обновления не найден',
    updateErr_nomanager:'Менеджер модулей не определён',
    updateErr_install:  'Ошибка установки',
    updateErr_timeout:  'Превышено время ожидания',
    logApps:            '{done} из {total} приложений',
    logProfile:         'Профиль: {profile}',
    logProfileAuto:     'авто',
    logProcesses:       'Процессов: {n}',
    logElapsed:         'Прошло: {time}',
    logDexRunning:      'Оптимизация DEX: выполняется… {time}',
    logDexOk:           'Оптимизация DEX: завершена ({time})',
    logDexFail:         'Оптимизация DEX: ошибка ({time})',
    logDexStopped:      'Оптимизация DEX: прервана',
    logLanes:           'Процессы',
    logAll:             'Все',
    logFail:            'Ошибки',
    logOk:              'Успешно',
    logInterrupted:     'Запуск прерван',
    logNoRuns:          'Запусков пока не было',
    logStOk:            'Успех',
    logStFail:          'Ошибка',
    logLaneDone:        'готово',
    logLaneIdle:        'ожидание',
    logEmpty:           'Нет приложений в этой категории',
    unitM:              'м',
    unitS:              'с',
    navHome:     'Главная',
    navDonate:   'Донат',
    navSettings: 'Настройки',
    compileTitle:  'Компиляция',
    cleanTitle:    'Очистка',
    profileTitle:  'Профиль приложения',
    statsTitle:    'Статистика',
    donateTitle:   'Поддержка',
    settingsTitle: 'Настройки',
    modeLabel:    'Режим',
    modeAuto:     'Авто',
    modeManual:   'Ручной',
    appsLabel:    'Приложения',
    appsUser:     'Польз.',
    appsSystem:   'Системн.',
    appsAll:      'Все',
    appsSelective:'Выборочно',
    profileDexLabel: 'Профиль DEX',
    extraLabel:   'Дополнительно',
    processesLabel: 'Процессы',
    dexOptLabel:  'Оптимизация DEX',
    startCompile: '⚡ Начать компиляцию',
    startClean:   '🗑 Начать очистку',
    startProfile: '🗳 Применить профиль',
    selectApp:    '🗳 Выберите приложение',
    searchPlaceholderClean:   'Введите название',
    searchPlaceholderProfile: 'Найти приложение',
    appLabel:     'Приложение',
    searchLabel:  'Поиск приложения',
    sOptimized: 'Оптимизировано',
    sRuns:      'Запусков',
    sSpeed:     'Прирост скорости',
    sLast:      'Последний запуск',
    progressLabel: 'Прогресс последнего запуска',
    chartTitle: 'Скорость компиляции · последние запуски',
    tileProfile: 'Профиль',
    copyWalletAria: 'Скопировать адрес TG Wallet',
    themeLabel:    'Тема',
    langLabel:     'Язык',
    langValue:     'Русский',
    defaultsLabel: 'Дефолты компиляции',
    defMode:       'Режим',
    defProfile:    'Профиль',
    defProc:       'Число процессов',
    donateHeroTitle: 'Поддержать ZerxFox',
    donateHeroSub:   'Если модуль помогает — поддержи разработку. Спасибо!',
    walletLabel:     'TG Wallet адрес',
    yoomoneyLabel:   'Перевести на ЮMoney',
    updateBtn:       'Обновить',
    updating:        '...',
    statsCleared:    'Статистика очищена',
    statsClearError: 'Ошибка очистки',
    confirmClear:    'Точно очистить?',
    searching:       'Поиск…',
    noResults:       'Не найдено',
    searchError:     'Ошибка поиска',
    processError:    'Ошибка запуска процесса',
    timedOut:        'Процесс не отвечает — остановлено',
    consoleTitle:    'Консоль',
    processStarted:  'Запуск: {name}',
    processBusy:     'Уже выполняется другой процесс — дождитесь его завершения',
  },
  en: {
    noData:             'No data',
    never:              'Never',
    lessThanMinuteAgo:  'Just now',
    daysAgo:            '{days}d ago',
    hoursAgo:           '{hours}h ago',
    minutesAgo:         '{minutes}m ago',
    lastRunTimeLabel:   'Last run:',
    errorRequest:       'Request error:',
    copyLabel:          'Copied!',
    updateMsg:          'Module update...',
    updateMsgError:     'Update error',
    updateNone:         'No updates available',
    updateDialogTitle:  'Install the update?',
    updateDialogText:   'Version {version} has been downloaded and is ready to install.',
    updateYes:          'Yes',
    updateNo:           'No',
    updateOk:           'OK',
    updateInstalling:   'Installing...',
    updateDoneTitle:    'Module updated',
    updateDoneText:     'Version {version} is installed. Reboot your device to apply the changes.',
    updateErr_nonet:    'No internet or server unavailable',
    updateErr_download: 'Failed to download the update',
    updateErr_empty:    'Update file is corrupted',
    updateErr_nozip:    'Update file not found',
    updateErr_nomanager:'Module manager not detected',
    updateErr_install:  'Installation failed',
    updateErr_timeout:  'Timed out',
    logApps:            '{done} of {total} apps',
    logProfile:         'Profile: {profile}',
    logProfileAuto:     'auto',
    logProcesses:       'Processes: {n}',
    logElapsed:         'Elapsed: {time}',
    logDexRunning:      'DEX optimization: running… {time}',
    logDexOk:           'DEX optimization: finished ({time})',
    logDexFail:         'DEX optimization: failed ({time})',
    logDexStopped:      'DEX optimization: interrupted',
    logLanes:           'Processes',
    logAll:             'All',
    logFail:            'Errors',
    logOk:              'Success',
    logInterrupted:     'Run interrupted',
    logNoRuns:          'No runs yet',
    logStOk:            'Success',
    logStFail:          'Failed',
    logLaneDone:        'done',
    logLaneIdle:        'waiting',
    logEmpty:           'No apps in this category',
    unitM:              'm',
    unitS:              's',
    navHome:     'Home',
    navDonate:   'Donate',
    navSettings: 'Settings',
    compileTitle:  'Compilation',
    cleanTitle:    'Cleaning',
    profileTitle:  'App Profile',
    statsTitle:    'Statistics',
    donateTitle:   'Support',
    settingsTitle: 'Settings',
    modeLabel:    'Mode',
    modeAuto:     'Auto',
    modeManual:   'Manual',
    appsLabel:    'Applications',
    appsUser:     'User',
    appsSystem:   'System',
    appsAll:      'All',
    appsSelective:'Selective',
    profileDexLabel: 'DEX Profile',
    extraLabel:   'Additional',
    processesLabel: 'Processes',
    dexOptLabel:  'DEX optimization',
    startCompile: '⚡ Start compilation',
    startClean:   '🗑 Start cleaning',
    startProfile: '🗳 Apply profile',
    selectApp:    '🗳 Select an app',
    searchPlaceholderClean:   'Enter name',
    searchPlaceholderProfile: 'Find app',
    appLabel:     'Application',
    searchLabel:  'Search app',
    sOptimized: 'Optimized',
    sRuns:      'Runs',
    sSpeed:     'Speed gain',
    sLast:      'Last run',
    progressLabel: 'Last run progress',
    chartTitle: 'Compilation speed · recent runs',
    tileProfile: 'Profile',
    copyWalletAria: 'Copy TG Wallet address',
    themeLabel:    'Theme',
    langLabel:     'Language',
    langValue:     'English',
    defaultsLabel: 'Compilation defaults',
    defMode:       'Mode',
    defProfile:    'Profile',
    defProc:       'Process count',
    donateHeroTitle: 'Support ZerxFox',
    donateHeroSub:   'If the module helps — support development. Thanks!',
    walletLabel:     'TG Wallet address',
    yoomoneyLabel:   'Transfer to YooMoney',
    updateBtn:       'Update',
    updating:        '...',
    statsCleared:    'Statistics cleared',
    statsClearError: 'Clear failed',
    confirmClear:    'Confirm clear?',
    searching:       'Searching…',
    noResults:       'Not found',
    searchError:     'Search error',
    processError:    'Failed to start process',
    timedOut:        'Process is not responding — stopped',
    consoleTitle:    'Console',
    processStarted:  'Starting: {name}',
    processBusy:     'Another process is already running — please wait for it to finish',
  },
};

const LANG_STORAGE_KEY = 'lang';

function getLang() {
  const saved = localStorage.getItem(LANG_STORAGE_KEY);
  if (saved === 'ru' || saved === 'en') return saved;
  return navigator.language?.startsWith('ru') ? 'ru' : 'en';
}

function setLang(lang) {
  localStorage.setItem(LANG_STORAGE_KEY, lang);
  applyTranslations();
  if (document.getElementById('statsChart')) loadAndDrawStats();
}

function t(key, params = {}) {
  const lang = getLang();
  let str = translations[lang][key] ?? translations['en'][key] ?? key;
  for (const k in params) str = str.replace(`{${k}}`, params[k]);
  return str;
}

function applyTranslations() {
  const set = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
  const setPlaceholder = (id, val) => { const el = document.getElementById(id); if (el) el.placeholder = val; };

  set('nav-home',     t('navHome'));
  set('nav-donate',   t('navDonate'));
  set('nav-settings', t('navSettings'));

  set('compile-title',      t('compileTitle'));
  set('clean-title',        t('cleanTitle'));
  set('profile-title',      t('profileTitle'));
  set('stats-title',        t('statsTitle'));
  set('console-title',      t('consoleTitle'));

  set('tile-compile-name',  t('compileTitle'));
  set('tile-clean-name',    t('cleanTitle'));
  set('tile-profile-name',  t('tileProfile'));
  set('tile-stats-name',    t('statsTitle'));
  set('donate-title',       t('donateTitle'));
  set('settings-title',     t('settingsTitle'));

  set('compile-mode-label',    t('modeLabel'));
  set('mode-auto-label',       t('modeAuto'));
  set('mode-manual-label',     t('modeManual'));
  set('compile-apps-label',    t('appsLabel'));
  set('apps-user-label',       t('appsUser'));
  set('apps-system-label',     t('appsSystem'));
  set('apps-all-label',        t('appsAll'));
  set('compile-profile-label', t('profileDexLabel'));
  set('compile-extra-label',   t('extraLabel'));
  set('compile-proc-label',    t('processesLabel'));
  set('compile-dex-label',     t('dexOptLabel'));
  set('compile-start-btn',     t('startCompile'));

  set('clean-apps-label',      t('appsLabel'));
  set('clean-user-label',      t('appsUser'));
  set('clean-system-label',    t('appsSystem'));
  set('clean-all-label',       t('appsAll'));
  set('clean-selective-label', t('appsSelective'));
  set('clean-proc-label',      t('processesLabel'));
  set('clean-search-label',    t('searchLabel'));
  set('clean-start-btn',       t('startClean'));
  setPlaceholder('app-name-clean', t('searchPlaceholderClean'));

  set('profile-dex-label',  t('profileDexLabel'));
  set('profile-app-label',  t('appLabel'));
  set('profile-start-btn',  t('selectApp'));
  setPlaceholder('app-name-profile', t('searchPlaceholderProfile'));

  set('s-optimized-l', t('sOptimized'));
  set('s-runs-l',      t('sRuns'));
  set('s-speed-l',     t('sSpeed'));
  set('s-last-l',      t('sLast'));

  set('stat-optimized-label', t('sOptimized'));
  set('stat-lastrun-label',   t('sLast'));
  set('stat-prog-name',       t('progressLabel'));
  set('chart-title',   t('chartTitle'));

  set('settings-theme-label',  t('themeLabel'));
  set('settings-lang-label',   t('langLabel'));
  set('settings-lang-value',   t('langValue'));
  set('settings-defaults-label', t('defaultsLabel'));
  set('def-mode-label',    t('defMode'));
  set('def-apps-label',    t('appsLabel'));
  set('def-apps-value',    t('appsAll'));
  set('def-mode-value',    t('modeAuto'));
  set('def-profile-label', t('defProfile'));
  set('def-proc-label',    t('defProc'));
  set('def-dex-label',    t('dexOptLabel'));

  set('donate-hero-title', t('donateHeroTitle'));
  set('donate-hero-sub',   t('donateHeroSub'));
  set('yoomoney-label',    t('yoomoneyLabel'));

  set('update-btn', t('updateBtn'));
  document.documentElement.lang = getLang();
}

function initLangSwitcher() {
  document.getElementById('lang-row')?.addEventListener('click', () => {
    setLang(getLang() === 'ru' ? 'en' : 'ru');
  });
}

let curMain = 0;

const mainInner  = () => document.getElementById('main-inner');
const subInner   = () => document.getElementById('sub-inner');
const subLayer   = () => document.getElementById('sub-layer');
const fnavWrap   = () => document.getElementById('fnav-wrap');
const navItems   = () => document.querySelectorAll('.nav-item');

function goMain(i) {
  curMain = i;
  mainInner().style.transform = `translateX(-${i * 100}%)`;
  navItems().forEach((n, idx) => n.classList.toggle('active', idx === i));
  replayPageAnimation(getMainPageScroll(i));
}

function getMainPageScroll(i) {
  const pages = document.querySelectorAll('#main-inner .main-page');
  return pages[i]?.querySelector('.page-scroll') ?? null;
}

function openSub(i) {
  const si = subInner();
  si.style.transition = 'none';
  si.style.transform  = `translateX(-${i * 100}%)`;
  si.offsetHeight;
  si.style.transition = '';

  subLayer().classList.add('open');
  fnavWrap().classList.add('hidden');

  replayPageAnimation(getSubPageScroll(i));
}

function getSubPageScroll(i) {
  const pages = document.querySelectorAll('#sub-inner .sub-page');
  return pages[i]?.querySelector('.page-scroll') ?? null;
}

function replayPageAnimation(scrollEl) {
  if (!scrollEl) return;
  const children = scrollEl.children;
  for (const child of children) {
    child.style.animation = 'none';
    void child.offsetWidth;
    child.style.animation = '';
  }
}

function closeSub() {
  subLayer().classList.remove('open');
  fnavWrap().classList.remove('hidden');
  resetSearchFields();
}

function resetSearchFields() {
  cleanSelected.clear();
  ['app-name-clean', 'app-name-profile'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = '';
  });
  ['results-clean', 'results-profile'].forEach(id => {
    const el = document.getElementById(id);
    if (el) { el.innerHTML = ''; el.classList.remove('visible'); }
  });
  const sel = document.getElementById('selected-app');
  if (sel) sel.style.display = 'none';
  const btn = document.getElementById('profile-start-btn');
  if (btn) {
    btn.classList.add('disabled');
    btn.textContent = t('selectApp');
  }
}

function initToggleGroup(groupId, onSelect) {
  const group = document.getElementById(groupId);
  if (!group) return;
  group.querySelectorAll('.bcard').forEach(card => {
    card.addEventListener('click', () => {
      group.querySelectorAll('.bcard').forEach(c => c.classList.remove('active'));
      card.classList.add('active');
      if (onSelect) onSelect(card.dataset.value ?? card.dataset.mode, card);
    });
  });
}

function initCompilePage() {
  const manualFields = document.getElementById('manual-fields');

  initToggleGroup('mode-group', (mode) => {
    if (mode === 'manual') {
      manualFields.classList.remove('disabled');
      initKeyboardAccessibility();
    } else {
      manualFields.classList.add('disabled');
    }
  });

  initToggleGroup('compile-apps-group');
  initToggleGroup('compile-profile-group');

  initStepper('compile-proc-minus', 'compile-proc-plus', 'compile-proc-value', 1, 16);

  document.getElementById('dex-switch')?.addEventListener('click', function() {
    const isOn = this.classList.toggle('on');
    this.setAttribute('aria-checked', String(isOn));
  });

  document.getElementById('compile-start-btn')?.addEventListener('click', () => {
    startProcess('compile');
  });
}

function initCleanPage() {
  const searchSection = document.getElementById('clean-search-section');

  initToggleGroup('clean-apps-group', (value) => {
    if (value === 'selectively') {
      searchSection.style.display = 'flex';
    } else {
      searchSection.style.display = 'none';
    }
  });

  initStepper('clean-proc-minus', 'clean-proc-plus', 'clean-proc-value', 1, 16);

  document.getElementById('app-name-clean')?.addEventListener('input', function() {
    handleSearchInput(this.value, 'results-clean', 'clean');
  });

  document.getElementById('clean-start-btn')?.addEventListener('click', () => {
    startProcess('clean');
  });
}

function initProfilePage() {
  initToggleGroup('profile-dex-group');

  document.getElementById('app-name-profile')?.addEventListener('input', function() {
    handleSearchInput(this.value, 'results-profile', 'profile');
  });

  document.getElementById('clear-selected-app')?.addEventListener('click', () => {
    document.getElementById('selected-app').style.display = 'none';
    document.querySelectorAll('#results-profile .result-check').forEach(c => c.classList.remove('checked'));
    const btn = document.getElementById('profile-start-btn');
    btn.classList.add('disabled');
    btn.textContent = t('selectApp');
  });

  document.getElementById('profile-start-btn')?.addEventListener('click', () => {
    if (!document.getElementById('profile-start-btn').classList.contains('disabled')) {
      startProcess('profile');
    }
  });
}

const searchState = {};
const RESULT_LABEL_LIMIT = 30;
let resultLabelBudget = 0;
const cleanSelected = new Set();

function debounceSearch(resultsId, fn, delay = 300) {
  const state = (searchState[resultsId] ??= {});
  clearTimeout(state.timer);
  state.timer = setTimeout(fn, delay);
}

function renderEmptyState(container, text) {
  container.innerHTML = `<div class="result-item result-empty"><div class="result-info"><div class="result-name">${text}</div></div></div>`;
}

function renderCleanSelected(container) {
  container.innerHTML = '';
  container.classList.add('visible');
  resultLabelBudget = 0;
  cleanSelected.forEach(app => container.appendChild(createResultItem(app, 'clean')));
}

function handleSearchInput(query, resultsId, type) {
  const container = document.getElementById(resultsId);
  if (!container) return;
  const state = (searchState[resultsId] ??= {});

  if (!query.trim()) {
    state.controller?.abort();
    clearTimeout(state.timer);
    state.sig = null;
    if (type === 'clean' && cleanSelected.size > 0) {
      renderCleanSelected(container);
    } else {
      container.innerHTML = '';
      container.classList.remove('visible');
    }
    return;
  }

  container.classList.add('visible');

  if (appsIndex.length > 0) {
    state.controller?.abort();
    clearTimeout(state.timer);
    state.token = (state.token ?? 0) + 1;
    const found = localSearch(query);
    const sig = type + '|' + found.map(a => a.pkg + '\t' + a.label).join('\n');
    if (state.sig === sig && container.childElementCount) return;
    state.sig = sig;
    container.innerHTML = '';
    if (!found.length) { renderEmptyState(container, t('noResults')); return; }
    resultLabelBudget = 0;
    found.forEach(a => container.appendChild(createResultItem(a.pkg, type)));
    return;
  }

  state.sig = null;
  renderEmptyState(container, t('searching'));

  debounceSearch(resultsId, async () => {
    state.controller?.abort();
    const controller = new AbortController();
    state.controller = controller;
    state.token = (state.token ?? 0) + 1;
    const token = state.token;

    try {
      const r = await fetch('/dex_optimizer/search_apps?app_name=' + encodeURIComponent(query), { signal: controller.signal });
      const text = await r.text();
      if (state.token !== token) return;

      const apps = text.split('\n').filter(a => a.trim());
      container.innerHTML = '';
      if (apps.length === 0) {
        renderEmptyState(container, t('noResults'));
        return;
      }
      resultLabelBudget = 0;
      apps.forEach(app => container.appendChild(createResultItem(app, type)));
    } catch (e) {
      if (e.name === 'AbortError') return;
      if (state.token !== token) return;
      renderEmptyState(container, t('searchError'));
    }
  });
}

const labelCache   = new Map();
const labelWaiters = new Map();
const labelQueue   = new Set();
let labelTimer = null;

const labelOf = (pkg) => labelCache.get(pkg) || pkg;

function requestLabel(pkg) {
  if (!pkg) return Promise.resolve(null);
  if (labelCache.has(pkg)) return Promise.resolve(labelCache.get(pkg));
  const p = new Promise(res => {
    if (!labelWaiters.has(pkg)) labelWaiters.set(pkg, []);
    labelWaiters.get(pkg).push(res);
  });
  labelQueue.add(pkg);
  if (!labelTimer) labelTimer = setTimeout(flushLabels, 120);
  return p;
}

async function flushLabels() {
  labelTimer = null;
  const batch = [...labelQueue].slice(0, 40);
  batch.forEach(p => labelQueue.delete(p));
  if (labelQueue.size) labelTimer = setTimeout(flushLabels, 0);

  let map = null;
  try {
    const r = await fetch('/dex_optimizer/labels?pkgs=' + encodeURIComponent(batch.join(',')), { cache: 'no-store' });
    if (r.ok) map = await r.json();
  } catch {}

  batch.forEach(pkg => {
    const v = map && typeof map[pkg] === 'string' && map[pkg] ? map[pkg] : null;
    if (map) labelCache.set(pkg, v);
    (labelWaiters.get(pkg) || []).forEach(res => res(v));
    labelWaiters.delete(pkg);
  });
}

const SEARCH_LIMIT = 150;
let appsIndex = [];
let appsIndexSyncing = false;
let appsIndexTimer = null;

async function loadAppsIndex(force = false) {
  clearTimeout(appsIndexTimer);
  try {
    const r = await fetch('/dex_optimizer/apps_index' + (force ? '?force=1' : ''), { cache: 'no-store' });
    if (!r.ok) return;
    const d = await r.json();
    if (!Array.isArray(d.apps)) return;
    appsIndexSyncing = !!d.syncing;
    appsIndex = d.apps.map(([pkg, label]) => ({
      pkg, label, pk: pkg.toLowerCase(), lb: (label || '').toLowerCase(),
    }));
    d.apps.forEach(([pkg, label]) => {
      if (label) labelCache.set(pkg, label);
      else if (!appsIndexSyncing && !labelCache.get(pkg)) labelCache.set(pkg, null);
    });
    rerunSearches();
    if (appsIndexSyncing) appsIndexTimer = setTimeout(loadAppsIndex, 2500);
  } catch {}
}

function localSearch(query) {
  const q = query.trim().toLowerCase();
  const rank = a => a.lb.startsWith(q) ? 0 : a.lb.includes(q) ? 1 : 2;
  return appsIndex
    .filter(a => a.pk.includes(q) || a.lb.includes(q))
    .sort((a, b) => rank(a) - rank(b) || (a.label || a.pkg).localeCompare(b.label || b.pkg))
    .slice(0, SEARCH_LIMIT);
}

function rerunSearches() {
  [['app-name-clean', 'results-clean', 'clean'],
   ['app-name-profile', 'results-profile', 'profile']].forEach(([inp, res, type]) => {
    const el = document.getElementById(inp);
    if (el && el.value.trim()) handleSearchInput(el.value, res, type);
  });
}

function showSelectedApp(pkg) {
  const nameEl  = document.getElementById('selected-app-name');
  const labelEl = document.getElementById('selected-app-label');
  const info    = nameEl.closest('.selected-app-info');
  nameEl.textContent = pkg;
  const apply = (lbl) => {
    if (nameEl.textContent !== pkg) return;
    labelEl.textContent = lbl || '';
    info.classList.toggle('no-label', !lbl);
  };
  apply(labelCache.get(pkg));
  if (!labelCache.has(pkg)) requestLabel(pkg).then(apply);
}

function createResultItem(app, type) {
  const div = document.createElement('div');
  div.className = 'result-item';
  div.tabIndex = 0;
  div.setAttribute('role', type === 'profile' ? 'radio' : 'checkbox');
  div.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); div.click(); }
  });

  const icon = document.createElement('div');
  icon.className = 'result-icon';
  icon.textContent = '📦';

  const info = document.createElement('div');
  info.className = 'result-info';
  const name = document.createElement('div');
  name.className = 'result-name';
  name.textContent = app;
  const pkg = document.createElement('div');
  pkg.className = 'result-pkg';
  pkg.textContent = app;
  name.textContent = labelOf(app);
  if (!labelCache.has(app) && ++resultLabelBudget <= RESULT_LABEL_LIMIT) {
    requestLabel(app).then(lbl => { if (lbl) name.textContent = lbl; });
  }
  info.appendChild(name);
  info.appendChild(pkg);

  const check = document.createElement('div');
  check.className = 'result-check';

  div.appendChild(icon);
  div.appendChild(info);
  div.appendChild(check);

  if (type === 'clean') {
    if (cleanSelected.has(app)) check.classList.add('checked');
    div.addEventListener('click', () => {
      const nowChecked = check.classList.toggle('checked');
      if (nowChecked) cleanSelected.add(app);
      else cleanSelected.delete(app);
    });
  } else if (type === 'profile') {
    div.addEventListener('click', () => {
      document.querySelectorAll('#results-profile .result-check').forEach(c => c.classList.remove('checked'));
      check.classList.add('checked');
      document.getElementById('selected-app-icon').textContent = '📦';
      showSelectedApp(app);
      document.getElementById('selected-app').style.display = 'flex';
      const btn = document.getElementById('profile-start-btn');
      btn.classList.remove('disabled');
      btn.textContent = t('startProfile');
    });
  }

  return div;
}

function initStepper(minusId, plusId, valueId, min, max) {
  const valEl   = document.getElementById(valueId);
  const minusEl = document.getElementById(minusId);
  const plusEl  = document.getElementById(plusId);
  if (!valEl) return;
  const getVal = () => parseInt(valEl.textContent, 10);

  const sync = () => {
    const v = getVal();
    minusEl?.classList.toggle('step-btn-disabled', v <= min);
    plusEl?.classList.toggle('step-btn-disabled', v >= max);
  };

  minusEl?.addEventListener('click', () => {
    const v = Math.max(min, getVal() - 1);
    valEl.textContent = v;
    sync();
  });
  plusEl?.addEventListener('click', () => {
    const v = Math.min(max, getVal() + 1);
    valEl.textContent = v;
    sync();
  });

  sync();
}

let pollInterval = null;
let isProcessRunning = false;

const CONSOLE_SUB_INDEX = 4;

function setStartButtonsLocked(locked) {
  ['compile', 'clean'].forEach(type => {
    const btn = document.getElementById(`${type}-start-btn`);
    if (btn) btn.disabled = locked;
  });

  const profileBtn = document.getElementById('profile-start-btn');
  if (profileBtn) {
    if (locked) {
      profileBtn.dataset.wasDisabled = profileBtn.classList.contains('disabled') ? '1' : '0';
      profileBtn.classList.add('disabled');
    } else {
      if (profileBtn.dataset.wasDisabled !== '1') {
        profileBtn.classList.remove('disabled');
      }
      delete profileBtn.dataset.wasDisabled;
    }
  }
}

async function fetchRunState() {
  try {
    const r = await fetch('/dex_optimizer/run_state', { cache: 'no-store' });
    if (!r.ok) return { running: false, error: true };
    return await r.json();
  } catch {
    return { running: false, error: true };
  }
}

function finishRunUi() {
  pollInterval = null;
  isProcessRunning = false;
  setStartButtonsLocked(false);
}

function attachRun(st) {
  if (isProcessRunning) return;
  isProcessRunning = true;
  setStartButtonsLocked(true);
  resetLogView();
  const title = document.getElementById('console-title');
  if (title) title.textContent = st.kind ? t(`${st.kind}Title`) : t('consoleTitle');
  pollInterval = pollLogs(finishRunUi);
}

async function syncRunState() {
  if (isProcessRunning) return;
  const st = await fetchRunState();
  if (st.running) attachRun(st);
}

async function waitRunStart(clickEpoch, timeoutMs = 20000) {
  const t0 = Date.now();
  while (Date.now() - t0 < timeoutMs) {
    const st = await fetchRunState();
    if (st.running && st.ready) return st;
    if (!st.running && !st.error) {
      try {
        const r = await fetch('/dex_optimizer/logs?offset=0', { cache: 'no-store' });
        if (r.ok && r.status !== 204) {
          const m = (await r.text()).match(/^@BEGIN\|(\d+)\|/);
          if (m && Number(m[1]) >= clickEpoch - 5) return { running: false, finished: true };
        }
      } catch {}
    }
    await new Promise(res => setTimeout(res, 250));
  }
  return null;
}

async function startProcess(type) {
  if (isProcessRunning) {
    showToast(t('processBusy'));
    return;
  }

  const startBtn = document.getElementById(`${type}-start-btn`);
  if (!startBtn) return;

  const st = await fetchRunState();
  if (st.running) {
    showToast(t('processBusy'));
    attachRun(st);
    openSub(CONSOLE_SUB_INDEX);
    return;
  }

  isProcessRunning = true;
  setStartButtonsLocked(true);

  resetLogView();
  startBtn.disabled = true;

  const consoleTitleEl = document.getElementById('console-title');
  if (consoleTitleEl) consoleTitleEl.textContent = t(`${type}Title`);

  showToast(t('processStarted', { name: t(`${type}Title`) }));
  openSub(CONSOLE_SUB_INDEX);

  let params = new URLSearchParams();

  if (type === 'compile') {
    const mode = document.querySelector('#mode-group .bcard.active')?.dataset.mode ?? 'auto';
    const apps = mode === 'manual'
      ? (document.querySelector('#compile-apps-group .bcard.active')?.dataset.value ?? 'user')
      : 'all';
    const profile = mode === 'manual'
      ? (document.querySelector('#compile-profile-group .bcard.active')?.dataset.value ?? 'everything-profile')
      : 'auto';
    const processes    = document.getElementById('compile-proc-value')?.textContent ?? '4';
    const dexOpt       = document.getElementById('dex-switch')?.classList.contains('on') ? 1 : 0;
    params = new URLSearchParams({ mode, apps, profile, processes, dexOptimization: dexOpt });

  } else if (type === 'clean') {
    const app      = document.querySelector('#clean-apps-group .bcard.active')?.dataset.value ?? 'user';
    const processes= document.getElementById('clean-proc-value')?.textContent ?? '4';
    const appNames = Array.from(cleanSelected).join(',');
    params = new URLSearchParams({ app, processes, appNameClean: appNames });

  } else if (type === 'profile') {
    const profile   = document.querySelector('#profile-dex-group .bcard.active')?.dataset.value ?? 'everything-profile';
    const appName   = document.getElementById('selected-app-name')?.textContent ?? '';
    params = new URLSearchParams({ profile, appNameProfile: appName });
  }

  const clickEpoch = Math.floor(Date.now() / 1000);
  let started = false;
  fetch(`${type}.sh?${params.toString()}`, { method: 'POST' }).catch(err => {
    if (started) return;
    setLogNotice(`${t('processError')}: ${err}`, true);
    finishRunUi();
  });

  const run = await waitRunStart(clickEpoch);
  if (!isProcessRunning) return;
  if (!run) {
    setLogNotice(t('processError'), true);
    finishRunUi();
    return;
  }
  started = true;
  pollInterval = pollLogs(finishRunUi);
}

const LOG_MAX_LANES = 25;
const ICON_OK   = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12l5 5 9-10"/></svg>';
const ICON_FAIL = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18"/></svg>';

function newLogState() {
  return { hasRun: false, kind: '', mode: '', profile: '', procs: 0, total: 0, epoch: 0,
           done: 0, ok: 0, fail: 0, secs: null, dex: '', dexEpoch: 0, dexSecs: 0, live: false, lanes: [], filter: 'all', buf: '' };
}
let logState = newLogState();
let logClock = null;

function parseLogEvent(line) {
  if (line.charAt(0) !== '@') return null;
  const parts = line.slice(1).split('|');
  return { tag: parts[0], f: parts.slice(1) };
}

function applyLogEvent(s, ev) {
  const num = (v) => { const x = parseInt(v, 10); return Number.isFinite(x) ? x : 0; };
  const lane = (i) => {
    if (!s.lanes[i]) s.lanes[i] = { app: '', done: 0, total: 0 };
    return s.lanes[i];
  };
  switch (ev.tag) {
    case 'RUN': {
      const [kind, mode, profile, procs, total, epoch] = ev.f;
      Object.assign(s, { hasRun: true, kind, mode, profile, procs: num(procs), total: num(total), epoch: num(epoch) });
      s.lanes = []; s.done = 0; s.ok = 0; s.fail = 0; s.secs = null;
      s.dex = ''; s.dexEpoch = 0; s.dexSecs = 0;
      const n = Math.min(s.procs, LOG_MAX_LANES);
      const base = s.procs ? Math.floor(s.total / s.procs) : 0;
      const extra = s.procs ? s.total % s.procs : 0;
      for (let i = 0; i < n; i++) lane(i).total = base + (i < extra ? 1 : 0);
      return { type: 'run' };
    }
    case 'START': {
      const i = num(ev.f[0]);
      if (i >= LOG_MAX_LANES) return null;
      lane(i).app = ev.f[1] || '';
      return { type: 'lane', i };
    }
    case 'APP': {
      const [w, count, wtotal, app, ok, secs, profile] = ev.f;
      const i = num(w);
      const isOk = ok === '1';
      const first = !s.hasRun;
      s.hasRun = true;
      s.done++;
      if (isOk) s.ok++; else s.fail++;
      if (i < LOG_MAX_LANES) {
        const l = lane(i);
        l.done = num(count); l.total = num(wtotal); l.app = '';
      }
      return { type: 'app', first, i, app: app || '', ok: isOk, secs: num(secs), profile: profile || '' };
    }
    case 'DEXOPT':
      if (ev.f[0] === 'start') {
        s.hasRun = true; s.dex = 'running'; s.dexEpoch = num(ev.f[1]); s.dexSecs = 0;
      } else if (ev.f[0] === 'end') {
        s.dex = ev.f[1] === '1' ? 'ok' : 'fail'; s.dexSecs = num(ev.f[2]);
      } else return null;
      return { type: 'dex' };
    case 'END':
      s.secs = num(ev.f[0]);
      return { type: 'end' };
    default:
      return null;
  }
}

function fmtDur(sec) {
  const s = Math.max(0, Math.round(sec));
  const m = Math.floor(s / 60), r = s % 60;
  return m ? `${m}${t('unitM')} ${r}${t('unitS')}` : `${r}${t('unitS')}`;
}

const logEl = (id) => document.getElementById(id);
const mkDiv = (cls) => { const d = document.createElement('div'); d.className = cls; return d; };

function buildLanes() {
  const box = logEl('log-lanes');
  if (!box) return;
  box.textContent = '';
  logState.lanes.forEach((_, i) => {
    const row = mkDiv('log-lane'); row.id = `log-lane-${i}`;
    const k = mkDiv('log-lane-k'); k.textContent = `#${i + 1}`;
    const mid = mkDiv('log-lane-mid');
    const track = mkDiv('log-track'); track.appendChild(mkDiv('log-fill'));
    mid.append(mkDiv('log-lane-name'), track);
    row.append(k, mid, mkDiv('log-lane-pct'));
    box.appendChild(row);
    renderLane(i);
  });
  const card = logEl('log-lanes-card');
  if (card) card.hidden = logState.lanes.length < 2;
}

function setText(el, v) { if (el && el.textContent !== v) el.textContent = v; }

function renderLane(i) {
  const l = logState.lanes[i], row = logEl(`log-lane-${i}`);
  if (!l || !row) return;
  const pct = l.total ? Math.min(100, Math.round(l.done / l.total * 100)) : 0;
  const finished = l.total > 0 && l.done >= l.total;
  setText(row.querySelector('.log-lane-name'), l.app ? labelOf(l.app) : t(finished ? 'logLaneDone' : 'logLaneIdle'));
  const fill = row.querySelector('.log-fill');
  if (fill.style.width !== `${pct}%`) fill.style.width = `${pct}%`;
  setText(row.querySelector('.log-lane-pct'), `${pct}%`);
}

let pendingRows = null;

function addLogRow(ev) {
  const list = logEl('log-list');
  if (!list) return;
  const row = mkDiv(`log-row ${ev.ok ? 'ok' : 'fail'}`);
  const ava = mkDiv('log-ava');
  ava.textContent = ((ev.app.split('.').pop() || ev.app).charAt(0) || '?').toUpperCase();
  const info = mkDiv('log-row-info');
  const name = mkDiv('log-row-name'); name.textContent = labelOf(ev.app);
  const sub = mkDiv('log-row-sub');
  const setSub = (withPkg) => {
    sub.textContent = [withPkg ? ev.app : '', ev.profile, `#${ev.i + 1}`].filter(Boolean).join(' · ');
  };
  const known = labelCache.get(ev.app);
  if (known) { ava.textContent = (Array.from(known)[0] || '?').toUpperCase(); }
  setSub(!!known);
  if (!known) {
    requestLabel(ev.app).then(lbl => {
      if (!lbl) return;
      name.textContent = lbl;
      ava.textContent = (Array.from(lbl)[0] || '?').toUpperCase();
      setSub(true);
    });
  }
  info.append(name, sub);
  const right = mkDiv('log-row-right');
  const tm = mkDiv('log-row-time'); tm.textContent = fmtDur(ev.secs);
  const st = mkDiv('log-row-status'); st.innerHTML = ev.ok ? ICON_OK : ICON_FAIL;
  const label = document.createElement('span'); label.textContent = t(ev.ok ? 'logStOk' : 'logStFail');
  st.appendChild(label);
  right.append(tm, st);
  row.append(ava, info, right);
  if (!pendingRows) pendingRows = document.createDocumentFragment();
  pendingRows.prepend(row);
}

function renderLogSummary() {
  const s = logState;
  const set = (id, v) => setText(logEl(id), v);
  const total = s.total || s.done;
  const pct = total ? Math.min(100, Math.round(s.done / total * 100)) : 0;

  const ring = logEl('log-ring');
  if (ring && ring.style.getPropertyValue('--p') !== String(pct)) ring.style.setProperty('--p', pct);
  set('log-ring-pct', `${pct}%`);
  set('log-sum-apps', t('logApps', { done: s.done, total }));

  const parts = [];
  if (s.kind !== 'clean') {
    const pr = (!s.profile || s.profile === 'auto' || s.mode === 'auto') ? t('logProfileAuto') : s.profile;
    parts.push(t('logProfile', { profile: pr }));
  }
  if (s.kind !== 'profile' && s.procs) parts.push(t('logProcesses', { n: s.procs }));
  set('log-sum-profile', parts.join(' · '));

  let elapsed = null;
  if (s.secs !== null) elapsed = s.secs;
  else if (s.live && s.epoch) elapsed = Date.now() / 1000 - s.epoch;
  if (elapsed !== null) set('log-sum-time', t('logElapsed', { time: fmtDur(elapsed) }));
  else set('log-sum-time', (s.hasRun && !s.live) ? t('logInterrupted') : '');

  const dexEl = logEl('log-dex');
  if (dexEl) {
    let state = s.dex, text = '';
    if (state === 'running' && !s.live) state = 'stopped';
    if (state === 'running') {
      const el = s.dexEpoch ? Math.max(0, Date.now() / 1000 - s.dexEpoch) : 0;
      text = t('logDexRunning', { time: fmtDur(el) });
    } else if (state === 'ok')      text = t('logDexOk',   { time: fmtDur(s.dexSecs) });
    else if (state === 'fail')      text = t('logDexFail', { time: fmtDur(s.dexSecs) });
    else if (state === 'stopped')   text = t('logDexStopped');
    if (dexEl.hidden !== !text) dexEl.hidden = !text;
    if (dexEl.dataset.state !== state) dexEl.dataset.state = state;
    set('log-dex-text', text);
  }

  set('log-lanes-title', t('logLanes'));
  const chips = { all: ['logAll', s.done], fail: ['logFail', s.fail], ok: ['logOk', s.ok] };
  document.querySelectorAll('#log-filters .log-chip').forEach(c => {
    const [key, n] = chips[c.dataset.filter];
    setText(c, `${t(key)} ${n}`);
  });
  const shown = chips[s.filter][1];
  const empty = logEl('log-empty');
  if (empty) { setText(empty, t('logEmpty')); const h = !(s.hasRun && shown === 0); if (empty.hidden !== h) empty.hidden = h; }
}

function setLogMode() {
  const v = logEl('log-view');
  if (v) v.dataset.mode = logState.hasRun ? 'run' : 'text';
}

function startLogClock() { stopLogClock(); logClock = setInterval(renderLogSummary, 1000); }
function stopLogClock()  { if (logClock) { clearInterval(logClock); logClock = null; } }

function resetLogView() {
  stopLogClock();
  pendingRows = null;
  logState = newLogState();
  ['log-list', 'log-lanes'].forEach(id => { const el = logEl(id); if (el) el.textContent = ''; });
  setLogNotice('');
  const list = logEl('log-list'); if (list) list.dataset.filter = 'all';
  document.querySelectorAll('#log-filters .log-chip').forEach(c => {
    const on = c.dataset.filter === 'all';
    c.classList.toggle('active', on);
    c.setAttribute('aria-pressed', on ? 'true' : 'false');
  });
  const lanesCard = logEl('log-lanes-card'); if (lanesCard) lanesCard.hidden = true;
  setLogMode();
  renderLogSummary();
}

function setLogNotice(text, isError) {
  const el = logEl('log-notice');
  if (!el) return;
  el.textContent = text || '';
  el.hidden = !text;
  el.classList.toggle('error', !!isError);
}

function handleLogLine(line) {
  line = line.replace(/\r$/, '');
  const ev = parseLogEvent(line);
  if (!ev) return;
  const res = applyLogEvent(logState, ev);
  if (!res) return;
  if (res.type === 'run') { setLogMode(); buildLanes(); }
  else if (res.type === 'lane') {
    renderLane(res.i);
    const app = logState.lanes[res.i]?.app;
    if (app && !labelCache.has(app)) requestLabel(app).then(() => renderLane(res.i));
  }
  else if (res.type === 'app') {
    if (res.first) { setLogMode(); buildLanes(); }
    addLogRow(res);
    if (res.i < LOG_MAX_LANES) renderLane(res.i);
  }
}

function feedLog(text) {
  logState.buf += text;
  const lines = logState.buf.split('\n');
  logState.buf = lines.pop();
  lines.forEach(handleLogLine);
  if (pendingRows) {
    const list = logEl('log-list');
    if (list) list.prepend(pendingRows);
    pendingRows = null;
  }
  renderLogSummary();
}

function initLogView() {
  logEl('log-filters')?.addEventListener('click', (e) => {
    const chip = e.target.closest('.log-chip');
    if (!chip) return;
    logState.filter = chip.dataset.filter;
    const list = logEl('log-list'); if (list) list.dataset.filter = logState.filter;
    document.querySelectorAll('#log-filters .log-chip').forEach(c => {
      const on = c === chip;
      c.classList.toggle('active', on);
      c.setAttribute('aria-pressed', on ? 'true' : 'false');
    });
    renderLogSummary();
  });
  renderLogSummary();
}

const POLL_SAFETY_MS = 12 * 60 * 60 * 1000;

async function waitRunEnd(timeoutMs = 5000) {
  const t0 = Date.now();
  while (Date.now() - t0 < timeoutMs) {
    const st = await fetchRunState();
    if (!st.running) return;
    await new Promise(res => setTimeout(res, 250));
  }
}

function pollLogs(onComplete) {
  let offset   = 0;
  let logId    = '';
  let idle     = 0;
  let errors   = 0;
  let finished = false;
  let busy     = false;
  const startedAt = Date.now();

  logState.live = true;
  startLogClock();

  const complete = () => {
    clearInterval(iv);
    logState.live = false;
    stopLogClock();
    renderLogSummary();
    loadAndDrawStats();
    onComplete();
  };

  const iv = setInterval(async () => {
    if (busy) return;
    busy = true;
    try {
      if (Date.now() - startedAt > POLL_SAFETY_MS) {
        setLogNotice(t('timedOut'), true);
        complete();
        return;
      }

      const r = await fetch(`/dex_optimizer/logs?offset=${offset}&id=${encodeURIComponent(logId)}`, { cache: 'no-store' });

      let skipBytes = 0;
      if (r.headers.get('X-Log-Reset') === '1') {
        const hdrId = r.headers.get('X-Log-Id');
        if (offset > 0 && hdrId && hdrId === logId) {
          skipBytes = offset;
        } else {
          offset = 0; idle = 0; finished = false;
          resetLogView();
          logState.live = true;
          startLogClock();
        }
      }
      logId = r.headers.get('X-Log-Id') || logId;

      if (!r.ok) {
        if (++errors >= 3) {
          setLogNotice(`${t('errorRequest')} HTTP ${r.status}`, true);
          complete();
        }
        return;
      }
      errors = 0;

      if (r.status === 204) {
        idle++;
      } else {
        let text = await r.text();
        if (skipBytes) {
          text = new TextDecoder().decode(new TextEncoder().encode(text).slice(skipBytes));
          offset = parseInt(r.headers.get('X-Log-Offset') ?? offset, 10);
        }
        if (!text.length) idle++;
        else {
          feedLog(text);
          offset = parseInt(r.headers.get('X-Log-Offset') ?? offset, 10);
          idle = 0;
          if (text.includes('[DONE]')) finished = true;
        }
      }

      if (finished) {
        await waitRunEnd();
        complete();
        return;
      }

      if (idle >= 3 && idle % 3 === 0) {
        const st = await fetchRunState();
        if (!st.error && !st.running) complete();
      }
    } catch (e) {
      if (++errors >= 3) {
        setLogNotice(`${t('errorRequest')} ${e}`, true);
        complete();
      }
    } finally {
      busy = false;
    }
  }, 1000);

  return iv;
}

async function showLastRun() {
  resetLogView();
  const title = document.getElementById('console-title');
  if (title) title.textContent = t('consoleTitle');
  try {
    const r = await fetch('/dex_optimizer/logs?offset=0', { cache: 'no-store' });
    const text = (r.ok && r.status !== 204) ? await r.text() : '';
    if (!text.trim()) { setLogNotice(t('logNoRuns')); return; }
    feedLog(text + '\n');
    if (!logState.hasRun) { setLogNotice(t('logNoRuns')); return; }
    if (title && logState.kind) title.textContent = t(`${logState.kind}Title`);
  } catch (e) {
    setLogNotice(`${t('errorRequest')} ${e}`, true);
  }
}

async function openDexLogs() {
  if (!logEl('log-view')) return;
  openSub(CONSOLE_SUB_INDEX);

  if (!isProcessRunning) {
    const st = await fetchRunState();
    if (st.running) attachRun(st);
  }
  if (isProcessRunning) return;
  await showLastRun();
}

function formatTimeDiff(ts) {
  const diffMs  = Date.now() - ts * 1000;
  const diffSec = Math.floor(diffMs / 1000);

  if (diffSec < 60)  return t('lessThanMinuteAgo');

  const diffMin = Math.floor(diffSec / 60);
  if (diffMin < 60)  return t('minutesAgo', { minutes: diffMin });

  const diffH = Math.floor(diffMin / 60);
  if (diffH < 24)    return t('hoursAgo', { hours: diffH });

  const diffD = Math.floor(diffH / 24);
  return t('daysAgo', { days: diffD });
}

async function loadAndDrawStats() {
  try {
    const r = await fetch('/dex_optimizer/stats', { cache: 'no-store' });
    if (!r.ok) return;
    const data = await r.json();

    const set = (id, v) => { const el = document.getElementById(id); if (el) el.textContent = v ?? '—'; };
    set('s-optimized', data.optimized);
    set('s-runs',      data.runs);
    set('s-speed',     data.speedGain ? data.speedGain + '%' : '—');
    set('s-last',      data.lastRun ? formatTimeDiff(data.lastRun) : '—');

    set('stat-optimized',  data.optimized);
    set('stat-lastrun',    data.lastRun ? formatTimeDiff(data.lastRun) : '—');
    set('stat-prog-pct',   data.dexPct ? data.dexPct + '%' : '—');
    const fill = document.getElementById('stat-prog-fill');
    if (fill) fill.style.width = (data.dexPct ?? 0) + '%';
    const grid = document.getElementById('stat-grid');
    if (grid) grid.style.display = 'grid';

    drawChart(data.chart ?? []);
  } catch (e) {
    console.warn('Stats load error:', e);
  }
}

function drawChart(points) {
  const container = document.getElementById('statsChart');
  if (!container) return;

  container.innerHTML = '';

  if (!points.length) {
    container.classList.add('empty');
    container.textContent = t('noData');
    return;
  }
  container.classList.remove('empty');

  const max = Math.max(...points.map(p => Number(p.time) || 0), 0) || 1;

  points.forEach(p => {
    const value = Number(p.time) || 0;
    const [datePart, timePart] = String(p.date).split(' ');

    const col = document.createElement('div');
    col.className = 'bar-chart-col';

    const valueEl = document.createElement('div');
    valueEl.className = 'bar-chart-value';
    valueEl.textContent = value.toFixed(2);

    const bar = document.createElement('div');
    bar.className = 'bar-chart-bar';
    bar.style.height = `${Math.max(4, (value / max) * 100)}%`;
    bar.title = `${p.date}: ${value.toFixed(2)}`;

    const label = document.createElement('div');
    label.className = 'bar-chart-label';

    const labelDate = document.createElement('div');
    labelDate.className = 'bar-chart-label-date';
    labelDate.textContent = datePart ?? '';

    const labelTime = document.createElement('div');
    labelTime.className = 'bar-chart-label-time';
    labelTime.textContent = timePart ?? '';

    label.appendChild(labelDate);
    label.appendChild(labelTime);

    col.appendChild(valueEl);
    col.appendChild(bar);
    col.appendChild(label);
    container.appendChild(col);
  });

  container.scrollLeft = container.scrollWidth;
}

function initTheme() {
  const saved = localStorage.getItem('theme') || 'calmNight';
  if (saved !== 'calmNight') document.body.classList.add(saved);
  document.querySelector(`.theme-dot[data-theme="${saved}"]`)?.classList.add('selected');

  document.querySelectorAll('.theme-dot').forEach(dot => {
    dot.addEventListener('click', function() {
      const theme = this.dataset.theme;
      document.body.className = document.body.className
        .replace(/calmNight|mutedOcean|eclipse|crimsonNoir|amberDusk/g, '').trim();
      document.body.classList.add(theme);
      document.querySelectorAll('.theme-dot').forEach(d => d.classList.remove('selected'));
      this.classList.add('selected');
      localStorage.setItem('theme', theme);
    });
  });
}

function initDonateButtons() {
  document.getElementById('yoomoneyBtn')?.addEventListener('click', () => {
    window.open('https://yoomoney.ru/to/410015528696708', '_blank', 'noopener,noreferrer');
  });

  document.getElementById('tgWalletBtn')?.addEventListener('click', () => {
    const addr = 'UQAgcSOHQKe2lZHJ1_kJNcUrEeHeTlFoL7YmF51F06j6ELfc';
    navigator.clipboard?.writeText(addr).catch(() => legacyCopy(addr));
    showToast(t('copyLabel'));
  });
}

function legacyCopy(text) {
  const ta = document.createElement('textarea');
  ta.value = text;
  ta.style.cssText = 'position:fixed;opacity:0';
  document.body.appendChild(ta);
  ta.select();
  try { document.execCommand('copy'); } catch {}
  document.body.removeChild(ta);
}

function initStatsClearBtn() {
  const btn = document.getElementById('stats-clear-btn');
  if (!btn) return;

  let confirming = false;
  let revertTimer;

  const reset = () => {
    confirming = false;
    btn.classList.remove('confirm');
    btn.textContent = '🗑';
  };

  btn.addEventListener('click', async () => {
    if (!confirming) {
      confirming = true;
      btn.classList.add('confirm');
      btn.textContent = t('confirmClear');
      clearTimeout(revertTimer);
      revertTimer = setTimeout(reset, 3000);
      return;
    }

    clearTimeout(revertTimer);
    reset();

    try {
      const r = await fetch('/dex_optimizer/clear_stats', { method: 'POST' });
      if (!r.ok) throw new Error();
      showToast(t('statsCleared'));
      await loadAndDrawStats();
    } catch {
      showToast(t('statsClearError'));
    }
  });
}

const UPDATE_POLL_MS  = 1000;
const UPDATE_POLL_MAX = 300;

async function getUpdateState() {
  const r = await fetch('/dex_optimizer/update_state', { cache: 'no-store' });
  if (!r.ok) return { state: 'error', arg: 'nonet' };
  const txt = (await r.text()).trim();
  const i = txt.indexOf('|');
  return i < 0 ? { state: txt, arg: '' } : { state: txt.slice(0, i), arg: txt.slice(i + 1) };
}

async function waitUpdateState(done) {
  for (let i = 0; i < UPDATE_POLL_MAX; i++) {
    await new Promise(res => setTimeout(res, UPDATE_POLL_MS));
    let s;
    try { s = await getUpdateState(); } catch { continue; }
    if (done.includes(s.state)) return s;
  }
  return { state: 'error', arg: 'timeout' };
}

function openDialog({ title, text, yesLabel, noLabel }) {
  return new Promise(resolve => {
    const dlg = document.getElementById('app-dialog');
    const yes = document.getElementById('app-dialog-yes');
    const no  = document.getElementById('app-dialog-no');
    if (!dlg || !yes || !no) { resolve(false); return; }

    document.getElementById('app-dialog-title').textContent = title;
    document.getElementById('app-dialog-text').textContent  = text;
    yes.textContent = yesLabel;
    no.textContent  = noLabel || '';
    no.hidden = !noLabel;

    const close = (value) => {
      dlg.hidden = true;
      yes.onclick = no.onclick = dlg.onclick = null;
      resolve(value);
    };
    yes.onclick = () => close(true);
    no.onclick  = () => close(false);
    dlg.onclick = (e) => { if (e.target === dlg) close(false); };

    dlg.hidden = false;
    yes.focus();
  });
}

function showUpdateError(code) {
  const key = 'updateErr_' + code;
  const msg = t(key);
  showToast(msg === key ? t('updateMsgError') : msg);
}

async function postUpdate(mode) {
  const r = await fetch(`/dex_optimizer/update?mode=${mode}`, { method: 'POST' });
  return r.ok;
}

async function runUpdateFlow() {
  if (!await postUpdate('download')) { showToast(t('updateMsgError')); return; }
  showToast(t('updateMsg'));

  const dl = await waitUpdateState(['ready', 'noupdate', 'error']);
  if (dl.state === 'noupdate') { showToast(t('updateNone')); return; }
  if (dl.state !== 'ready')    { showUpdateError(dl.arg); return; }

  const confirmed = await openDialog({
    title:    t('updateDialogTitle'),
    text:     t('updateDialogText', { version: dl.arg }),
    yesLabel: t('updateYes'),
    noLabel:  t('updateNo'),
  });
  if (!confirmed) {
    await postUpdate('cancel').catch(() => {});
    return;
  }

  if (!await postUpdate('install')) { showToast(t('updateMsgError')); return; }
  showToast(t('updateInstalling'));

  const inst = await waitUpdateState(['installed', 'error']);
  if (inst.state !== 'installed') { showUpdateError(inst.arg); return; }

  await openDialog({
    title:    t('updateDoneTitle'),
    text:     t('updateDoneText', { version: inst.arg }),
    yesLabel: t('updateOk'),
  });
}

function initUpdateBtn() {
  document.getElementById('update-btn')?.addEventListener('click', async function() {
    if (this.dataset.busy === '1') return;
    this.dataset.busy = '1';
    this.textContent = t('updating');
    try {
      await runUpdateFlow();
    } catch {
      showToast(t('updateMsgError'));
    }
    this.textContent = t('updateBtn');
    this.dataset.busy = '0';
  });
}

let toastTimer;
function showToast(msg) {
  const el = document.getElementById('info-message');
  if (!el) return;
  el.textContent = msg;
  el.classList.add('visible');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('visible'), 2500);
}

let wakeLock = null;
async function enableScreenLock() {
  try {
    if ('wakeLock' in navigator) {
      wakeLock = await navigator.wakeLock.request('screen');
      wakeLock.addEventListener('release', () => { wakeLock = null; });
    }
  } catch {}
}
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible' && !wakeLock) enableScreenLock();
});

function initKeyboardAccessibility() {
  const selector = [
    '.nav-item', '.menu-tile', '.back-btn', '.bcard', '.step-btn',
    '.switch', '.theme-dot', '#lang-row', '.result-item',
    '.donate-btn', '.update-btn', '.selected-app-clear', '.chart-clear-btn',
  ].join(',');

  document.querySelectorAll(selector).forEach(el => {
    if (el.hasAttribute('tabindex')) return;
    if (el.classList.contains('disabled') || el.closest('.disabled')) return;
    el.setAttribute('tabindex', '0');
    if (!el.hasAttribute('role')) el.setAttribute('role', 'button');
    el.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        el.click();
      }
    });
  });
}

document.addEventListener('DOMContentLoaded', async () => {
  applyTranslations();
  initTheme();
  initLangSwitcher();
  loadAppsIndex();
  loadAndDrawStats();

  document.querySelectorAll('.nav-item[data-main]').forEach(item => {
    item.addEventListener('click', () => goMain(parseInt(item.dataset.main, 10)));
  });

  const dexCard = document.getElementById('stat-dex-card');
  if (dexCard) {
    dexCard.addEventListener('click', openDexLogs);
    dexCard.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); openDexLogs(); }
    });
  }

  document.querySelectorAll('.menu-tile[data-sub]').forEach(tile => {
    tile.addEventListener('click', () => {
      const i = parseInt(tile.dataset.sub, 10);
      openSub(i);
      if (i === 3) loadAndDrawStats();
    });
  });

  document.querySelectorAll('[data-close-sub]').forEach(btn => {
    btn.addEventListener('click', closeSub);
  });

  initCompilePage();
  initCleanPage();
  initProfilePage();
  initDonateButtons();
  initStatsClearBtn();
  initUpdateBtn();
  initLogView();
  initKeyboardAccessibility();

  enableScreenLock();

  syncRunState();
  setInterval(() => { if (!document.hidden) syncRunState(); }, 5000);
});