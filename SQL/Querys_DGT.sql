USE accidentes_db;

CREATE TABLE temp_accidentes (
    id_accidente_global         VARCHAR(30),
    secuencial                  VARCHAR(20),
    anyo                        VARCHAR(10),
    mes                         VARCHAR(10),
    dia_semana                  VARCHAR(10),
    hora                        VARCHAR(10),
    cod_provincia               VARCHAR(10),
    cod_municipio               VARCHAR(10),
    isla                        VARCHAR(50),
    zona                        VARCHAR(100),
    zona_agrupada               VARCHAR(50),
    carretera                   VARCHAR(50),
    km                          VARCHAR(20),
    sentido_1f                  VARCHAR(100),
    titularidad_via             VARCHAR(50),
    tipo_via                    VARCHAR(100),
    tipo_accidente              VARCHAR(100),
    total_mu24h                 VARCHAR(10),
    total_hg24h                 VARCHAR(10),
    total_hl24h                 VARCHAR(10),
    total_victimas_24h          VARCHAR(10),
    total_mu30df                VARCHAR(10),
    total_hg30df                VARCHAR(10),
    total_hl30df                VARCHAR(10),
    total_victimas_30df         VARCHAR(10),
    total_vehiculos             VARCHAR(10),
    tot_peat_mu24h              VARCHAR(10),
    tot_bici_mu24h              VARCHAR(10),
    tot_ciclo_mu24h             VARCHAR(10),
    tot_moto_mu24h              VARCHAR(10),
    tot_tur_mu24h               VARCHAR(10),
    tot_furg_mu24h              VARCHAR(10),
    tot_cam_menos3500_mu24h     VARCHAR(10),
    tot_cam_mas3500_mu24h       VARCHAR(10),
    tot_bus_mu24h               VARCHAR(10),
    tot_otro_mu24h              VARCHAR(10),
    tot_sinespecif_mu24h        VARCHAR(10),
    tot_peat_mu30df             VARCHAR(10),
    tot_bici_mu30df             VARCHAR(10),
    tot_ciclo_mu30df            VARCHAR(10),
    tot_moto_mu30df             VARCHAR(10),
    tot_tur_mu30df              VARCHAR(10),
    tot_furg_mu30df             VARCHAR(10),
    tot_cam_menos3500_mu30df    VARCHAR(10),
    tot_cam_mas3500_mu30df      VARCHAR(10),
    tot_bus_mu30df              VARCHAR(10),
    tot_otro_mu30df             VARCHAR(10),
    tot_sinespecif_mu30df       VARCHAR(10),
    nudo                        VARCHAR(50),
    nudo_info                   VARCHAR(200),
    carretera_cruce             VARCHAR(50),
    priori_norma                VARCHAR(10),
    priori_agente               VARCHAR(10),
    priori_semaforo             VARCHAR(10),
    priori_vert_stop            VARCHAR(10),
    priori_vert_ceda            VARCHAR(10),
    priori_horiz_stop           VARCHAR(10),
    priori_horiz_ceda           VARCHAR(10),
    priori_marcas               VARCHAR(10),
    priori_pea_no_elev          VARCHAR(10),
    priori_pea_elev             VARCHAR(10),
    priori_marca_ciclos         VARCHAR(10),
    priori_circunstancial       VARCHAR(10),
    priori_otra                 VARCHAR(10),
    condicion_nivel_circula     VARCHAR(100),
    condicion_firme             VARCHAR(100),
    condicion_iluminacion       VARCHAR(100),
    condicion_meteo             VARCHAR(100),
    condicion_niebla            VARCHAR(100),
    condicion_viento            VARCHAR(100),
    visib_restringida_por       VARCHAR(100),
    acera                       VARCHAR(50),
    trazado_planta              VARCHAR(100),
    tot_vmp_mu24h               VARCHAR(10),
    tot_vmp_mu30df              VARCHAR(10),
    id_accidente                VARCHAR(20)
) ENGINE=InnoDB;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.2/Uploads/accidentes_consolidado.csv'
INTO TABLE temp_accidentes
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# INSERTAR DATOS EN TABLAS
USE accidentes_db;
SET SESSION net_read_timeout = 3600;
SET SESSION net_write_timeout = 3600;
SET SESSION wait_timeout = 3600;
SET SESSION sql_mode = '';
# TABLA 1
INSERT INTO accidentes
SELECT id_accidente_global, id_accidente, anyo, mes, dia_semana, hora,
    NULLIF(TRIM(cod_provincia), '') AS cod_provincia,
    NULLIF(TRIM(cod_municipio), '') AS cod_municipio,
    isla, zona, zona_agrupada,
    carretera, 
    NULLIF(TRIM(REPLACE(km, ',', '.')), '') AS km,
    sentido_1f, titularidad_via, tipo_via,
    tipo_accidente, 
    NULLIF(TRIM(total_vehiculos), '') AS total_vehiculos,
    nudo, nudo_info,
    carretera_cruce, trazado_planta, acera
