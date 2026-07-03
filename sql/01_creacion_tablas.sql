--NOTA: Este proyecto usa PySpark (no SQL puro) para crear las tablas
--del modelo dimensional tipo estrella. Se documenta aquí el código real
--usado en notebooks/02_limpieza_silver.ipynb

-- Catálogo y esquemas del proyecto
CREATE CATALOG IF NOT EXISTS fraud_proyecto;
CREATE SCHEMA IF NOT EXISTS fraud_proyecto.bronze;
CREATE SCHEMA IF NOT EXISTS fraud_proyecto.silver;

/*
-- Tabla: dim_titulares_tarjeta
dim_titulares = df_clean.select(
    "numero_tarjeta",
    "nombre_titular", "apellido_titular", "genero_titular",
    "direccion_titular", "ciudad_titular", "estado_titular", "codigo_postal_titular",
    "latitud_titular", "longitud_titular",
    "poblacion_ciudad", "ocupacion_titular", "fecha_nacimiento"
).withColumnRenamed("numero_tarjeta", "id_titular") \
 .dropDuplicates(["id_titular"])

(
    dim_titulares.write
    .format("delta")
    .mode("overwrite")
    .saveAsTable(f"{catalog}.{schema_name}.dim_titulares_tarjeta")
)
*/

/*
-- Tabla: dim_comercios
dim_comercios = (
    df_clean
    .select("nombre_comercio")
    .dropDuplicates()
    .withColumn("id_comercio", monotonically_increasing_id() + 1)
    .select("id_comercio", "nombre_comercio")
)
(
    dim_comercios.write
    .format("delta")
    .mode("overwrite")
    .saveAsTable(f"{catalog}.{schema_name}.dim_comercios")
)
*/

/*
-- Tabla: dim_fechas
dim_fechas = (
    df_clean
    .select("fecha_transaccion")
    .dropDuplicates()
    .withColumnRenamed("fecha_transaccion", "fecha")
    .withColumn("anio", year("fecha"))
    .withColumn("mes", month("fecha"))
    .withColumn("dia", dayofmonth("fecha"))
    .withColumn("nombre_dia", date_format("fecha", "EEEE"))
)
(
    dim_fechas.write
    .format("delta")
    .mode("overwrite")
    .saveAsTable(f"{catalog}.{schema_name}.dim_fechas")
)
*/

/*
-- Tabla: fact_transacciones
fact_transacciones = df_clean.select(
    col("id_transaccion"),
    col("numero_tarjeta").alias("id_titular"),
    col("nombre_comercio"),
    col("nombre_categoria"),
    col("fecha_transaccion").alias("fecha"),
    col("fecha_hora_transaccion").alias("timestamp_transaccion"),
    # Columnas derivadas de fecha/hora
    hour(col("fecha_hora_transaccion")).alias("hora"),
    dayofweek(col("fecha_transaccion")).alias("dia_de_la_semana"),
    # Columna calculada: Madrugada
    when(
        (hour(col("fecha_hora_transaccion")) >= 0) & (hour(col("fecha_hora_transaccion")) <= 6),
        True
    ).otherwise(False).alias("es_madrugada"),
    # Columna calculada: Hora Pico
    when(
        ((hour(col("fecha_hora_transaccion")) >= 9) & (hour(col("fecha_hora_transaccion")) <= 12))
        | ((hour(col("fecha_hora_transaccion")) >= 18) & (hour(col("fecha_hora_transaccion")) <= 21)),
        True
    ).otherwise(False).alias("es_hora_pico"),
    # Columna calculada: Edad del titular
    (year_fn(col("fecha_transaccion")) - year_fn(col("fecha_nacimiento"))).alias("edad_del_titular"),
    col("monto"),
    col("es_fraude"),
    col("latitud_comercio"),
    col("longitud_comercio")
)
(
    fact_transacciones.write
    .format("delta")
    .mode("overwrite")
    .saveAsTable(f"{catalog}.{schema_name}.fact_transacciones")
)
*/
