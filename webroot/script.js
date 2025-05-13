document.addEventListener('DOMContentLoaded', async () => {
  const navItems = document.querySelectorAll('.nav-item');
  const menuButtons = document.querySelectorAll(".review-item");
  const mainContainer = document.querySelector(".container");
  const containers = document.querySelectorAll(".container-compile");
  const taskBoxes = document.querySelectorAll(".task-box-compile");

  displayLastRunTime();

  function resetContainerState(containerId) {
    const container = document.getElementById(containerId);
    const inputs = container.querySelectorAll('input');
    const startButton = container.querySelector('.start-button');
    if (startButton && containerId !== 'compile-container') {
      startButton.disabled = true;
    }
    
    inputs.forEach(input => {
      input.value = '';
      if (input.type === 'checkbox') {
        input.checked = false;
      }
    });

    const resultsContainerClean = container.querySelector('.results-container-clean');
    if (resultsContainerClean) {
      resultsContainerClean.innerHTML = '';
      resultsContainerClean.style.opacity = "0";
      resultsContainerClean.style.transform = "translateY(-10px)";
      setTimeout(() => {
        resultsContainerClean.style.display = "none";
        resultsContainerClean.classList.remove('show');
      }, 500);
    }

    const resultsContainerProfile = container.querySelector('.results-container-profile');
    if (resultsContainerProfile) {
      resultsContainerProfile.innerHTML = '';
      resultsContainerProfile.style.opacity = "0";
      resultsContainerProfile.style.transform = "translateY(-10px)";
      setTimeout(() => {
        resultsContainerProfile.style.display = "none";
        resultsContainerProfile.classList.remove('show');
      }, 500);
    }

    const modeButtons = container.querySelectorAll('.mode-button');
    modeButtons.forEach(button => {
      button.classList.remove('active');
    });

    const sliders = container.querySelectorAll('.slider');
    sliders.forEach(slider => {
      slider.value = slider.min || 0;
      const valueId = slider.id.replace('processes', 'sliderValue');
      const sliderValue = document.getElementById(valueId);
      if (sliderValue) {
        sliderValue.textContent = slider.value;
      }
    });

    setMode('auto');
    setOptimization('yes');
    setProfile('everything-profile');
    setProfileContainer('everything-profile');
    setAppsCompile('user');
    setAppsClean('user');
    displayLastRunTime();

    const outputCompile = document.getElementById('output-compile');
    const outputClean = document.getElementById('output-clean');
    const outputProfile = document.getElementById('output-profile');

    if (outputCompile) outputCompile.textContent = '';
    if (outputClean) outputClean.textContent = '';
    if (outputProfile) outputProfile.textContent = '';

    outputCompile.style.display = 'none';
    outputClean.style.display = 'none';
    outputProfile.style.display = 'none';
  }

  navItems.forEach(item => {
    item.addEventListener('click', (e) => {
      navItems.forEach(nav => nav.classList.remove('active'));
      e.target.classList.add('active');
    });
  });

  menuButtons.forEach(button => {
    button.addEventListener("click", () => {
      const targetId = button.getAttribute("data-target");
      const targetContainer = document.getElementById(targetId);

      if (targetContainer) {
        mainContainer.classList.add("hidden");
        setTimeout(() => {
          mainContainer.style.display = "none";
          containers.forEach(container => {
            container.style.display = "none";
            container.classList.add("hidden");
          });

          targetContainer.style.display = "block";
          setTimeout(() => targetContainer.classList.remove("hidden"), 10);
        }, 500);
      }
    });
  });

  taskBoxes.forEach(taskBox => {
    taskBox.addEventListener("click", (event) => {
      event.stopPropagation();
      const parentContainer = taskBox.closest(".container-compile");
      if (parentContainer) {
        const containerId = parentContainer.id;
        resetContainerState(containerId);
        parentContainer.classList.add("hidden");
        setTimeout(() => {
          parentContainer.style.display = "none";
          mainContainer.style.display = "block";
          setTimeout(() => {
            mainContainer.classList.remove("hidden");
            mainContainer.style.transform = "translateY(0)";
          }, 10);
        }, 500);
      }
    });
  });

  const savedTheme = localStorage.getItem('theme');
  if (savedTheme) {
    const themeOption = document.querySelector(`.theme-option[data-theme="${savedTheme}"]`);
    themeOption?.classList.add('selected');
    document.body.classList.add(savedTheme);
  }

  document.querySelectorAll('.theme-option').forEach(option => {
    option.addEventListener('click', function () {
      document.querySelectorAll('.theme-option').forEach(opt => opt.classList.remove('selected'));
      this.classList.add('selected');
      const selectedTheme = this.getAttribute('data-theme');
      document.body.classList.remove('calmNight', 'mutedOcean', 'eclipse');
      document.body.classList.add(selectedTheme);
      localStorage.setItem('theme', selectedTheme);
    });
  });

  try {
    const response = await fetch("/dex_optimizer/logs?offset=0", { method: "GET" });

    if (response.ok) {
      const containers = document.querySelectorAll("#compile-container, #clean-container, #profile-container");

      containers.forEach(container => {
        const button = container.querySelector(".start-button");
        const taskBoxCompile = container.querySelector(".task-box-compile");
        const outputElement = container.querySelector("pre");
        const content = container.querySelector(".content");

        if (button && taskBoxCompile && outputElement && content) {
          content.style.display = "none";
          outputElement.style.display = "block";

          button.disabled = true;
          taskBoxCompile.style.pointerEvents = "none";

          previousOffset = 0;
          processCompleted = false;

          pollLogs(outputElement, () => {
            onLogsComplete(content, button, taskBoxCompile);
          });
        }
      });
    } else {
      console.log("Процесс не активен (script_logs.out отсутствует)");

      const containers = document.querySelectorAll("#compile-container, #clean-container, #profile-container");

      containers.forEach(container => {
        const content = container.querySelector(".content");
        const button = container.querySelector(".start-button");

        if (content && button) {
          content.style.display = "block";
          button.style.display = "block";
        }
      });
    }
  } catch (error) {
    console.error("Ошибка при проверке лога:", error);
  }
});

