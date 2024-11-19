/*Creating the cafe schema and tables inside it.*/
CREATE SCHEMA IF NOT EXISTS cafe;

CREATE TYPE cafe.restaurant_type AS ENUM
('coffee_shop', 'restaurant', 'bar', 'pizzeria');

CREATE TABLE cafe.restaurants (
    restaurant_uuid uuid PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
    name VARCHAR NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu jsonb NOT NULL
);

CREATE TABLE cafe.managers (
    manager_uuid uuid PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
    name VARCHAR NOT NULL,
    phone VARCHAR NOT NULL
);

CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid uuid REFERENCES cafe.restaurants(restaurant_uuid),
    manager_uuid uuid REFERENCES cafe.managers(manager_uuid),
    start_work_date DATE,
    end_work_date DATE,
    PRIMARY KEY (restaurant_uuid, manager_uuid)
);

CREATE TABLE cafe.sales (
    date DATE NOT NULL,
    restaurant_uuid uuid REFERENCES cafe.restaurants(restaurant_uuid),
    avg_check NUMERIC(6, 2) NOT NULL CHECK(avg_check > 0),
    PRIMARY KEY (date, restaurant_uuid)
);
