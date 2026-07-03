# Detección de Transacciones Fraudulentas en Tarjetas de Crédito

Proyecto final del curso **Sistemas de Gestión de Datos** — Carrera de Big Data y Ciencia de Datos, TECSUP.

## Integrantes

- Aquino Quispe, Cristhian Denilson
- Ccesa Perez, Alvaro Martin
- Puente Cabello, Kalheb Edgardo
- Vargas Lifonzo, Jose Luis

**Docente:** Juan Felix Rodriguez Sanchez

## Descripción del caso

El proyecto analiza transacciones realizadas con tarjetas de crédito para identificar patrones asociados a posibles casos de fraude, utilizando información transaccional, datos de clientes y ubicación geográfica. El objetivo es transformar datos crudos y dispersos en indicadores confiables que apoyen la toma de decisiones en prevención y monitoreo de fraude.

## Arquitectura de la solución

Se implementó el patrón **Medallion** sobre **Databricks** con **Unity Catalog**:

- **Bronze**: Ingesta cruda multiformato (CSV, XLSX, JSON) del dataset `fraudTest`, sin transformaciones de negocio, con columnas de auditoría (`fecha_hora_carga`, `archivo_origen`, `formato_origen`).
- **Silver**: Limpieza, estandarización de texto, conversión de tipos, eliminación de nulos críticos y duplicados, y construcción de un modelo dimensional tipo estrella (`dim_titulares_tarjeta`, `dim_comercios`, `dim_fechas`, `fact_transacciones`). Los registros inválidos se envían a `silver.fraude_rechazados`.
- **Gold**: Cálculo de KPIs de negocio (`kpi_fraude_por_categoria`, `kpi_fraude_por_horario`, `kpi_fraude_por_estado`, `ranking_comercios_riesgo`, `kpi_resumen_diario`) y vista consolidada `vw_modelo_estrella_transacciones` para el dashboard.

## Herramientas utilizadas

- Databricks (Unity Catalog + Delta Lake)
- PySpark y Spark SQL
- Dashboard interactivo de Databricks
- Microsoft Excel (conciliación de resultados)

## Estructura del proyecto

```
proyecto-fraude-databricks/
├── README.md
├── .gitignore
├── notebooks/
│   ├── 01_ingesta_bronze.ipynb
│   ├── 02_limpieza_silver.ipynb
│   ├── 03_modelo_gold.ipynb
│   └── 04_queries_dashboard.ipynb
├── sql/
│   ├── 01_creacion_tablas.sql
│   ├── 02_vistas_gold.sql
│   └── 03_queries_dashboard.sql
├── docs/
│   ├── diccionario_datos.md
│   └── arquitectura_solucion.png
├── data_sample/
│   ├── ventas_sample.csv
│   ├── clientes_sample.csv
│   └── productos_sample.csv
├── dashboard/
│   └── captura_dashboard.png
└── conciliacion/
    └── resumen_conciliacion.md
```

## Instrucciones para ejecutar los notebooks

1. Cargar el archivo `fraudTest.csv` (o sus versiones XLSX/JSON) al Volume de Databricks: `/Volumes/fraud_proyecto/bronze/raw_data/input/`.
2. Ejecutar en orden: `01_ingesta_bronze.ipynb` → `02_limpieza_silver.ipynb` → `03_modelo_gold.ipynb` → `04_queries_dashboard.ipynb`.
3. Los notebooks crean el catálogo `fraud_proyecto` y los esquemas `bronze`, `silver` y `gold` de forma automática y reproducible.
4. Las tablas Gold se exportan en CSV a `/Volumes/fraud_proyecto/gold/export_csv/` para su descarga y conciliación en Excel.

## Descripción de carpetas

- **notebooks/**: los 4 notebooks del pipeline (Bronze, Silver, Gold y consultas del dashboard).
- **sql/**: scripts SQL de creación de tablas, vistas Gold y las 5 queries de negocio.
- **docs/**: diccionario de datos y diagrama de arquitectura de la solución.
- **data_sample/**: muestras pequeñas de los datasets usados (no el dataset completo, que va en Google Drive).
- **dashboard/**: capturas del dashboard interactivo construido en Databricks.
- **conciliacion/**: resumen de la validación entre los KPIs calculados en el pipeline y en Excel.

## Resultados principales

- Total de transacciones analizadas: **555,719**
- Total de fraudes detectados: **2,000**
- Tasa de fraude general: **0.39%**
- Categorías con mayor riesgo: `shopping_net` (1.21%) y `misc_net` (0.98%)
- Horarios de mayor riesgo: madrugada, entre las 0 y las 3 am
- Estados con mayor incidencia: Alaska (AK), Connecticut (CT) e Idaho (ID)
- Dashboard interactivo con tarjetas KPI, mapa geográfico, serie temporal y gráficos de barras por categoría y horario

## Link o capturas del dashboard

*(Agregar aquí el link al dashboard de Databricks si es público, o adjuntar capturas dentro de `dashboard/`)*