const translations = {
  ru: {
    thankYou: 'Спасибо за тестирование:',
    never: 'Никогда',
    lessThanMinuteAgo: 'Менее минуты назад',
    errorRequest: 'Ошибка запроса:',
    lastRunTimeLabel: 'Последний запуск:',
    greeting: 'Привет, {userName}',
    lessThanMinuteAgo: 'Менее минуты назад',
    never: 'Никогда',
    daysAgo: '{days} {daysWord} назад',
    hoursAgo: '{hours} {hoursWord} назад',
    minutesAgo: '{minutes} {minutesWord} назад',
    day: 'день',
    dayFew: 'дня',
    dayMany: 'дней',
    hour: 'час',
    hourFew: 'часа',
    hourMany: 'часов',
    minute: 'минута',
    minuteFew: 'минуты',
    minuteMany: 'минут',
    menu: 'Меню',
    compile: 'Компиляция',
    clean: 'Очистка',
    profile: 'Профиль:',
    profileLabel: 'Профиль',
    stats: 'Статистика',
    settings: 'Настройки',
    parameters: 'Параметры',
    parametersLabel: 'Параметры:',
    apps: 'Приложения:',
    appsLabel: 'Приложения',
    user: 'Пользовательские',
    system: 'Системные',
    all: 'Все',
    selectively: 'Выборочно',
    additional: 'Дополнительно',
    processes: 'Число процессов:',
    optimization: 'Оптимизация DEX:',
    start: 'Начать',
    yes: 'Да',
    no: 'Нет',
    auto: 'Авто',
    manual: 'Ручной',
    enterAppName: 'Введите название',
    appName: 'Название приложения:',
    textTime: 'Время (сек)',
    textDate: 'Дата',
    copyLabel: 'Скопировано!',
    donate: 'Поддержка',
    updateMsg: 'Обновление модуля...',
    updateMsgError: 'Ошибка обновления',
  },
  en: {
    thankYou: 'Thank you for testing:',
    never: 'Never',
    lessThanMinuteAgo: 'Less than a minute ago',
    errorRequest: 'Request error:',
    lastRunTimeLabel: 'Last run:',
    greeting: 'Hello, {userName}',
    lessThanMinuteAgo: 'Less than a minute ago',
    never: 'Never',
    daysAgo: '{days} {daysWord} ago',
    hoursAgo: '{hours} {hoursWord} ago',
    minutesAgo: '{minutes} {minutesWord} ago',
    day: 'day',
    dayFew: 'days',
    hour: 'hour',
    hourFew: 'hours',
    minute: 'minute',
    minuteFew: 'minutes',
    menu: 'Menu',
    compile: 'Compilation',
    clean: 'Cleaning',
    profile: 'App Profile:',
    profileLabel: 'App Profile',
    stats: 'Statistics',
    settings: 'Settings',
    parameters: 'Parameters',
    parametersLabel: 'Parameters:',
    apps: 'Applications:',
    appsLabel: 'Applications',
    user: 'Users',
    system: 'Systems',
    all: 'All',
    selectively: 'Selectively',
    additional: 'Additional',
    processes: 'Number of processes:',
    optimization: 'DEX optimization:',
    start: 'Start',
    yes: 'Yes',
    no: 'No',
    auto: 'Auto',
    manual: 'Manual',
    enterAppName: 'Enter name',
    appName: 'App name:',
    textTime: 'Time (sec)',
    textDate: 'Date',
    copyLabel: 'Copied!',
    donate: 'Donate',
    updateMsg: 'Module update',
    updateMsgError: 'Update error',
  },
};

function toggleManualOptions(show) {
  const container = document.getElementById('manual-options');
  if (show) {
      container.style.display = "block";
      setTimeout(() => {
          container.classList.add('show');
          container.style.opacity = "1";
          container.style.transform = "translateY(0)";
      }, 10); 
  } else {
      container.style.opacity = "0";
      container.style.transform = "translateY(-10px)";
      setTimeout(() => {
          container.style.display = "none";
          container.classList.remove('show');
      }, 500);
  }
}

function toggleAppSelection(show) {
  const container = document.getElementById('app-selection-container');
  if (show) {
      container.style.display = "block";
      setTimeout(() => {
          container.classList.add('show');
          container.style.opacity = "1";
          container.style.transform = "translateY(0)";
      }, 10); 
  } else {
      container.style.opacity = "0";
      container.style.transform = "translateY(-10px)";
      setTimeout(() => {
          container.style.display = "none";
          container.classList.remove('show');
      }, 500);
  }
}

let previousOffset = 0;
let processCompleted = false;
let silenceCount = 0;

function onLogsComplete(content, button, taskBoxCompile) {
  setTimeout(() => {
    content.style.display = "block";
    requestAnimationFrame(() => {
      content.classList.remove("hidden");
    });
    setTimeout(() => {
      const container = button.closest('.container-compile');
      const containerId = container?.id;

      if (containerId === 'compile-container' || containerId === 'clean-container') {
        button.disabled = false;
      } else if (containerId === 'profile-container') {
        updateStartButtonState('profile');
      }
      taskBoxCompile.style.pointerEvents = "auto";
    }, 1000);
  }, 300);
}

