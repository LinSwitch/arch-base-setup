#!/usr/bin/env bash

source "$(dirname "$0")/00-functions.sh"

log_info "Включаем fstrim.timer..."
sudo systemctl enable --now fstrim.timer || log_error "Не удалось включить fstrim.timer"

log_info "Статус strim.timer: $(systemctl is-active fstrim.timer)"
log_info "Автозагрузка strim.timer: $(systemctl is-enabled fstrim.timer)"
