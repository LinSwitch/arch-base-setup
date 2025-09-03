#!/usr/bin/env bash
source "$(dirname "$0")/00-functions.sh"

log_info "Устанавливаем базовые пакеты..."

pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
  base-devel git cat htop man-db man-pages openssh curl wget pacman-contrib || die "Не удалось установить" 

log_info "Установка пакетов завершена"
