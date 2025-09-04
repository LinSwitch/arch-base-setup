#!/usr/bin/env bash

source "$(dirname "$0")/00-functions.sh"

main() {
    log_info "Настройка таймзоны..."
    
    while true; do
        # Пробуем автоопределение
        if tz=$(curl -s --connect-timeout 3 https://ipapi.co/timezone 2>/dev/null) && [[ -n "$tz" ]]; then
            if [[ "$tz" =~ ^[A-Z][a-z]+/[A-Z][a-zA-Z_/]+$ ]]; then
                log_info "Автоопределение: $tz"
            else
                log_warn "Сервер вернул некорректный формат таймзоны: $tz"
                log_info "переходим к ручному выбору..."
                break

            fi
            read -rp "Использовать эту таймзону? [Y/n]: " -n 1 
            echo
            case $REPLY in
                [Yy]|"")
                    timedatectl set-timezone "$tz"
                    log_info "Таймзона установлена: $tz"
                    timedatectl set-ntp true
                    log_info "Синхронизация времени включена"
                    return 0
                    ;;
                [Nn])
                    log_info "переходим к ручному выбору..."
                    break
                    ;;
                *)  
                    log_warn "Неверный выбор, попробуйте ещё раз"
                    ;;
            esac
        else
            log_warn "Автоопределение не удалось"
            break
        fi
    done

    # Если автоопределение не сработало или пользователь выбрал ручной ввод
    log_info "Запуск ручного выбора таймзоны..."
    log_info "Определяем смещение Москвы..."
        
    local moscow_offset sign hh mm moscow_minutes
    moscow_offset=$(TZ="Europe/Moscow" date +%z)
    sign=${moscow_offset:0:1}
    hh=${moscow_offset:1:2}
    mm=${moscow_offset:3:2}
    moscow_minutes=$((10#$hh*60 + 10#$mm))
    [[ "$sign" = "-" ]] && moscow_minutes=$((-moscow_minutes))

    log_info "Текущее смещение Москвы от UTC: ${moscow_offset}"

    local diff
    read -r -p "На сколько часов ваш город отличается от Москвы? (пример: -2 | 3 | 2.5 | 2:30 | 2,5) " diff

    # Преобразование ввода в минуты
    diff=${diff/,/.}
    local diff_minutes=0
    if [[ "$diff" =~ : ]]; then
        local dsign="" dh dm
        [[ "$diff" == -* ]] && dsign="-" && diff="${diff:1}"
        dh=${diff%%:*}; dm=${diff##*:}
        [[ -z "$dh" ]] && dh=0; [[ -z "$dm" ]] && dm=0
        diff_minutes=$((10#$dh*60 + 10#$dm))
        [[ -n "$dsign" ]] && diff_minutes=$((-diff_minutes))
    else
        diff_minutes=$(awk -v d="$diff" 'BEGIN{
            if (d+0 == d) printf("%d", d*60)
            else print 0
        }')
    fi

    local target_minutes=$((moscow_minutes + diff_minutes))
    local abs=$(( target_minutes<0 ? -target_minutes : target_minutes ))
    local th=$(( abs / 60 )) tm=$(( abs % 60 ))
    local target_offset
    printf -v target_offset "%s%02d%02d" "$([ $target_minutes -lt 0 ] && echo - || echo +)" "$th" "$tm"

    log_info "Ищем таймзоны со смещением UTC${target_offset}..."

    local zones=() tz offset
    while IFS= read -r tz; do
        offset=$(TZ="$tz" date +%z)
        [[ "$offset" = "$target_offset" ]] && zones+=("${tz} (${offset})")
    done < <(timedatectl list-timezones)

    [[ ${#zones[@]} -eq 0 ]] && log_error "Не найдено таймзон" && return 1

    if [[ ${#zones[@]} -eq 1 ]]; then
        local city="${zones[0]%% *}"
        timedatectl set-timezone "$city"
        log_info "Таймзона установлена: $city"
        timedatectl set-ntp true
        log_info "Синхронизация времени включена"
        return 0
    fi

    log_info "Выберите свой город:"
    select choice in "${zones[@]}"; do
        [[ -n "$choice" ]] && break
    done

    [[ -z "$choice" ]] && { log_warn "Выбор отменён"; return 1; }
    
    local city="${choice%% *}"
    timedatectl set-timezone "$city"
    log_info "Таймзона установлена: $city"
    timedatectl set-ntp true
    log_info "Синхронизация времени включена"
}

main "$@"
