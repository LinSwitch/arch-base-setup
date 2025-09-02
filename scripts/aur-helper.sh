#!/bin/bash

source "$(dirname "$0")/00-functions.sh"

# Функция с повторами
git_clone_retry() {
    local url="$1" dir="$2"
    for attempt in {1..3}; do
        if git clone "$url" "$dir"; then
            return 0
        fi
        log_warn "Попытка $attempt не удалась, ждём 5 секунд..."
        sleep 5
    done
    return 1
}

# Основной код
log_info "Выберите AUR helper:"
select chosen_helper in paru yay; do
    [[ -n "$chosen_helper" ]] && break
done

work_dir=$(mktemp -d)
log_info "Временная папка $work_dir"

if ! git_clone_retry "https://aur.archlinux.org/$chosen_helper.git" "$work_dir"; then
    log_error "Не удалось клонировать $chosen_helper после нескольких попыток"
    exit 1
fi

(cd "$work_dir" && makepkg -si --noconfirm)
rm -rf "$work_dir"

log_info "AUR helper $chosen_helper успешно установлен!"
