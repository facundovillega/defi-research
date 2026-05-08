-- P3_25: Buscar tablas del Chief en maker_ethereum
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'maker_ethereum'
  AND (table_name LIKE '%chief%'
    OR table_name LIKE '%vote%'
    OR table_name LIKE '%lock%')
ORDER BY table_name
