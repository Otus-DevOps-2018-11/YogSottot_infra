#!/usr/bin/env bash

cd /home/appuser

# Копируем код приложения
git clone -b monolith https://github.com/express42/reddit.git

# Переходим в директорию проекта и устанавливаем зависимости приложения:
cd reddit
bundle install

# Запускаем сервер приложения в директории проекта:
puma -d
