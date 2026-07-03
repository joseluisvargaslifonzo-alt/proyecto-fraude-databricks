# Diccionario de Datos

Este diccionario documenta los campos del dataset fuente `fraudTest`, según se cargan en la Capa Bronze del proyecto.

| Campo | Tipo de dato | Descripción | Regla de calidad |
|---|---|---|---|
| `trans_date_trans_time` | Texto (Fecha/Hora) | Fecha y hora de la transacción | No nulo, formato válido |
| `cc_num` | Numérico | Número de tarjeta de crédito del cliente | No nulo |
| `merchant` | Texto | Comercio donde se realizó la compra | No nulo |
| `category` | Texto | Categoría comercial de la transacción | Valores válidos |
| `amt` | Decimal | Monto de la transacción | Mayor que 0 |
| `first` | Texto | Nombre del cliente | No nulo |
| `last` | Texto | Apellido del cliente | No nulo |
| `gender` | Texto | Género del cliente | Valores permitidos (M, F) |
| `street` | Texto | Dirección del cliente | No nulo |
| `city` | Texto | Ciudad del cliente | No nulo |
| `state` | Texto | Estado de residencia | Código válido |
| `zip` | Entero | Código postal | No nulo |
| `lat` | Decimal | Latitud del cliente | Entre -90 y 90 |
| `long` | Decimal | Longitud del cliente | Entre -180 y 180 |
| `city_pop` | Entero | Población de la ciudad | Mayor que 0 |
| `job` | Texto | Ocupación del cliente | No nulo |
| `dob` | Fecha | Fecha de nacimiento | Fecha válida |
| `trans_num` | Texto | Identificador único de transacción | Único y no nulo |
| `unix_time` | Entero | Timestamp Unix | No nulo |
| `merch_lat` | Decimal | Latitud del comercio | Entre -90 y 90 |
| `merch_long` | Decimal | Longitud del comercio | Entre -180 y 180 |
| `is_fraud` | Entero | Indicador de fraude | 0 = No fraude, 1 = Fraude |

## Renombrado de columnas (Capa Silver)

En la Capa Silver, las columnas originales se estandarizan a español en notación `snake_case`:

| Nombre original | Nombre estandarizado |
|---|---|
| `trans_date_trans_time` | `fecha_hora_transaccion_raw` |
| `cc_num` | `numero_tarjeta` |
| `merchant` | `nombre_comercio` |
| `category` | `nombre_categoria` |
| `amt` | `monto` |
| `first` | `nombre_titular` |
| `last` | `apellido_titular` |
| `gender` | `genero_titular` |
| `street` | `direccion_titular` |
| `city` | `ciudad_titular` |
| `state` | `estado_titular` |
| `zip` | `codigo_postal_titular` |
| `lat` | `latitud_titular` |
| `long` | `longitud_titular` |
| `city_pop` | `poblacion_ciudad` |
| `job` | `ocupacion_titular` |
| `dob` | `fecha_nacimiento_raw` |
| `trans_num` | `id_transaccion` |
| `unix_time` | `unix_time` |
| `merch_lat` | `latitud_comercio` |
| `merch_long` | `longitud_comercio` |
| `is_fraud` | `es_fraude_raw` |

## Tablas del modelo dimensional (Capa Silver)

| Tabla | Tipo | Campos principales |
|---|---|---|
| `dim_titulares_tarjeta` | Dimensión | id_titular, nombre_titular, apellido_titular, genero_titular, ciudad_titular, estado_titular, poblacion_ciudad, ocupacion_titular, fecha_nacimiento |
| `dim_comercios` | Dimensión | id_comercio (surrogate key), nombre_comercio |
| `dim_fechas` | Dimensión | fecha (PK), anio, mes, dia, nombre_dia |
| `fact_transacciones` | Hechos | id_transaccion, id_titular (FK), nombre_comercio (FK), nombre_categoria, fecha (FK), timestamp_transaccion, hora, dia_de_la_semana, es_madrugada, es_hora_pico, edad_del_titular, monto, es_fraude, latitud_comercio, longitud_comercio |

## Tablas de KPIs (Capa Gold)

| Tabla | Dimensión de análisis | Métricas calculadas |
|---|---|---|
| `kpi_fraude_por_categoria` | Categoría de comercio | total_transacciones, monto_total, monto_promedio, total_fraudes, tasa_fraude_pct |
| `kpi_fraude_por_horario` | Hora del día / franja | total_transacciones, total_fraudes, tasa_fraude_pct, es_madrugada, es_hora_pico |
| `kpi_fraude_por_estado` | Estado del titular (geográfico) | total_transacciones, total_fraudes, tasa_fraude_pct |
| `ranking_comercios_riesgo` | Comercio específico | total_transacciones, total_fraudes, tasa_fraude_pct (mínimo 5 transacciones) |
| `kpi_resumen_diario` | Fecha (serie diaria) | total_transacciones, monto_total, total_fraudes, tasa_fraude_pct |
