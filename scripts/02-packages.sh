#!/usr/bin/env bash
source "$(dirname "$0")/00-functions.sh"

log_info "Устанавливаем базовые пакеты..."

sudo pacman -Syu --noconfirm --needed \
  base-devel git sudo man-db man-pages openssh curl wget pacman-contrib || log_error "Не удалось установить" 

log_info "Установка пакетов завершена"