function pollLogs(outputElement, onComplete) {
  let errorCount = 0;   
  let silenceCount = 0;  
  const maxErrors = 3;     
  const maxSilence = 3;   
  let previousOffset = 0; 
  let processCompleted = false;

  const interval = setInterval(async () => {
    try {
      const response = await fetch(`/dex_optimizer/logs?offset=${previousOffset}`);

      if (response.status === 500) {
        errorCount++;
        if (errorCount >= maxErrors) {
          clearInterval(interval);
          onComplete();
        }
        return;
      }

      if (response.status === 204) {
        if (processCompleted) {
          silenceCount++;
          if (silenceCount >= maxSilence) {
            clearInterval(interval);
            onComplete();
          }
        }
        return;
      }

      const newOffset = response.headers.get("X-Log-Offset");
      const text = await response.text();

      if (text.trim()) {
        outputElement.textContent += text;
        outputElement.scrollTop = outputElement.scrollHeight;
        previousOffset = parseInt(newOffset, 10);
        silenceCount = 0;
        errorCount = 0;
      }
    } catch (err) {
      outputElement.textContent += "\n[Ошибка запроса логов]: " + err;
      clearInterval(interval);
      onComplete();
    }
  }, 1000);
}

async function startProcess(containerId, button, type) {
  const container = document.getElementById(containerId);
  const content = container.querySelector(".content");
  const outputElement = document.getElementById(`output-${type}`);
  const taskBoxCompile = container.querySelector(".task-box-compile");

  if (!content || !outputElement) return;

  outputElement.textContent = "";
  previousOffset = 0;
  processCompleted = false;

  button.disabled = true;
  content.classList.add("hidden");
  taskBoxCompile.style.pointerEvents = "none";
  outputElement.style.display = "block";

  setTimeout(() => {
    content.style.display = "none";
  }, 700);

  let params = new URLSearchParams();

  if (type === 'clean') {
    const app = document.querySelector('[data-group="apps-clean"].active')?.getAttribute('data-value');
    const processes = document.getElementById('processes-clean').value;
    const appNameClean = Array.from(document.querySelectorAll('.search-container[data-container="clean"] .result-item input:checked'))
    .map(checkbox => checkbox.value)
    .join(',');
    params = new URLSearchParams({ app, processes, appNameClean });
  } else if (type === 'profile') {
    const profile = document.querySelector('[data-group="profile-container"].active')?.getAttribute('data-value');
    const appNameProfile = Array.from(document.querySelectorAll('.search-container[data-container="profile"] .result-item input:checked'))
    .map(checkbox => checkbox.value)
    .join(',');
    params = new URLSearchParams({ profile, appNameProfile });
  } else if (type === 'compile') {
    const mode = document.querySelector('[data-group="mode"].active')?.id === 'manualBtn' ? 'manual' : 'auto';
    const apps = mode === 'manual' 
      ? document.querySelector('[data-group="apps-compile"].active')?.getAttribute('data-value') || 'user' 
      : 'all';
    const profile = mode === 'manual' 
      ? document.querySelector('[data-group="profile"].active')?.getAttribute('data-value') || 'everything-profile'
      : 'auto';
  
    const processes = document.getElementById('processes-compile').value;
    const dexOptimization = document.querySelector('[data-group="optimization"].active')?.id === 'yesBtn' ? 1 : 0;
  
    params = new URLSearchParams({ mode, apps, profile, processes, dexOptimization });
  }

  pollLogs(outputElement, () => {
    onLogsComplete(content, button, taskBoxCompile);
  });

  try {
    await fetch(`${type}.sh?${params.toString()}`, { method: 'POST' });
    processCompleted = true;
  } catch (error) {
    outputElement.textContent += "\nОшибка: " + error;
    processCompleted = true;
  }
}

function searchApp(button, containerType) {
  const inputElement = button.previousElementSibling;
  const query = inputElement.value.trim();
  const resultsContainer = button.closest('.search-container').querySelector(`.results-container-${containerType}`);

  const selectedItems = [];
  resultsContainer.querySelectorAll('.result-item').forEach(item => {
    const checkbox = item.querySelector('input');
    if (checkbox.checked) {
      selectedItems.push({
        app: checkbox.value,
        element: item.cloneNode(true)
      });
    }
  });

  if (query.length > 0) {
    resultsContainer.innerHTML = "";
  }

  if (query.length === 0) {
    resultsContainer.innerHTML = "";
    if (selectedItems.length > 0) {
      selectedItems.forEach(item => {
        const clonedElement = item.element;
        restoreEventHandlers(clonedElement, containerType);
        resultsContainer.appendChild(clonedElement);
      });
      resultsContainer.style.display = "flex";
      resultsContainer.classList.add('show');
      resultsContainer.style.opacity = "1";
      resultsContainer.style.transform = "translateY(0)";
    } else {
      resultsContainer.style.opacity = "0";
      resultsContainer.style.transform = "translateY(-10px)";
      setTimeout(() => {
        resultsContainer.style.display = "none";
        resultsContainer.classList.remove('show');
      }, 500);
    }
    return;
  }

  fetch('/dex_optimizer/search_apps?app_name=' + encodeURIComponent(query))
  .then(response => response.text())
  .then(text => {
    const apps = text.split('\n').filter(app => app.trim() !== '');

    if (apps.length > 0 || selectedItems.length > 0) {
      resultsContainer.style.display = "flex";
      setTimeout(() => {
        resultsContainer.classList.add('show');
        resultsContainer.style.opacity = "1";
        resultsContainer.style.transform = "translateY(0)";
      }, 10);
    
      selectedItems.forEach(item => {
        const clonedElement = item.element;
        restoreEventHandlers(clonedElement, containerType);
        resultsContainer.appendChild(clonedElement);
      });
    
      const selectedApps = selectedItems.map(item => item.app);
      apps.forEach(app => {
        if (!selectedApps.includes(app)) {
          createAppElement(app, resultsContainer, containerType);
        }
      });
    } else {
      resultsContainer.innerHTML = "";
      createAppElement("App not found", resultsContainer, containerType);
      resultsContainer.style.display = "flex";
      setTimeout(() => {
        resultsContainer.classList.add('show');
        resultsContainer.style.opacity = "1";
        resultsContainer.style.transform = "translateY(0)";
      }, 10);
    }
  })
  .catch(error => {
    console.error("Error fetching data:", error);
  });
}

