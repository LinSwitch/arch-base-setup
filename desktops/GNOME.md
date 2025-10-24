# GNOME на Arch Linux: установка и базовая настройка

## Содержание
- [1. Быстрый старт](#1-быстрый-старт)  
- [2. Установка GNOME](#2-установка-gnome)  
- [3. Дополнительные пакеты](#3-дополнительные-пакеты)  
- [4. Интеграция с браузером](#4-интеграция-с-браузером)  
- [5. Extension Manager (GUI-альтернатива)](#5-extension-manager-gui-альтернатива)  
- [6. Отключение проблемных расширений](#6-отключение-проблемных-расширений)  
- [7. Примечания](#7-примечания)
- [8. Расширения](#8-расширения)

---

## 1. Быстрый страт
Краткий путь: установить GNOME, подключить менеджер расширений, настроить базовые параметры.

---

## 2. Установка GNOME
```bash
sudo pacman -Syu
sudo pacman -S --needed gnome
sudo systemctl enable gdm --now
```
После перезагрузки вход выполняется через экран GDM.

---

## 3. Дополнительные пакеты
Рекомендуемый минимум без мета-пакета `gnome-extra`:
```bash
sudo pacman -S --needed file-roller gnome-tweaks dconf-editor gnome-boxes
```
Описания:
- `file-roller` — архиватор в контекстном меню Nautilus  
- `gnome-tweaks` — темы, иконки, автозапуск  
- `dconf-editor` — низкоуровневые параметры  
- `gnome-boxes` — запуск виртуальных машин  

При необходимости можно установить полный набор:
```bash
sudo pacman -S --needed gnome-extra
```

---

## 4. Интеграция с браузером
Сайт [extensions.gnome.org](https://extensions.gnome.org) требует нативного коннектора:
```bash
sudo pacman -S --needed gnome-browser-connector
```
Браузерные дополнения:  
- Chromium/Edge: [Chrome Web Store](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep)  
- Firefox: [AMO](https://addons.mozilla.org/firefox/addon/gnome-shell-integration/)  

После установки на странице расширений появится переключатель «ON/OFF».

---

## 5. Extension Manager (GUI-альтернатива)
Установка из AUR:
```bash
yay -S --needed extension-manager
# или без хелпера:
git clone https://aur.archlinux.org/extension-manager.git /tmp/ext-mgr
cd /tmp/ext-mgr && makepkg -si --noconfirm
```
Extension Manager позволяет искать, устанавливать и удалять расширения без браузера.

---

## 6. Отключение проблемных расширений
Если сессия не загружается:
1. Переключиться на TTY: `Ctrl+Alt+F3`  
2. Выполнить вход и отключить расширение:
   ```bash
   gnome-extensions list
   gnome-extensions disable <UUID>
   ```
3. Вернуться в графику: `Ctrl+Alt+F1` или `Ctrl+Alt+F2`

Для быстрого «сброса» всех расширений:
```bash
gsettings reset-recursively org.gnome.shell
```

---

## 7. Примечания
- `gnome-software` работает только с Flatpak; системные пакеты устанавливаются через `pacman`/`paru`.  
- GUI-менеджер Pamac доступен из AUR, но может конфликтовать с системой обновлений.  
- Расширения обновляются автоматически, однако после крупных релизов GNOME требуется ручная проверка совместимости.
---
### Установка Pamac (опционально)
Графический менеджер пакетов из экосистемы Manjaro.  
Может перехватывать блокировку `/var/lib/pacman/db.lck` и мешать одновременному запуску `pacman`.
```bash
# GUI + AUR (наиболее популярен)
yay -S --needed pamac-aur

# GUI + AUR + Snap + Flatpak + AppIndicator (полный набор)
yay -S --needed pamac-all

# Только CLI-интерфейс
yay -S --needed pamac-cli
```
Сборка вручную (если нет AUR-хелпера):
```bash
git clone https://aur.archlinux.org/pamac-aur.git /tmp/pamac
cd /tmp/pamac && makepkg -si --noconfirm
```
При ошибке «unable to lock database» закройте Pamac и выполните:
```bash
sudo rm -f /var/lib/pacman/db.lck
```
Рекомендация: использовать один инструмент за сессию — либо Pamac, либо pacman/paru, чтобы избежать конфликтов.

---

## 8. Расширения
Активные в GNOME 49

- Arch Linux Updates Indicator — счётчик обновлений
- Vitals — температура, загрузка, память в панели
- User Themes — переключаем пользовательские темы
- Just Perfection — «всё в одном» для внешнего вида
- Gtk4 Desktop Icons NG — иконки на рабочем столе
- Dash to Dock — превращает Dash в полноценную док-панель
- Dash to Panel — объединяет верхнюю панель и Dash (Windows-подобный вид)
- Apps menu — классическое меню приложений
- ArcMenu — кнопка «Пуск» в панель
- Caffeine — блокирует сон и блокировку экрана
- Compiz Alike Magic Lamp Effect — эффект «лампы» при сворачивании
- Compiz Windows Effect — плавные анимации окон
- Clipboard Indicator — история буфера обмена
- AppIndicator and KStatusNotifierItem Support — трей-иконки Telegram, Discord и др.
- Auto Move Windows — автоматически раскладывает окна по столам
- DDTerm — выпадающий терминал с вкладками
- Top Bar Organizer — зоны и сортировка значков
- Dash2Dock Animated — анимация иконок в доке

Ожидают обновления под GNOME 49

- Blur My Shell — размытие фона
- Gnome Fuzzy App Search — поиск с ошибками
- Quick Settings Tweaks — тонкая настройка быстрого меню
- Forge — тайлинг-менеджер в GNOME

