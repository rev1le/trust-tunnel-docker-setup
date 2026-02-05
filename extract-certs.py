import base64
import json
import os
import sys

if len(sys.argv) != 2:
    print("Использование: python extract_cert.py /путь/к/acme.json")
    sys.exit(1)

filepath = sys.argv[1]
try:
    with open(filepath, "r") as f:
        data = json.load(f)
except Exception as e:
    print(f"Ошибка чтения файла: {e}")
    sys.exit(1)

if "Certificates" not in data or not data["Certificates"]:
    print("В файле не найдено записей о сертификатах.")
    sys.exit(1)

print("Найдены сертификаты для доменов:")
for i, cert in enumerate(data["Certificates"]):
    main_domain = cert.get("domain", {}).get("main", "N/A")
    sans = cert.get("domain", {}).get("sans", [])
    print(f"[{i}] Основной домен: {main_domain}, SANs: {', '.join(sans)}")

try:
    choice = int(input("\nВведите номер сертификата для извлечения: "))
    selected = data["Certificates"][choice]
except (ValueError, IndexError):
    print("Неверный выбор.")
    sys.exit(1)

# Декодирование и сохранение
try:
    cert_decoded = base64.b64decode(selected["certificate"]).decode("utf-8")
    key_decoded = base64.b64decode(selected["key"]).decode("utf-8")

    with open("./certs/cert.pem", "w") as f:
        f.write(cert_decoded)
    with open("./certs/key.pem", "w") as f:
        f.write(key_decoded)

    print(f"\n✅ Успешно! Файлы сохранены:\n   cert.pem\n   key.pem")
except KeyError as e:
    print(f"В структуре JSON отсутствует ожидаемое поле: {e}")
except Exception as e:
    print(f"Ошибка декодирования/сохранения: {e}")