function createAppElement(app, container, containerType) {
  const div = document.createElement("div");
  div.classList.add("result-item");

  const isNotFound = app === "App not found";
  if (isNotFound) {
    div.classList.add("not-found-item");
    div.style.pointerEvents = "none";
    div.style.opacity = "0.6";
  }

  const checkbox = document.createElement("input");
  checkbox.type = "checkbox";
  checkbox.value = app;
  checkbox.id = `${containerType}-chk-${app}`;

  if (isNotFound) {
    checkbox.disabled = true;
    checkbox.style.pointerEvents = "none";
  }

  const label = document.createElement("label");
  label.setAttribute("for", `${containerType}-chk-${app}`);

  const labelText = document.createElement("span");
  labelText.textContent = app;
  label.appendChild(labelText);

  if (!isNotFound) {
    checkbox.addEventListener('change', function() {
      div.classList.toggle("active", this.checked);
      updateStartButtonState(containerType);
    });

    div.addEventListener('click', function(e) {
      if (e.target !== checkbox && e.target !== label) {
        checkbox.checked = !checkbox.checked;
        checkbox.dispatchEvent(new Event('change'));
      }
    });

    setupTextScrolling(label, labelText);
  }

  div.appendChild(checkbox);
  div.appendChild(label);
  container.appendChild(div);
}

function setupTextScrolling(label, labelText) {
  requestAnimationFrame(() => {
    const parentWidth = label.offsetWidth;
    const textWidth = labelText.scrollWidth;

    if (textWidth > parentWidth) {
      setTimeout(() => {
        startScrolling(labelText, parentWidth, textWidth);
      }, 3000);
    }
  });
}

function restoreEventHandlers(element, containerType) {
  const checkbox = element.querySelector('input');
  const div = checkbox.parentNode;

  const newCheckbox = checkbox.cloneNode(true);
  checkbox.replaceWith(newCheckbox);

  newCheckbox.checked = true;
  div.classList.add("active");

  newCheckbox.addEventListener('change', function () {
    div.classList.toggle("active", this.checked);
    updateStartButtonState(containerType);
  });

  div.addEventListener('click', function (e) {
    if (e.target !== newCheckbox && e.target !== div.querySelector('label')) {
      newCheckbox.checked = !newCheckbox.checked;
      newCheckbox.dispatchEvent(new Event('change'));
    }
  });

  const label = div.querySelector('label');
  const labelText = div.querySelector('span');
  setupTextScrolling(label, labelText);
}

function startScrolling(el, parentWidth, textWidth) {
  let start = null;
  let position = 0;
  const duration = 6000;

  function step(timestamp) {
    if (!start) start = timestamp;
    const progress = timestamp - start;

    position = -(progress / duration) * (textWidth - parentWidth);

    if (position <= -(textWidth - parentWidth)) {
      el.style.transform = `translateX(${-(textWidth - parentWidth)}px)`;
      setTimeout(() => {
        el.style.transform = 'translateX(0)';
        start = null;
        setTimeout(() => {
          requestAnimationFrame(step);
        }, 3000);
      }, 3000);
    } else {
      el.style.transform = `translateX(${position}px)`;
      requestAnimationFrame(step);
    }
  }

  requestAnimationFrame(step);
}

function updateStartButtonState(containerType) {
  const resultsContainer = document.querySelector(`.results-container-${containerType}`);
  const checkboxes = resultsContainer.querySelectorAll("input[type='checkbox']");
  const startButton = document.querySelector(`#${containerType}-container .start-button`);

  let hasValidApp = false;
  checkboxes.forEach(checkbox => {
    if (checkbox.checked && checkbox.value !== "App not found") {
      hasValidApp = true;
    }
  });

  startButton.disabled = !hasValidApp;
}

let swipeCount = 0;
let startY = 0;
let isCollapsed = false;
let lastSwipeTime = 0;

const container = document.querySelector(".container");
const thanksHTML = `
<div class="task-box" id="dex-optimizer-box">
  <p><b>${getTranslation('thankYou')}</b></p>
  <p>Yana<br>
    Трезва Бека Бухов<br>
    FarraforON<br>
    IGOR<br>
    CODEX_X<br>
    3ю<br>
    Demon in Invasion<br>
    Чумудан советский, 3 штука<br>
    Павел - FreddylllKrueger<br>
    Twiline<br>
    Антагонист<br>
    Владислав<br>
    Nikolay<br>
    Nikita<br>
    Роберт<br>
    need a lobotomy<br>
    Venlys<br>
    Evgehae ....<br>
    Mr. Stein<br>
    L1kvide<br>
    爱•sᴇɴᴘᴀɪシ</p>
</div>
`;

