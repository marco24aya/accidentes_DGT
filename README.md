# Análisis de Accidentes de Tráfico en España (DGT)

Proyecto de análisis de datos sobre accidentalidad vial en España utilizando datos oficiales de la **Dirección General de Tráfico (DGT)**, con un enfoque orientado tanto al perfil de **Analista de Datos** como al de **Científico de Datos**.

---

## Descripción

Este proyecto analiza más de **875.000 accidentes de tráfico** registrados en España entre 2016 y 2024. El objetivo es identificar patrones de siniestralidad, factores de riesgo y construir un modelo predictivo de mortalidad.

---

## Tecnologías utilizadas

| Categoría | Herramientas |
|---|---|
| Lenguaje | Python 3.10 |
| Base de datos | MySQL 9.2 |
| Análisis y ETL | pandas, numpy |
| Visualización | matplotlib, seaborn, plotly |
| Machine Learning | scikit-learn |
| Entorno | Jupyter Notebook |
| Cliente SQL | MySQL Workbench |

---

## Estructura del proyecto

```
dgt-accidentes/
│
├── data/
│   ├── raw/                    # Ficheros Excel originales de la DGT
│   ├── csv/                    # CSVs intermedios por año
│   └── accidentes_consolidado.csv  # Dataset final consolidado
│
├── notebooks/
│   ├── ETL_DGT.ipynb  # ETL: unión y limpieza de datos
│   ├── DATA_DGT.ipynb  # Análisis exploratorio, visualizaciones y modelo predictivo de mortalidad
│
├── sql/
│   └── queries_analisis.sql        # Queries SQL de análisis
│
└── README.md
```

---

## Pipeline del proyecto

### 1. ETL — Consolidación de datos
- Conversión de ficheros Excel anuales (2016-2024) a CSV
- Detección automática del separador por año
- Homogeneización de columnas VMP (Vehículos de Movilidad Personal), añadidas por la DGT a partir de 2022
- Generación de un **ID único global** por accidente combinando año e índice correlativo
- Exportación del dataset consolidado con 875.013 registros y 76 columnas

### 2. Base de datos MySQL — Esquema normalizado
Diseño de un **esquema estrella** con 4 tablas de hechos y 2 tablas de dimensiones:

| Tabla | Descripción |
|---|---|
| `accidentes` | Datos identificativos, temporales y de ubicación |
| `victimas` | Conteos de víctimas a 24h y 30 días |
| `vehiculos_implicados` | Muertos desglosados por tipo de vehículo |
| `condiciones_accidente` | Meteorología, señalización e iluminación |
| `ine_cod_prov` | Dimensión de provincias (fuente: INE) |
| `tabla_meteo` | Dimensión de condiciones meteorológicas (fuente: DGT) |

### 3. Análisis SQL
Queries avanzadas con `JOIN`, `GROUP BY`, `CASE WHEN` y funciones de agregación para extraer los principales insights:

- Evolución temporal de accidentes y mortalidad (2016-2024)
- Top 15 provincias por siniestralidad y tasa de mortalidad
- Distribución de accidentes por franja horaria
- Impacto de las condiciones meteorológicas en la mortalidad

### 4. EDA y visualización
Análisis exploratorio con visualizaciones estáticas (matplotlib, seaborn) e interactivas (plotly):

- Evolución anual de accidentes y tasa de mortalidad
- Comparativa de siniestralidad y mortalidad por provincia
- Frecuencia vs mortalidad según condición meteorológica

### 5. Modelo predictivo — Regresión Logística
Modelo de clasificación binaria para predecir si un accidente será **mortal o no mortal**:

- **Variable objetivo:** accidente mortal (al menos 1 muerto a 30 días)
- **Features:** tipo de accidente, día de la semana, zona, tipo de vía, franja horaria, provincia y condición meteorológica
- **Franjas horarias:** mañana (6-13h), tarde (13-20h), noche (20-23h), madrugada (0-5h)
- **Métricas:** F1-Score = 0.65 | ROC-AUC = 0.70
- **Hallazgo principal:** la zona (urbana vs interurbana) es el factor más determinante en la mortalidad, por encima de la meteorología o la provincia

---

## Principales insights

- **2020** registró un 30% menos de accidentes por el confinamiento COVID, pero con una **tasa de mortalidad más alta** (16.27 vs ~15 de media), probablemente por circular a mayor velocidad en carreteras vacías.
- **Barcelona y Madrid** lideran en volumen de accidentes pero tienen tasas de mortalidad bajas (7.57 y 8.50 por 1.000). **Tarragona, Murcia y Alicante** destacan por tener tasas significativamente más altas (>21).
- La **franja de tarde** (13-20h) concentra el mayor volumen de accidentes con más de 445.000 registros. Sin embargo, la **madrugada** (00-05h) es la franja más letal en proporción, con la mayor tasa de mortalidad por accidente.
- Los accidentes en **zona interurbana** tienen una probabilidad de mortalidad significativamente mayor que en zona urbana.

---

## Fuentes de datos

- [Dirección General de Tráfico (DGT)](https://www.dgt.es/menusecundario/dgt-en-cifras/dgt-en-cifras-resultados/) — Ficheros de microdatos de accidentes con víctimas
- [Instituto Nacional de Estadística (INE)](https://www.ine.es) — Códigos de provincia y municipio

---

# ADVERTENCIA 
Los ficheros de datos no están incluidos en el repositorio por su tamaño. Descárgalos directamente de la fuente oficial.
