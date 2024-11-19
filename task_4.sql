/*The pizzeria with the largest number of pizzas on the menu.*/
WITH count_rank AS (
    SELECT p.name AS name, 
           COUNT(p.pizza_name) AS count, 
           DENSE_RANK() OVER (ORDER BY COUNT(p.pizza_name) DESC) AS rank
    FROM (SELECT name, 
                 JSONB_EACH_TEXT(menu -> 'Пицца') AS pizza_name
          FROM cafe.restaurants r 
          WHERE r.type = 'pizzeria'::cafe.restaurant_type) AS p
    GROUP BY p.name
)
SELECT name, count
FROM count_rank
WHERE rank = 1;