-- Une la tabla de hechos fact_transacciones con las 3 dimensiones
-- mediante LEFT JOINs. Esta vista alimenta directamente el dashboard.

-- Vista consolidada del modelo estrella
CREATE OR REPLACE VIEW {catalog}.{schema_gold}.vw_modelo_estrella_transacciones AS
SELECT
    f.id_transaccion,
    f.fecha,
    f.timestamp_transaccion,
    f.hora,
    f.dia_de_la_semana,
    f.es_madrugada,
    f.es_hora_pico,
    f.edad_del_titular,
    f.monto,
    f.es_fraude,
    f.latitud_comercio,
    f.longitud_comercio,
    t.id_titular,
    t.genero_titular,
    t.ciudad_titular,
    t.estado_titular,
    t.poblacion_ciudad,
    t.ocupacion_titular,
    c.id_comercio,
    c.nombre_comercio,
    f.nombre_categoria,
    d.anio,
    d.mes,
    d.dia,
    d.nombre_dia
FROM {catalog}.{schema_silver}.fact_transacciones f
LEFT JOIN {catalog}.{schema_silver}.dim_titulares_tarjeta t ON f.id_titular = t.id_titular
LEFT JOIN {catalog}.{schema_silver}.dim_comercios c ON f.nombre_comercio = c.nombre_comercio
LEFT JOIN {catalog}.{schema_silver}.dim_fechas d ON f.fecha = d.fecha;
