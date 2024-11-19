/*Increasing cappuccino prices by 20%.*/
BEGIN;

SELECT *
FROM cafe.restaurants
WHERE menu -> 'Кофе' ? 'Капучино' 
FOR NO KEY UPDATE;
/* блокировка необходимых строк по условию menu -> 'Кофе' ? 'Капучино', 
 * а не через type = coffee_shop, так как предполагаю, что в других типах 
 * ресторанов тоже может подаваться капучино. (Хотя в сырых данных капучино 
 * продаётся только в кофейнях.)*/

WITH cappuccino_prices AS (
    SELECT restaurant_uuid, 
           to_jsonb((menu #>> '{Кофе, Капучино}')::numeric * 1.2) AS price
    FROM cafe.restaurants
    WHERE menu -> 'Кофе' ? 'Капучино'
)
UPDATE cafe.restaurants AS r
SET menu = jsonb_set(menu, '{Кофе, Капучино}', price)
FROM cappuccino_prices AS cp
WHERE r.restaurant_uuid = cp.restaurant_uuid;

COMMIT;

/*Так как изменяются только определенные строки таблицы, которые содержат в 
 * меню "Капучино", то необходимо использовать блокровку строк. Также необходимо, чтоб 
 * никто не имел доступ к старым ценам и не имел возможности читать и изменять их. 
 * Внешние ключи при этом не меняются. Для данных условий наиболее оптимально подходит 
 * тип блокировки строк FOR NO KEY UPDATE.*/