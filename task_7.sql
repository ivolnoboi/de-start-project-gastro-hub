/*Adding a new phone number using a template.*/
BEGIN;
LOCK TABLE cafe.managers IN EXCLUSIVE MODE;
ALTER TABLE cafe.managers ADD COLUMN phones varchar[];

WITH phones_tmp AS (
    SELECT manager_uuid,
           '8-800-2500-' || ROW_NUMBER() OVER(ORDER BY name) + 99 AS new_phone
    FROM cafe.managers
)
UPDATE cafe.managers m
SET phones = ARRAY[pt.new_phone, m.phone]
FROM phones_tmp pt
WHERE m.manager_uuid = pt.manager_uuid;

ALTER TABLE cafe.managers DROP COLUMN phone;
COMMIT;

/*Таблица managers должна быть недоступна для изменений со стороны других 
 * пользователей, но доступна для чтения. Поэтому необходимо наложить блокировку 
 * на всю таблицу. Под данные условия подходит блокировка таблиц EXCLUSIVE, так как
 * она запрещает редактировать данные другим транзакциям, но при этом разрешает их 
 * читать.*/
