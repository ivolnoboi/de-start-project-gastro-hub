/*Top 3 restaurants where managers change most often.*/
SELECT r.name AS restaurant_name, 
       COUNT(*) AS amount_of_managers
FROM cafe.restaurant_manager_work_dates rmwd
LEFT JOIN cafe.restaurants r USING (restaurant_uuid)
GROUP BY r.name
ORDER BY COUNT(*) DESC
LIMIT 3;