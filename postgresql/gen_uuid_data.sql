CREATE TABLE orders_part_template(
  order_id      VARCHAR(36) NOT NULL PRIMARY KEY,
  email         VARCHAR(40) NOT NULL,
  created_at    TIMESTAMP NOT NULL
);
CREATE INDEX orders_created_at_idx ON orders_part_template(created_at);

CREATE TABLE orders
  (LIKE orders_part_template INCLUDING DEFAULTS INCLUDING CONSTRAINTS)
PARTITION BY RANGE (created_at);

SELECT partman.create_parent('public.orders', 'created_at', 'native', 'daily',
  p_premake := 2, p_automatic_maintenance := 'on',
  p_template_table := 'public.orders_part_template',
  p_start_partition := '2023-01-01');

-- test with both functions and test with both types of column datatypes
--gen_random_uuid()::varchar(36) 
INSERT INTO orders (order_id, email, created_at)
SELECT
  md5(random()::text || clock_timestamp()::text)::uuid as order_id,
  'order_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email,
  timestamp '2023-01-01 00:00:00' +
       random() * (now() - timestamp '2023-01-01 00:00:00')
FROM GENERATE_SERIES(1, 100000000) seq;

UPDATE partman.part_config
SET retention = '60 days', retention_keep_table = false, infinite_time_partitions = true
WHERE parent_table='public.orders';

SELECT partman.run_maintenance('public.orders');
