DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
  --order_id    SERIAL PRIMARY KEY,
  order_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email         VARCHAR(40) NOT NULL,
  created_at    TIMESTAMP
);

INSERT INTO orders(email, created_at)
SELECT
  'order_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email,
  timestamp '2016-01-10 20:00:00' +
       random() * (now() - timestamp '2016-01-10 20:00:00')
FROM GENERATE_SERIES(1, 200000) seq;

CREATE INDEX orders_email_idx ON orders (email);
CREATE INDEX orders_created_at_idx ON orders (created_at);

SELECT date_trunc('month', created_at) as created_month, count(*)
FROM orders
GROUP BY created_month
ORDER BY created_month;
