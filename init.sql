-- スキーマの作成
CREATE TABLE plans (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  code VARCHAR(255)
);

CREATE TABLE prices (
  id SERIAL PRIMARY KEY,
  plan_id INTEGER REFERENCES plans(id),
  ampere INTEGER,
  charge INTEGER
);

-- plansにデータを投入
INSERT INTO plans (name, code) VALUES
('プランA', 'CODE001'),
('プランB', 'CODE002'),
('プランC', 'CODE003'),
('プランD', 'CODE004'),
('プランE', 'CODE005');

-- plansテーブルの各プランに対して価格データを投入する
-- PLAN CODE001 ~ CODE003 の場合、10 ~ 60 までのampereを投入
WITH ampere_values AS (SELECT generate_series(10, 60, 10) AS ampere),
     plan_ids AS (SELECT id FROM plans WHERE code IN ('CODE001', 'CODE002', 'CODE003'))
INSERT INTO prices (plan_id, ampere, charge)
SELECT plan_ids.id, ampere_values.ampere, ampere_values.ampere * 100
FROM plan_ids, ampere_values;

-- PLAN CODE004 の場合、30 ~ 60 までのampereを投入
INSERT INTO prices (plan_id, ampere, charge)
SELECT id, generate_series(30, 60, 10) AS ampere, generate_series(30, 60, 10) * 100
FROM plans WHERE code = 'CODE004';

-- PLAN CODE005 の場合、ampereは60のみ
INSERT INTO prices (plan_id, ampere, charge)
SELECT id, 60 AS ampere, 60 * 100
FROM plans WHERE code = 'CODE005';