FROM temp_accidentes;
# TABLA 2
INSERT INTO victimas
SELECT id_accidente_global,
    total_mu24h, total_hg24h, total_hl24h, total_victimas_24h,
    total_mu30df, total_hg30df, total_hl30df, total_victimas_30df
FROM temp_accidentes;

# TABLA 3
INSERT INTO vehiculos_implicados
SELECT id_accidente_global,
    tot_peat_mu24h, tot_bici_mu24h, tot_ciclo_mu24h, tot_moto_mu24h,
    tot_tur_mu24h, tot_furg_mu24h, tot_cam_menos3500_mu24h,
    tot_cam_mas3500_mu24h, tot_bus_mu24h, tot_otro_mu24h,
    tot_sinespecif_mu24h,
    tot_peat_mu30df, tot_bici_mu30df, tot_ciclo_mu30df, tot_moto_mu30df,
    tot_tur_mu30df, tot_furg_mu30df, tot_cam_menos3500_mu30df,
    tot_cam_mas3500_mu30df, tot_bus_mu30df, tot_vmp_mu30df,
    tot_otro_mu30df, tot_sinespecif_mu30df
FROM temp_accidentes;

# TABLA 4
ALTER TABLE condiciones_accidente
    MODIFY priori_norma         TINYINT DEFAULT 0,
    MODIFY priori_agente        TINYINT DEFAULT 0,
    MODIFY priori_semaforo      TINYINT DEFAULT 0,
    MODIFY priori_vert_stop     TINYINT DEFAULT 0,
    MODIFY priori_vert_ceda     TINYINT DEFAULT 0,
    MODIFY priori_horiz_stop    TINYINT DEFAULT 0,
    MODIFY priori_horiz_ceda    TINYINT DEFAULT 0,
    MODIFY priori_marcas        TINYINT DEFAULT 0,
    MODIFY priori_pea_no_elev   TINYINT DEFAULT 0,
    MODIFY priori_pea_elev      TINYINT DEFAULT 0,
    MODIFY priori_marca_ciclos  TINYINT DEFAULT 0,
    MODIFY priori_circunstancial TINYINT DEFAULT 0,
    MODIFY priori_otra          TINYINT DEFAULT 0;
INSERT INTO condiciones_accidente
SELECT id_accidente_global,
    condicion_nivel_circula, condicion_firme, condicion_iluminacion,
    condicion_meteo, condicion_niebla, condicion_viento,
    visib_restringida_por,
    priori_norma, priori_agente, priori_semaforo, priori_vert_stop,
    priori_vert_ceda, priori_horiz_stop, priori_horiz_ceda,
    priori_marcas, priori_pea_no_elev, priori_pea_elev,
    priori_marca_ciclos, priori_circunstancial, priori_otra
FROM temp_accidentes;

# PASAMOS A PYTHON POR PROBLEMAS DE PASAR LOS DATOS DE LA TABLA TEMPORAL A LAS 4 TABLAS

# CREAMOS TABLA PARA COD. PROVINCIAS
CREATE TABLE accidentes_db.ine_cod_prov (
cod_provincia SMALLINT NOT NULL,
provincia VARCHAR(50) NOT NULL,
PRIMARY KEY (cod_provincia)
);

INSERT INTO accidentes_db.ine_cod_prov (cod_provincia, provincia)
VALUES  (1, 'Álava'), (2, 'Albacete'), (3, 'Alicante'),
(4, 'Almería'), (5, 'Ávila'), (6, 'Badajoz'), (7, 'Islas Baleares'), (8, 'Barcelona'),
(9, 'Burgos'), (10, 'Cáceres'), (11, 'Cádiz'), (12, 'Castellón'), (13, 'Ciudad Real'),
(14, 'Córdoba'), (15, 'A Coruña'), (16, 'Cuenca'), (17, 'Girona'), (18, 'Granada'),
(19, 'Guadalajara'), (20, 'Gipuzkoa'), (21, 'Huelva'), (22, 'Huesca'), (23, 'Jaén'), (24, 'León'),
(25, 'Lleida'), (26, 'La Rioja'), (27, 'Lugo'), (28, 'Madrid'), (29, 'Málaga'),
(30, 'Murcia'), (31, 'Navarra'), (32, 'Ourense'), (33, 'Asturias'), (34, 'Palencia'),
(35, 'Las Palmas'), (36, 'Pontevedra'), (37, 'Salamanca'), (38, 'Santa Cruz de Tenerife'),
(39, 'Cantabria'), (40, 'Segovia'), (41, 'Sevilla'), (42, 'Soria'), (43, 'Tarragona'),
(44, 'Teruel'), (45, 'Toledo'), (46, 'Valencia'), (47, 'Valladolid'),
(48, 'Bizkaia'), (49, 'Zamora'), (50, 'Zaragoza'), (51, 'Ceuta'), (52, 'Melilla');