const expandButton = createElement('div', {
  textContent: "⚡⚡⚡",
  styles: {
    position: "absolute",
    top: "10px",
    left: "50%",
    transform: "translateX(-50%)",
    padding: "10px",
    borderRadius: "10px",
    background: "var(--secondary-color)",
    color: "#e0e0e0",
    fontSize: "14px",
    textAlign: "center",
    cursor: "pointer",
    opacity: "0",
    transition: "opacity 0.3s ease",
    display: "none"
  }
});

const thanksBlock = createElement('div', {
  innerHTML: thanksHTML,
  styles: {
    position: "absolute",
    top: "50px",
    left: "50%",
    transform: "translateX(-50%)",
    padding: "10px",
    borderRadius: "10px",
    color: "#fff",
    fontSize: "14px",
    textAlign: "center",
    display: "none"
  }
});

document.body.append(expandButton, thanksBlock);

const handleTouchStart = (e) => {
  if (e.touches.length !== 1) return;
  startY = e.touches[0].clientY;
};

const handleTouchMove = (e) => {
  if (e.touches.length !== 1) return;
  const endY = e.touches[0].clientY;
  if (startY - endY > 50) e.preventDefault();
};

const handleTouchEnd = (e) => {
  if (e.changedTouches.length !== 1) return;
  const endY = e.changedTouches[0].clientY;
  const deltaY = startY - endY;
  const currentTime = Date.now();

  if (!isCollapsed && deltaY > 50) {
    swipeCount = (currentTime - lastSwipeTime < 500) ? swipeCount + 1 : 1;
    lastSwipeTime = currentTime;

    if (swipeCount >= 2) {
      collapseContainer();
    }
  }
};

function collapseContainer() {
  container.style.willChange = 'opacity, height';
  container.style.transition = 'opacity 0.4s, height 0.4s';
  container.style.opacity = '0';
  container.style.height = '0';
  
  setTimeout(() => {
    container.style.display = 'none';
    expandButton.style.opacity = '1';
    expandButton.style.display = 'block';
    thanksBlock.style.display = 'block';
    container.style.willChange = 'auto';
  }, 400);
  
  isCollapsed = true;
  swipeCount = 0;
}

function expandContainer() {
  container.style.willChange = 'opacity, height';
  container.style.transition = 'opacity 0.4s, height 0.4s';
  container.style.opacity = '1';
  container.style.height = 'auto';
  container.style.display = 'block';
  
  expandButton.style.opacity = '0';
  thanksBlock.style.display = 'none';
  
  setTimeout(() => {
    expandButton.style.display = 'none';
    container.style.willChange = 'auto';
  }, 400);
  
  isCollapsed = false;
}

container.addEventListener('touchstart', handleTouchStart, { passive: false });
container.addEventListener('touchmove', handleTouchMove, { passive: false });
container.addEventListener('touchend', handleTouchEnd);
expandButton.addEventListener('click', expandContainer);

function createElement(tag, { textContent = '', innerHTML = '', styles = {} }) {
  const el = document.createElement(tag);
  if (textContent) el.textContent = textContent;
  if (innerHTML) el.innerHTML = innerHTML;
  Object.assign(el.style, styles);
  return el;
}

let clickTimeout;
let clickCount = 0;

document.getElementById('dex-optimizer-box').addEventListener('click', function () {
  clickCount++;
  this.classList.add('animate');

  if (clickCount === 1) {
    clickTimeout = setTimeout(function () {
      if (clickCount === 1) {
        window.location.href = 'https://github.com/zerxfox/DexOptimizer';
      }
      clickCount = 0;
    }, 300);
  } else if (clickCount === 2) {
    clearTimeout(clickTimeout);
    clickTimeout = setTimeout(function () {
      fetch('/dex_optimizer/check-update')
        .then(response => response.json())
        .then(data => {
          if (data.zip_url) {
            window.location.href = data.zip_url;
          }
        })
        .catch(error => console.error('Ошибка запроса:', error));
      clickCount = 0;
    }, 300);
  } else if (clickCount === 3) {
    clearTimeout(clickTimeout);
    if (!navigator.onLine) {
      showMessage(getTranslation('updateMsgError'));
    } else {
      showMessage(getTranslation('updateMsg'));
    }
    fetch('update.sh')
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
      })
      .catch(error => {
        showMessage(getTranslation('updateMsgError'));
        console.error('Error:', error.message);
      });
    clickCount = 0;
  }
});

function showMessage(text) {
  const msg = document.getElementById('info-message');
  msg.textContent = text;
  msg.style.opacity = '1';
  setTimeout(() => {
    msg.style.opacity = '0';
  }, 2500);
}

function updateSliderValue(slider) {
  const valueId = slider.id.replace('processes', 'sliderValue');
  const valueDisplay = document.getElementById(valueId);
  if (valueDisplay) {
    valueDisplay.textContent = slider.value;
  }
}

function setToggleGroup(groupName, selectedId, onSelect = null) {
  const buttons = document.querySelectorAll(`[data-group="${groupName}"]`);
  buttons.forEach(btn => {
    if (btn.id === selectedId) {
      btn.classList.add('active');
      btn.classList.remove('inactive');
    } else {
      btn.classList.remove('active');
      btn.classList.add('inactive');
    }
  });

  if (onSelect) onSelect();
}

function setMode(mode) {
  setToggleGroup('mode', mode === 'auto' ? 'autoBtn' : 'manualBtn', () => {
    toggleManualOptions(mode === 'manual');
  });
}

function setOptimization(value) {
  setToggleGroup('optimization', value === 'yes' ? 'yesBtn' : 'noBtn');
}

function setProfile(profile) {
  const id = profile === 'everything-profile' ? 'everythingProfileBtn' : 'speedProfileBtn';
  setToggleGroup('profile', id);
}

function setProfileContainer(profile) {
  const id = profile === 'everything-profile' ? 'profile-everythingProfileBtn' : 'profile-speedProfileBtn';
  setToggleGroup('profile-container', id);
}

