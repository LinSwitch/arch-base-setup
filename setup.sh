#!/usr/bin/env bash

# Подключаем функции и проверяем права
source "$(dirname "$0")/scripts/00-functions.sh"
check_root

# Обработка аргументов командной строки
show_help() {
    echo "Использование: $0 [--all|--help]"
    echo "  --all, -a    Запустить все скрипты автоматически"
    echo "  --help, -h   Показать эту справку"
}

# Функция запуска скриптов
run_script() {
    local script="$1"
    local base_dir="$(dirname "$0")"
    local script_path="$base_dir/scripts/$script"
    if [[ -f "$script_path" ]]; then
        log_info "Запуск: $script..."
        bash "$script_path"
    else
        log_error "Скрипт $script не найден!"
        return 1
    fi
}

# Функция полной установки
full_setup() {
    log_info "Запуск полной настройки системы..."
    for script_path in "$(dirname "$0")"/scripts/0[1-9]-*.sh; do
        run_script "$(basename "$script_path")"
    done
}

if [[ $# -gt 0 ]]; then
    case $1 in
        "--all"|"-a")
            full_setup
            exit 0
            ;;
        "--help"|"-h")
            show_help  
            exit 0
            ;;
        *)
            show_help  
            log_error "Неизвестный аргумент: $1"
            ;;
    esac
fi

# Меню
show_menu() {
    echo -e "${YELLOW}
    Arch Linux Post-Install Setup
    =============================${NC}"
    echo "1) Обновить зеркала (Reflector)"
    echo "2) Установить основные пакеты"
    echo "3) Установить AUR helper"
    echo "4) Настроить таймзону"
    echo "5) Настроить TRIM (SSD)"
    echo "6) Полная настройка (пункты 1-5)"
    echo "7) Выйти"
}

# Основной цикл
while true; do
    show_menu
    read -rp "Выберите вариант [1-7]: " -n 1 choice
    
    case $choice in
        1) run_script "01-reflector.sh" ;;
        2) run_script "02-packages.sh" ;;
        3) run_script "03-aur-helper.sh" ;;
        4) run_script "04-timezone.sh" ;;
        5) run_script "05-trim.sh" ;;
        6) full_setup ;;  
        7) echo ""
           exit 0 ;;
        *) log_warn "Неверный выбор!" ;;
    esac
    
    echo
done
