import os
from pyicloud import PyiCloudAPI
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time

# Авторизация в iCloud
def authenticate():
    try:
        # Пытаемся загрузить сессию из файла
        with open('icloud_session.pkl', 'rb') as f:
            api = pickle.load(f)
            print("Сессия загружена.")
    except (FileNotFoundError, pickle.UnpicklingError):
        # Если нет сохраненной сессии, создаем новую
        api = PyiCloudAPI('your_icloud_email', 'your_icloud_password')
        if api.requires_2fa:
            code = input("Введите код двухфакторной аутентификации: ")
            api.validate_2fa_code(code)
        with open('icloud_session.pkl', 'wb') as f:
            pickle.dump(api, f)
            print("Сессия сохранена.")
    
    return api

# Создание заметки в iCloud
def create_note(api, title, body):
    note = api.notes.create(title, body)
    print(f"Заметка {note.title} синхронизирована с iCloud.")
    return note

# Синхронизация локальных изменений
class NoteHandler(FileSystemEventHandler):
    def __init__(self, api, notes_path):
        self.api = api
        self.notes_path = notes_path

    def on_modified(self, event):
        if event.src_path.endswith(".txt"):  # Если изменился текстовый файл
            note_title = os.path.basename(event.src_path)  # Название файла - заголовок заметки
            with open(event.src_path, 'r', encoding='utf-8') as file:
                note_body = file.read()  # Тело заметки
                # Создаем или обновляем заметку в iCloud
                create_note(self.api, note_title, note_body)

if __name__ == "__main__":
    # Путь к папке с локальными заметками
    path_to_watch = "/path/to/your/notes"  # Укажите путь к вашей папке с заметками

    # Авторизация
    api = authenticate()

    # Настроим наблюдатель для синхронизации файлов
    event_handler = NoteHandler(api, path_to_watch)
    observer = Observer()
    observer.schedule(event_handler, path=path_to_watch, recursive=False)
    observer.start()

    print("Начинаю синхронизацию заметок. Нажмите Ctrl+C для остановки.")

    try:
        while True:
            time.sleep(1)  # Ожидаем изменений
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