function setAppsCompile(type) {
  const mapping = {
    user: 'userAppsBtn-compile',
    system: 'systemAppsBtn-compile',
    all: 'allAppsBtn-compile',
  };
  setToggleGroup('apps-compile', mapping[type]);
}

function setAppsClean(type) {
  const mapping = {
    user: 'userAppsBtn-clean',
    system: 'systemAppsBtn-clean',
    all: 'allAppsBtn-clean',
    selectively: 'selectivelyAppsBtn-clean'
  };

  const startButton = document.querySelector('#clean-container .start-button');

  if (type === 'selectively') {
    toggleAppSelection(true);
    startButton.disabled = true;
  } else {
    toggleAppSelection(false);
    startButton.disabled = false;
  }

  setToggleGroup('apps-clean', mapping[type]);
}

window.onload = function () {
  setMode('auto');
  setOptimization('yes');
  setProfile('everything-profile');
  setProfileContainer('everything-profile');
  setAppsCompile('user');
  setAppsClean('user');
  displayLastRunTime();
};

function saveLastRunTime() {
  const currentTime = new Date().toISOString();
  localStorage.setItem('lastRun', currentTime);
}

function getPluralForm(number, one, few, many) {
  const mod10 = number % 10;
  const mod100 = number % 100;
  
  if (mod10 === 1 && mod100 !== 11) {
      return one;
  } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
      return few;
  } else {
      return many;
  }
}

function displayLastRunTime() {
  const lang = getUserLanguage();
  document.getElementById('lastRunTimeLabel').textContent = getTranslation('lastRunTimeLabel');

  const lastRunTime = localStorage.getItem('lastRun');
  if (lastRunTime) {
    const lastRunDate = new Date(lastRunTime);
    const now = new Date();
    const diffInMilliseconds = now - lastRunDate;

    if (diffInMilliseconds < 60000) {
      document.getElementById('lastRunTime').textContent = getTranslation('lessThanMinuteAgo');
    } else {
      const diffInSeconds = Math.floor(diffInMilliseconds / 1000);
      const days = Math.floor(diffInSeconds / (60 * 60 * 24));
      const hours = Math.floor((diffInSeconds % (60 * 60 * 24)) / (60 * 60));
      const minutes = Math.floor((diffInSeconds % (60 * 60)) / 60);

      let timeString = '';
      if (days > 0) {
        const dayWord = getTranslation(days === 1 ? 'day' : days <= 4 ? 'dayFew' : 'dayMany');
        timeString = getTranslation('daysAgo', { days, daysWord: dayWord });
      } else if (hours > 0) {
        const hourWord = getTranslation(hours === 1 ? 'hour' : hours <= 4 ? 'hourFew' : 'hourMany');
        timeString = getTranslation('hoursAgo', { hours, hoursWord: hourWord });
      } else {
        const minuteWord = getTranslation(minutes === 1 ? 'minute' : minutes <= 4 ? 'minuteFew' : 'minuteMany');
        timeString = getTranslation('minutesAgo', { minutes, minutesWord: minuteWord });
      }

      document.getElementById('lastRunTime').innerHTML = timeString;
    }
  } else {
    document.getElementById('lastRunTime').textContent = getTranslation('never');
  }
}

displayLastRunTime();

document.querySelectorAll('.start-button').forEach(function(button) {
  button.addEventListener('click', function() {
    saveLastRunTime();
  });
});

const namesArray = {
  ru: [
    'солнце', 'звезда', 'облачко', 'феникс', 'котёнок', 'зайчонок', 'моряк', 'медвежонок', 'лосик', 'весельчак',
    'шалунишка', 'мечтатель', 'добряк', 'смешарик', 'ангелочек', 'дружок', 'смешинка', 'солнышко', 'песик', 'цветочек',
    'зефирка', 'крошка', 'золотко', 'котофей', 'смельчак', 'пёстрик', 'лучик', 'балунишка', 'радость', 'радужка'
  ],
  en: [
    'sun', 'star', 'cloud', 'phoenix', 'kitten', 'bunny', 'sailor', 'teddy', 'moose', 'cheerful',
    'mischief', 'dreamer', 'goodie', 'smiley', 'angel', 'buddy', 'giggle', 'sunbeam', 'puppy', 'flower',
    'marshmallow', 'crumb', 'golden', 'tomcat', 'brave', 'patch', 'ray', 'playful', 'joy', 'rainbow'
  ]
};

function getRandomName() {
  const lang = getUserLanguage();
  const randomIndex = Math.floor(Math.random() * namesArray[lang].length);
  return namesArray[lang][randomIndex];
}

function displayName() {
  let userName = localStorage.getItem('userName');
  if (!userName) { 
    userName = getRandomName();
    localStorage.setItem('userName', userName);
  }

  const greeting = getTranslation('greeting', { userName });

  document.querySelector('h1').innerHTML = greeting;
}

document.addEventListener('DOMContentLoaded', displayName);

let statsChartInstance = null; 

