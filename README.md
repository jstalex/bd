**Вариант:** 35ee7b3d-ee96-455d-9a11-c9307cc49252

Импорт данных делал через DBeaver

Не удалось заполнить пропуски в колонках с платежами, поэтому оставил их. Также есть немного пропусков в mileage.

Исходные данные в таблице `car_service`

Далее для каждой сущности в своем файле запросы для заполнения проблелов и перенос в отдельную таблицу.

В итоге главная таблица `orders` ссылается на таблицы с пользователями, машинами и тд.

В самую последнюю очердь создал файл `additional.sql` с доп заданиями 