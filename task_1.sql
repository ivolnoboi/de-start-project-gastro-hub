/*The view of top 3 restaurants by the highest average check in each category.*/
CREATE VIEW cafe.v_top_average_check AS
    WITH avg_check_tmp AS (
        SELECT s.restaurant_uuid, 
               AVG(avg_check) AS avg_check
        FROM cafe.sales s 
        GROUP BY s.restaurant_uuid
    ),
    rest_and_check_tmp AS (
        SELECT r.name, 
               r.type, 
               ac.avg_check,
               ROW_NUMBER() OVER(PARTITION BY r.type ORDER BY ac.avg_check DESC) AS check_rank
        FROM cafe.restaurants r 
        LEFT JOIN avg_check_tmp ac USING (restaurant_uuid)
    )
    SELECT name, type, ROUND(avg_check, 2)
    FROM rest_and_check_tmp
    WHERE check_rank <= 3;