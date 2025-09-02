#!/bin/bash
source "$(dirname "$0")/00-functions.sh"

log_info "Обновление зеркал с помощью reflector..."
pacman -Sy --needed reflector || log_error "Не удалось установить reflector"
reflector \
  --country Finland,Germany,Netherlands,Switzerland \
  --protocol https \
  --age 6 \
  --sort rate \
  --latest 5 \
  --verbose \
  --save /etc/pacman.d/mirrorlist
 
log_info "Зеркала успешно обновлены!"