async function loadAndDrawStats() {
  const response = await fetch('/dex_optimizer/stats.txt');
  const text = await response.text();

  if (statsChartInstance) {
    statsChartInstance.destroy();
    statsChartInstance = null;
  }

  Chart.register(ChartZoom);

  const lines = text.trim().split('\n');
  const dataByType = {};

  lines.forEach(line => {
    const [date, type, duration] = line.split('|');
    if (!dataByType[type]) dataByType[type] = [];
    dataByType[type].push({ x: new Date(date), y: parseInt(duration, 10) });
  });

  const colors = {
    compile: 'rgba(75, 192, 192, 0.6)',
    clean: 'rgba(255, 159, 64, 0.6)',
    profile: 'rgba(255, 0, 0, 0.5)',
    default: 'rgba(100,100,100,0.6)'
  };

  const datasets = Object.keys(dataByType).map(type => ({
    label: type,
    data: dataByType[type],
    backgroundColor: colors[type] || colors.default,
    borderColor: colors[type] || colors.default.replace('0.6', '1'),
    borderWidth: 2,
    pointRadius: 3,
    fill: false,
    tension: 0.1 
  }));

  const ctx = document.getElementById('statsChart').getContext('2d');
  statsChartInstance = new Chart(ctx, {
    type: 'line',
    data: { datasets },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: {
          type: 'time',
          time: {
            unit: 'hour',
            tooltipFormat: 'yyyy-MM-dd HH:mm',
            displayFormats: { 
              hour: 'yyyy-MM-dd HH:mm',
              day: 'yyyy-MM-dd HH:mm'
            }
          },          
          title: {
            display: true,
            text: getTranslation('textDate'),
            color: 'white'
          },
          ticks: {
            color: 'white',
            maxRotation: 45,
            minRotation: 30,
            autoSkip: true,
            autoSkipPadding: 20,
            maxTicksLimit: 12 
          },
          grid: {
            display: true,
            color: 'rgba(255,255,255,0.3)', 
            borderColor: 'rgba(255,255,255,0.3)',
            lineWidth: 0.5,
            drawTicks: false
          }
        },
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: getTranslation('textTime'),
            color: 'white'
          },
          ticks: {
            color: 'white',
            stepSize: 100,
            min: 0,
            maxTicksLimit: 8 
          },
          grid: {
            display: true,
            color: 'rgba(255,255,255,0.4)',
            borderColor: 'rgba(255,255,255,0.4)',
            lineWidth: 0.5,
            drawTicks: false
          }
        }
      },
      plugins: {
        legend: { 
          position: 'bottom',
          labels: { 
            color: 'white',
            boxWidth: 12,
            padding: 20,
            font: {
              size: 12
            }
          }
        },
        tooltip: { 
          titleColor: 'white', 
          bodyColor: 'white',
          displayColors: true,
          usePointStyle: true
        },
        zoom: {
          pan:  { enabled: true, mode: 'xy' },
          zoom: { wheel: { enabled: true }, pinch: { enabled: true }, mode: 'xy' }
        }
      },
      layout: {
        padding: {
          top: 20,
          bottom: 60
        }
      }
    }
  });
}

document.addEventListener('DOMContentLoaded', () => {
  const statsChart = document.getElementById('statsChart');
  statsChart.style.height = '500px';

  const stats = document.getElementById('stats-container');
  if (stats?.style.display !== 'none') {
    loadAndDrawStats();
  }

  const observer = new MutationObserver(() => {
    if (stats?.style.display !== 'none') loadAndDrawStats();
  });
  observer.observe(stats, { attributes: true, attributeFilter: ['style'] });
});

function getUserLanguage() {
  const userLang = navigator.language || navigator.userLanguage;
  return userLang.startsWith('ru') ? 'ru' : 'en';
}

function getTranslation(key, params = {}) {
  const lang = getUserLanguage();
  let translation = translations[lang][key] || translations['en'][key];
  if (params) {
    for (const param in params) {
      translation = translation.replace(`{${param}}`, params[param]);
    }
  }
  return translation;
}

function updateMenu() {
  const lang = getUserLanguage();
  document.querySelectorAll('h2')[1].textContent = getTranslation('menu');

  document.querySelector('.item-1').innerHTML = `⚡️<br>${getTranslation('compile')}`;
  document.querySelector('.item-2').innerHTML = `🗑<br>${getTranslation('clean')}`;
  document.querySelector('.item-3').innerHTML = `🗳<br>${getTranslation('profileLabel')}`;
  document.querySelector('.item-4').innerHTML = `📈<br>${getTranslation('stats')}`;

  document.querySelector('#compile-container h2 b').textContent = getTranslation('compile');
  document.querySelector('#clean-container h2 b').textContent = getTranslation('clean');
  document.querySelector('#profile-container h2 b').textContent = getTranslation('profileLabel');
  document.querySelector('#stats-container h2 b').textContent = getTranslation('stats');
  document.querySelector('#donate-container h2 b').textContent = getTranslation('donate');

  document.querySelectorAll('#compile-container legend')[0].textContent = getTranslation('settings');
  document.querySelectorAll('#compile-container legend')[1].textContent = getTranslation('parameters');
  document.querySelectorAll('#compile-container legend')[2].textContent = getTranslation('additional');
  
  document.querySelector('#clean-container legend').textContent = getTranslation('settings');
  document.querySelector('#profile-container legend').textContent = getTranslation('parameters');
  document.querySelector('#app-selection-container legend').textContent = getTranslation('appsLabel');

  document.getElementById('autoBtn').textContent = getTranslation('auto');
  document.getElementById('manualBtn').textContent = getTranslation('manual');

  document.getElementById('userAppsBtn-compile').textContent = getTranslation('user');
  document.getElementById('systemAppsBtn-compile').textContent = getTranslation('system');
  document.getElementById('allAppsBtn-compile').textContent = getTranslation('all');
  
  document.getElementById('userAppsBtn-clean').textContent = getTranslation('user');
  document.getElementById('systemAppsBtn-clean').textContent = getTranslation('system');
  document.getElementById('allAppsBtn-clean').textContent = getTranslation('all');
  document.getElementById('selectivelyAppsBtn-clean').textContent = getTranslation('selectively');

  document.getElementById('yesBtn').textContent = getTranslation('yes');
  document.getElementById('noBtn').textContent = getTranslation('no');

  document.querySelector('#compile-container label[for="mode"]').textContent = getTranslation('parametersLabel');
  document.querySelector('#compile-container label[for="processes-compile"]').childNodes[0].nodeValue = getTranslation('processes');

  document.querySelector('#compile-container label[for="dex-optimization"]').textContent = getTranslation('optimization');
  document.querySelector('#clean-container label[for="processes-clean"]').childNodes[0].nodeValue = getTranslation('processes');

  document.querySelector('#compile-container .start-button').textContent = getTranslation('start');
  document.querySelector('#clean-container .start-button').textContent = getTranslation('start');
  document.querySelector('#profile-container .start-button').textContent = getTranslation('start');

  document.querySelector('#compile-container label[for="apps"]').textContent = getTranslation('apps');
  document.querySelector('#compile-container label[for="profile"]').textContent = getTranslation('profile');

  document.querySelector('#clean-container label[for="app"]').textContent = getTranslation('apps');
  document.querySelector('#clean-container label[for="app-name-clean"]').textContent = getTranslation('appName');

  document.querySelector('#profile-container label[for="profile"]').textContent = getTranslation('profile');
  document.querySelector('#profile-container label[for="app-name"]').textContent = getTranslation('appName');
  document.querySelectorAll('#profile-container legend')[1].textContent = getTranslation('appsLabel');

  document.getElementById('app-name-clean').placeholder = getTranslation('enterAppName');
  document.getElementById('app-name-profile').placeholder = getTranslation('enterAppName');
}
updateMenu();

