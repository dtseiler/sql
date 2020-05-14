DROP TABLE IF EXISTS users;
CREATE TABLE users(
  --id    SERIAL PRIMARY KEY,
  id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email VARCHAR(40) NOT NULL UNIQUE,
  created_at    TIMESTAMP
);

INSERT INTO users(email, created_at)
SELECT
  'user_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email,
  timestamp '2016-01-10 20:00:00' +
       random() * (timestamp '2020-01-20 20:00:00' -
                   timestamp '2016-01-10 20:00:00')
FROM GENERATE_SERIES(1, 200000) seq;

CREATE INDEX users_created_at_idx ON users(created_at);

SELECT date_trunc('month', created_at) as created_month, count(*)
FROM users
GROUP BY created_month
ORDER BY created_month;
