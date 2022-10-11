CREATE TABLE default.orders
(
    id String,
    first_name String,
    last_name String,
    email String,
    gender String,
    street String,
    town String,
    mobile String,
    country String,
    drink_type String,
    cost Float64,
    addons String,
    comments String
) ENGINE = MergeTree ORDER BY (id);

CREATE MATERIALIZED VIEW default.orders_mv TO default.orders AS 
SELECT after.id, after.first_name, after.last_name, after.email, after.gender, 
            after.street, after.town, after.mobile, after.country, after.drink_type, 
            after.cost, after.addons, after.comments
FROM `service_cloud-expo-service-kafka`.orders_queue;