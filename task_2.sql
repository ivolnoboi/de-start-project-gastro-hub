/*The materialized view of changing in average check by year (except 2023).*/
CREATE MATERIALIZED VIEW cafe.v_avg_check_change_by_year AS
    WITH avg_check_by_year AS (
        SELECT EXTRACT(YEAR FROM date) AS year,
               restaurant_uuid,
               ROUND(AVG(avg_check), 2) AS avg_check
        FROM cafe.sales
        WHERE EXTRACT(YEAR FROM date) != 2023
        GROUP BY year, restaurant_uuid
    ),
    prev_cur_avg_checks AS (
        SELECT acy.year AS year,
               r.name AS restaurant_name,
               r.type AS type,
               acy.avg_check AS current_avg_check,
               LAG(acy.avg_check) OVER (PARTITION BY name ORDER BY year) AS previous_avg_check
        FROM avg_check_by_year acy
        RIGHT JOIN cafe.restaurants r USING (restaurant_uuid)
    )
    SELECT *,
           ROUND((current_avg_check - previous_avg_check) / current_avg_check * 100, 2) AS percentage_diff
    FROM prev_cur_avg_checks;