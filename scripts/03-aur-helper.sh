#!/bin/bash

source "$(dirname "$0")/00-functions.sh"

# Функция с повторами
git_clone_retry() {
    local url="$1" dir="$2"
    for attempt in {1..3}; do
        log_info "Попытка $attempt из 3..."
        if git clone "$url" "$dir"; then
            return 0
        fi
        log_warn "Попытка $attempt не удалась"
        if [[ $attempt -lt 3 ]]; then
            log_info "Ждём 5 секунд перед повторной попыткой..."
            sleep 5
        fi
    done
    return 1
}

# Основной код
log_info "Выберите AUR helper:"
select chosen_helper in paru yay; do
    [[ -n "$chosen_helper" ]] && break
    log_warn "Неверный выбор. Попробуйте ещё раз."
done

work_dir=$(mktemp -d) || die "Не удалось создать временную директорию"

# Гарантированная очистка при любом сценарии
trap 'rm -rf "$work_dir"' EXIT INT TERM

log_info "Клонируем $chosen_helper..."

if ! git_clone_retry "https://aur.archlinux.org/$chosen_helper.git" "$work_dir"; then
    die "Не удалось клонировать $chosen_helper после 3 попыток"
fi

log_info "Собираем и устанавливаем $chosen_helper..."
if sudo -u "$SUDO_USER" bash -c "cd '$work_dir' && makepkg -si --noconfirm"; then
    log_info "$chosen_helper успешно установлен!"
else
    die "Не удалось установить $chosen_helper"
fi

# Явное удаление (trap подстрахует на случай ошибок выше)
rm -rf "$work_dir"
trap - EXIT INT TERM  # Снимаем trap после успешного завершения

log_info "AUR helper $chosen_helper успешно установлен!"