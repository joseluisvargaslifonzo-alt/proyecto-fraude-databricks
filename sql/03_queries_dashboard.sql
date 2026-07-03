-- Nota: {catalog} y {schema_silver} son variables de Python reemplazadas
-- catalog=fraud_proyecto, schema_silver=silver

-- Indicador (KPI): tasa de fraude por categoría de comercio
SELECT
    nombre_categoria,
    COUNT(*) AS total_transacciones,
    ROUND(SUM(monto), 2) AS monto_total,
    ROUND(AVG(monto), 2) AS monto_promedio,
    SUM(es_fraude) AS total_fraudes,
    ROUND(100.0 * SUM(es_fraude) / COUNT(*), 2) AS tasa_fraude_pct
FROM {catalog}.{schema_silver}.fact_transacciones
GROUP BY nombre_categoria
ORDER BY tasa_fraude_pct DESC;

-- Indicador (KPI): tasa de fraude por franja horaria
SELECT
    hora,
    es_madrugada,
    es_hora_pico,
    COUNT(*) AS total_transacciones,
    SUM(es_fraude) AS total_fraudes,
    ROUND(100.0 * SUM(es_fraude) / COUNT(*), 2) AS tasa_fraude_pct
FROM {catalog}.{schema_silver}.fact_transacciones
GROUP BY hora, es_madrugada, es_hora_pico
ORDER BY hora;

-- Indicador (KPI): tasa de fraude por estado del titular
SELECT
    t.estado_titular,
    COUNT(*) AS total_transacciones,
    SUM(f.es_fraude) AS total_fraudes,
    ROUND(100.0 * SUM(f.es_fraude) / COUNT(*), 2) AS tasa_fraude_pct
FROM {catalog}.{schema_silver}.fact_transacciones f
LEFT JOIN {catalog}.{schema_silver}.dim_titulares_tarjeta t ON f.id_titular = t.id_titular
GROUP BY t.estado_titular
ORDER BY tasa_fraude_pct DESC;

-- Ranking de comercios con mayor riesgo de fraude
SELECT
    nombre_comercio,
    COUNT(*) AS total_transacciones,
    SUM(es_fraude) AS total_fraudes,
    ROUND(100.0 * SUM(es_fraude) / COUNT(*), 2) AS tasa_fraude_pct
FROM {catalog}.{schema_silver}.fact_transacciones
GROUP BY nombre_comercio
HAVING COUNT(*) >= {MIN_TRANSACCIONES}
ORDER BY tasa_fraude_pct DESC, total_transacciones DESC;

-- Resumen diario de transacciones
SELECT
    fecha,
    COUNT(*) AS total_transacciones,
    ROUND(SUM(monto), 2) AS monto_total,
    SUM(es_fraude) AS total_fraudes,
    ROUND(100.0 * SUM(es_fraude) / COUNT(*), 2) AS tasa_fraude_pct
FROM {catalog}.{schema_silver}.fact_transacciones
GROUP BY fecha
ORDER BY fecha;
