#!/usr/bin/env bash
source "$(dirname "$0")/00-functions.sh"

log_info "Обновление зеркал с помощью reflector..."
pacman -Sy --needed reflector || log_error "Не удалось установить reflector"
success=false
for attempt in {1..3}; do
	if reflector \
	  --country Finland,Germany,Netherlands,Switzerland,France,Poland,Czechia,Austria \
	  --protocol https \
	  --age 6 \
	  --sort rate \
	  --latest 5 \
	  --verbose \
	  --save /etc/pacman.d/mirrorlist; then
	  success=true
	  log_info "Зеркала успешно обновлены!"
	  break
	fi
	log_warn "Попытка $attempt не удалась"
	if [[ $attempt -lt 3 ]]; then
        log_info "Ждём 5 секунд перед повторной попыткой..."
        sleep 5
    fi
done
if [[ $success != true ]]; then
    log_warn "Не удалось обновить зеркала после $attempt попыток"
    log_info "Продолжаем работу со старыми зеркалами"
fi
