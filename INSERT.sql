/*Inserting data to the cafe schema and populate it with raw data.*/
INSERT INTO cafe.restaurants (name, type, menu)
SELECT DISTINCT s.cafe_name, s.type::cafe.restaurant_type, m.menu 
FROM raw_data.sales s
LEFT JOIN raw_data.menu m USING (cafe_name);

INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT manager, manager_phone
FROM raw_data.sales s;

INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, 
                                                start_work_date, end_work_date)
SELECT r.restaurant_uuid, m.manager_uuid, MIN(s.report_date), MAX(s.report_date)
FROM cafe.restaurants r
FULL JOIN raw_data.sales s ON s.cafe_name = r.name
FULL JOIN cafe.managers m ON s.manager = m.name
GROUP BY r.restaurant_uuid, m.manager_uuid;

INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT s.report_date, r.restaurant_uuid, s.avg_check
FROM raw_data.sales s 
LEFT JOIN cafe.restaurants r ON s.cafe_name = r.name;