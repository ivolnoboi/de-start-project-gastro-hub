/*The most expensive pizza for every pizzeria.*/
WITH pizza_prices AS (
    SELECT name, 
           'Пицца' AS dish_type, 
           (jsonb_each_text(menu -> 'Пицца')).key AS pizza_name,
           (jsonb_each_text(menu -> 'Пицца')).value AS pizza_price
    FROM cafe.restaurants r 
    WHERE type = 'pizzeria'::cafe.restaurant_type
),
pizza_ranks AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY name ORDER BY pizza_price DESC) AS rank
    FROM pizza_prices
)
SELECT name, dish_type, pizza_name, pizza_price
FROM pizza_ranks
WHERE rank = 1
ORDER BY name;