document.getElementById('tgWalletBtn').addEventListener('click', function() {
  const textToCopy = "UQAgcSOHQKe2lZHJ1_kJNcUrEeHeTlFoL7YmF51F06j6ELfc";
  const button = this;
  
  const textarea = document.createElement('textarea');
  textarea.value = textToCopy;
  textarea.style.position = 'fixed';
  textarea.style.opacity = 0;
  document.body.appendChild(textarea);
  
  textarea.select();
  try {
    const successful = document.execCommand('copy');
    if (successful) {
      const originalHtml = button.innerHTML;
      button.innerHTML = `
        <svg class="tg-icon" width="20" height="20" viewBox="0 0 24 24" fill="none">
          <path d="M9 12L11 14L15 10" stroke="white" stroke-width="2"/>
        </svg>
        ${getTranslation('copyLabel')}
      `;
      setTimeout(() => {
        button.innerHTML = originalHtml;
      }, 2000);
    }
  } catch (err) {
    console.error('Не удалось скопировать:', err);
  } finally {
    document.body.removeChild(textarea);
  }
});

document.getElementById('yoomoneyBtn').addEventListener('click', function() {
  window.open('https://yoomoney.ru/to/410015528696708', '_blank', 'noopener,noreferrer');
});

let pressTimer;
document.getElementById('stats-box').addEventListener('mousedown', function(e) {
  pressTimer = setTimeout(async () => {
    try {
      const response = await fetch('/dex_optimizer/clear_stats', { 
        method: 'POST' 
      });
            
      if (!response.ok) throw new Error('Ошибка сервера');
            
      this.style.backgroundColor = '#4CAF50';
      
      const statsContainer = document.getElementById('chartContainer');
      if (statsContainer) {
        statsContainer.classList.remove('fade-in-up');
        statsContainer.classList.add('fade-out-down');

        setTimeout(() => {
          statsContainer.style.display = 'none';

          if (typeof loadAndDrawStats === 'function') {
            loadAndDrawStats().then(() => {
              statsContainer.style.display = 'block';
              requestAnimationFrame(() => {
                statsContainer.classList.remove('fade-out-down');
                statsContainer.classList.add('fade-in-up');
              });
            });
          } else {
            statsContainer.style.display = 'block';
            requestAnimationFrame(() => {
              statsContainer.classList.remove('fade-out-down');
              statsContainer.classList.add('fade-in-up');
            });
          }
        }, 300);
      }

      setTimeout(() => this.style.backgroundColor = '', 500);
            
      if (typeof loadAndDrawStats === 'function' && 
      document.getElementById('stats-container')?.style.display !== 'none') {
        loadAndDrawStats();
      }
    } catch (error) {
      console.error('Ошибка:', error);
      this.style.backgroundColor = '#ff4444';
      setTimeout(() => this.style.backgroundColor = '', 500);
    }
  }, 800);
});

document.getElementById('stats-box').addEventListener('mouseup', function() {
  clearTimeout(pressTimer);
});

document.getElementById('stats-box').addEventListener('mouseleave', function() {
  clearTimeout(pressTimer);
});

document.getElementById('stats-box').addEventListener('touchstart', function(e) {
    pressTimer = setTimeout(() => {
      e.preventDefault();
      this.dispatchEvent(new Event('mousedown'));
  }, 800);
});

document.getElementById('stats-box').addEventListener('touchend', function() {
  clearTimeout(pressTimer);
});

let wakeLock = null;
async function enableScreenLock() {
    try {
        if ('wakeLock' in navigator) {
            wakeLock = await navigator.wakeLock.request('screen');
            console.log('Экран не будет блокироваться!');
            
            wakeLock.addEventListener('release', () => {
                console.log('Экран снова может блокироваться');
            });
        } else {
            console.warn('Wake Lock не поддерживается');
            tryNoSleepFallback();
        }
    } catch (err) {
        console.error('Ошибка Wake Lock:', err);
        tryNoSleepFallback();
    }
}
enableScreenLock();

document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible' && !wakeLock) {
        enableScreenLock();
    }
});