# QUERYS
# 1.EVOLUCIÓN ANUAL DE LOS ACCIDENTES
SELECT
    accidentes.anyo,
    COUNT(*)                                                        AS total_accidentes,
    SUM(victimas.mu24h)                                             AS total_muertos_24h,
    SUM(victimas.mu30df)                                            AS total_muertos_30df,
    ROUND(SUM(victimas.mu24h) / COUNT(*) * 1000, 2)                AS tasa_mortalidad_por_1000
FROM accidentes
JOIN victimas ON accidentes.id_accidente_global = victimas.id_accidente_global
GROUP BY accidentes.anyo
ORDER BY accidentes.anyo;

# 2. SINISTRIOS POR PROVINCIAS
SELECT
    a.cod_provincia,
    p.provincia,
    COUNT(*)                                    AS total_accidentes,
    SUM(v.mu30df)                               AS total_muertos_30df,
    ROUND(SUM(v.mu30df) / COUNT(*) * 1000, 2)  AS tasa_mortalidad_por_1000
FROM accidentes a
JOIN victimas v          ON a.id_accidente_global = v.id_accidente_global
JOIN ine_cod_prov p      ON a.cod_provincia = p.cod_provincia
WHERE a.cod_provincia IS NOT NULL
GROUP BY a.cod_provincia, p.provincia
ORDER BY total_accidentes DESC
LIMIT 10;

# 3. ACCIDENTES POR FRANJA HORARIA
SELECT
    CASE
        WHEN a.hora BETWEEN 6  AND 12  THEN '06-12 Mañana '
        WHEN a.hora BETWEEN 13 AND 20 THEN '13-20 Tarde'
        WHEN a.hora BETWEEN 21 AND 23 THEN '21-23 Noche'
        ELSE '00-05 Madrugada'
    END                             AS franja_horaria,
    COUNT(*)                        AS total_accidentes,
    SUM(v.mu24h)                    AS total_muertos_24h,
    ((SUM(v.mu24h) / COUNT(*))*100)       AS letalidad 
FROM accidentes a
JOIN victimas v ON a.id_accidente_global = v.id_accidente_global
WHERE a.hora IS NOT NULL
GROUP BY franja_horaria
ORDER BY letalidad DESC;

# 4. CONDICIONES CLIMÁTICAS
USE accidentes_db;
SELECT
    m.valor                                     AS condicion,
    COUNT(*)                                    AS total_accidentes,
    SUM(v.mu30df)                               AS total_muertos_30df,
    ROUND(SUM(v.mu30df) / COUNT(*) * 1000, 2)  AS tasa_mortalidad_por_1000
FROM accidentes a
JOIN victimas v              ON a.id_accidente_global = v.id_accidente_global
JOIN condiciones_accidente c ON a.id_accidente_global = c.id_accidente_global
JOIN tabla_meteo m           ON c.condicion_meteo = m.etiqueta
WHERE c.condicion_meteo IS NOT NULL
GROUP BY c.condicion_meteo, m.valor
ORDER BY total_accidentes DESC;


# VER NULOS
USE accidentes_db;

SELECT
    'accidentes'        AS tabla,
    'cod_provincia'     AS columna,
    COUNT(*)            AS total_filas,
    SUM(CASE WHEN cod_provincia IS NULL THEN 1 ELSE 0 END)      AS nulos,
    ROUND(SUM(CASE WHEN cod_provincia IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_nulos
FROM accidentes

UNION ALL

SELECT
    'accidentes',
    'cod_municipio',
    COUNT(*),
    SUM(CASE WHEN cod_municipio IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN cod_municipio IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
FROM accidentes

UNION ALL

SELECT
    'accidentes',
    'hora',
    COUNT(*),
    SUM(CASE WHEN hora IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN hora IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
FROM accidentes

UNION ALL

SELECT
    'accidentes',
    'km',
    COUNT(*),
    SUM(CASE WHEN km IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN km IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
FROM accidentes;

 
# CREACIÓN TABLA METEO
CREATE TABLE accidentes_db.tabla_meteo (
etiqueta SMALLINT NOT NULL,
valor VARCHAR(50) NOT NULL,

PRIMARY KEY (etiqueta)
);

INSERT INTO accidentes_db.tabla_meteo (etiqueta, valor) VALUES
(1,"Despejado"), (2, "Nublado"), (3, "Lluvia débil"), (4, "Lluvia fuerte"), (5, "Granizado"), (6, "Nevando"), (7, "Desconocido"), (999, "Sin especificar");

