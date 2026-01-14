-- =====================================================================
-- FRAUD DETECTION - SQL ANALYSIS QUERIES
-- =====================================================================
-- Archivo de consultas SQL para análisis exploratorio del dataset
-- de detección de fraude en tarjetas de crédito
--
-- Autor: Ing. Daniel Varela Perez
-- Email: bedaniele0@gmail.com
-- Tel: +52 55 4189 3428
-- Fecha: 2025-09-24
-- =====================================================================

-- 1. ANÁLISIS BÁSICO DE DISTRIBUCIÓN
-- ===================================

-- Distribución general de transacciones por clase
SELECT
    Class,
    COUNT(*) as total_transacciones,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions), 4) as porcentaje,
    ROUND(AVG(Amount), 2) as monto_promedio,
    ROUND(MIN(Amount), 2) as monto_minimo,
    ROUND(MAX(Amount), 2) as monto_maximo
FROM transactions
GROUP BY Class
ORDER BY Class;

-- Estadísticas descriptivas por clase
SELECT
    Class,
    COUNT(*) as n_transacciones,
    ROUND(AVG(Amount), 2) as avg_amount,
    ROUND(MIN(Amount), 2) as min_amount,
    ROUND(MAX(Amount), 2) as max_amount,
    ROUND(
        (SELECT AVG(Amount * Amount) FROM transactions t2 WHERE t2.Class = t1.Class) -
        AVG(Amount) * AVG(Amount), 2
    ) as variance_amount
FROM transactions t1
GROUP BY Class;

-- 2. ANÁLISIS TEMPORAL
-- ====================

-- Distribución de fraudes por hora del día
SELECT
    CAST(Time / 3600 AS INTEGER) as hora,
    COUNT(*) as total_transacciones,
    SUM(Class) as total_fraudes,
    ROUND(SUM(Class) * 100.0 / COUNT(*), 4) as tasa_fraude_pct,
    ROUND(AVG(Amount), 2) as monto_promedio
FROM transactions
GROUP BY CAST(Time / 3600 AS INTEGER)
ORDER BY hora;

-- Análisis de ventanas temporales de 6 horas
SELECT
    CASE
        WHEN Time < 21600 THEN 'Madrugada (0-6h)'
        WHEN Time < 43200 THEN 'Mañana (6-12h)'
        WHEN Time < 64800 THEN 'Tarde (12-18h)'
        ELSE 'Noche (18-24h)'
    END as periodo_dia,
    COUNT(*) as total_transacciones,
    SUM(Class) as fraudes,
    ROUND(SUM(Class) * 100.0 / COUNT(*), 4) as tasa_fraude,
    ROUND(AVG(Amount), 2) as monto_promedio
FROM transactions
GROUP BY CASE
    WHEN Time < 21600 THEN 'Madrugada (0-6h)'
    WHEN Time < 43200 THEN 'Mañana (6-12h)'
    WHEN Time < 64800 THEN 'Tarde (12-18h)'
    ELSE 'Noche (18-24h)'
END
ORDER BY MIN(Time);

-- 3. ANÁLISIS DE MONTOS
-- =====================

-- Rangos de montos y distribución de fraudes
SELECT
    CASE
        WHEN Amount = 0 THEN '0 - Cero'
        WHEN Amount <= 50 THEN '1 - Bajo (0-50)'
        WHEN Amount <= 200 THEN '2 - Medio (50-200)'
        WHEN Amount <= 1000 THEN '3 - Alto (200-1000)'
        ELSE '4 - Muy Alto (>1000)'
    END as rango_monto,
    COUNT(*) as total_transacciones,
    SUM(Class) as fraudes,
    ROUND(SUM(Class) * 100.0 / COUNT(*), 4) as tasa_fraude_pct,
    ROUND(MIN(Amount), 2) as min_amount,
    ROUND(MAX(Amount), 2) as max_amount,
    ROUND(AVG(Amount), 2) as avg_amount
FROM transactions
GROUP BY CASE
    WHEN Amount = 0 THEN '0 - Cero'
    WHEN Amount <= 50 THEN '1 - Bajo (0-50)'
    WHEN Amount <= 200 THEN '2 - Medio (50-200)'
    WHEN Amount <= 1000 THEN '3 - Alto (200-1000)'
    ELSE '4 - Muy Alto (>1000)'
END
ORDER BY rango_monto;

-- Top 10 montos más frecuentes en fraudes
SELECT
    Amount,
    COUNT(*) as frecuencia,
    SUM(Class) as total_fraudes,
    ROUND(SUM(Class) * 100.0 / COUNT(*), 2) as tasa_fraude_pct
FROM transactions
WHERE Amount > 0
GROUP BY Amount
HAVING COUNT(*) >= 5  -- Solo montos que aparecen al menos 5 veces
ORDER BY SUM(Class) DESC, COUNT(*) DESC
LIMIT 10;

-- 4. FEATURE ENGINEERING CON WINDOW FUNCTIONS
-- ===========================================

-- Crear features de agregación temporal
WITH transacciones_con_features AS (
    SELECT *,
        -- Transacciones por hora
        COUNT(*) OVER (
            PARTITION BY CAST(Time / 3600 AS INTEGER)
        ) as transacciones_por_hora,

        -- Monto promedio por hora
        AVG(Amount) OVER (
            PARTITION BY CAST(Time / 3600 AS INTEGER)
        ) as monto_promedio_hora,

        -- Ranking por monto dentro de cada hora
        ROW_NUMBER() OVER (
            PARTITION BY CAST(Time / 3600 AS INTEGER)
            ORDER BY Amount DESC
        ) as ranking_monto_hora,

        -- Transacciones en ventana móvil de 1000 transacciones
        COUNT(*) OVER (
            ORDER BY Time
            ROWS BETWEEN 499 PRECEDING AND 500 FOLLOWING
        ) as ventana_1000_transacciones,

        -- Percentil del monto
        PERCENT_RANK() OVER (ORDER BY Amount) as percentil_monto
    FROM transactions
)
SELECT
    Class,
    COUNT(*) as n_transacciones,
    ROUND(AVG(transacciones_por_hora), 2) as avg_trans_por_hora,
    ROUND(AVG(monto_promedio_hora), 2) as avg_monto_hora,
    ROUND(AVG(CAST(ranking_monto_hora AS REAL)), 2) as avg_ranking_monto,
    ROUND(AVG(ventana_1000_transacciones), 2) as avg_ventana_movil,
    ROUND(AVG(percentil_monto), 4) as avg_percentil_monto
FROM transacciones_con_features
GROUP BY Class;

-- 5. DETECCIÓN DE PATRONES ANÓMALOS
-- =================================

-- Transacciones con montos extremos
SELECT
    'Montos Extremos' as patron,
    COUNT(*) as total_transacciones,
    SUM(Class) as fraudes,
    ROUND(SUM(Class) * 100.0 / COUNT(*), 4) as tasa_fraude_pct
FROM transactions
WHERE Amount > (SELECT AVG(Amount) + 3 *
    SQRT(AVG(Amount * Amount) - AVG(Amount) * AVG(Amount)) FROM transactions)
   OR Amount < (SELECT AVG(Amount) - 3 *
    SQRT(AVG(Amount * Amount) - AVG(Amount) * AVG(Amount)) FROM transactions);

-- Concentración de transacciones por hora
WITH concentracion_horaria AS (
    SELECT
        CAST(Time / 3600 AS INTEGER) as hora,
        COUNT(*) as transacciones_hora
    FROM transactions
    GROUP BY CAST(Time / 3600 AS INTEGER)
),
estadisticas_concentracion AS (
    SELECT
        AVG(transacciones_hora) as avg_trans_hora,
        MAX(transacciones_hora) as max_trans_hora,
        MIN(transacciones_hora) as min_trans_hora
    FROM concentracion_horaria
)
SELECT
    'Horas Pico' as patron,
    COUNT(DISTINCT t.rowid) as total_transacciones,
    SUM(t.Class) as fraudes,
    ROUND(SUM(t.Class) * 100.0 / COUNT(DISTINCT t.rowid), 4) as tasa_fraude_pct
FROM transactions t
JOIN concentracion_horaria ch ON CAST(t.Time / 3600 AS INTEGER) = ch.hora
CROSS JOIN estadisticas_concentracion ec
WHERE ch.transacciones_hora > ec.avg_trans_hora + (ec.max_trans_hora - ec.avg_trans_hora) * 0.75;

-- 6. ANÁLISIS DE CORRELACIONES ENTRE VARIABLES V*
-- ===============================================

-- Análisis de variables V* más relevantes para fraudes
WITH correlacion_fraudes AS (
    SELECT
        'V1' as variable,
        ROUND(AVG(CASE WHEN Class = 1 THEN V1 ELSE NULL END), 4) as media_fraude,
        ROUND(AVG(CASE WHEN Class = 0 THEN V1 ELSE NULL END), 4) as media_normal,
        ROUND(ABS(AVG(CASE WHEN Class = 1 THEN V1 ELSE NULL END) -
                  AVG(CASE WHEN Class = 0 THEN V1 ELSE NULL END)), 4) as diferencia_absoluta
    FROM transactions

    UNION ALL

    SELECT
        'V2' as variable,
        ROUND(AVG(CASE WHEN Class = 1 THEN V2 ELSE NULL END), 4) as media_fraude,
        ROUND(AVG(CASE WHEN Class = 0 THEN V2 ELSE NULL END), 4) as media_normal,
        ROUND(ABS(AVG(CASE WHEN Class = 1 THEN V2 ELSE NULL END) -
                  AVG(CASE WHEN Class = 0 THEN V2 ELSE NULL END)), 4) as diferencia_absoluta
    FROM transactions

    UNION ALL

    SELECT
        'V3' as variable,
        ROUND(AVG(CASE WHEN Class = 1 THEN V3 ELSE NULL END), 4) as media_fraude,
        ROUND(AVG(CASE WHEN Class = 0 THEN V3 ELSE NULL END), 4) as media_normal,
        ROUND(ABS(AVG(CASE WHEN Class = 1 THEN V3 ELSE NULL END) -
                  AVG(CASE WHEN Class = 0 THEN V3 ELSE NULL END)), 4) as diferencia_absoluta
    FROM transactions

    UNION ALL

    SELECT
        'V4' as variable,
        ROUND(AVG(CASE WHEN Class = 1 THEN V4 ELSE NULL END), 4) as media_fraude,
        ROUND(AVG(CASE WHEN Class = 0 THEN V4 ELSE NULL END), 4) as media_normal,
        ROUND(ABS(AVG(CASE WHEN Class = 1 THEN V4 ELSE NULL END) -
                  AVG(CASE WHEN Class = 0 THEN V4 ELSE NULL END)), 4) as diferencia_absoluta
    FROM transactions

    UNION ALL

    SELECT
        'V5' as variable,
        ROUND(AVG(CASE WHEN Class = 1 THEN V5 ELSE NULL END), 4) as media_fraude,
        ROUND(AVG(CASE WHEN Class = 0 THEN V5 ELSE NULL END), 4) as media_normal,
        ROUND(ABS(AVG(CASE WHEN Class = 1 THEN V5 ELSE NULL END) -
                  AVG(CASE WHEN Class = 0 THEN V5 ELSE NULL END)), 4) as diferencia_absoluta
    FROM transactions
)
SELECT *
FROM correlacion_fraudes
ORDER BY diferencia_absoluta DESC;

-- 7. RESUMEN EJECUTIVO
-- ====================

-- Métricas clave del dataset
SELECT
    'Dataset Overview' as metrica,
    COUNT(*) as valor,
    'Total Transacciones' as descripcion
FROM transactions

UNION ALL

SELECT
    'Fraudes Detectados' as metrica,
    SUM(Class) as valor,
    'Total Fraudes' as descripcion
FROM transactions

UNION ALL

SELECT
    'Tasa de Fraude' as metrica,
    ROUND(SUM(Class) * 100.0 / COUNT(*), 4) as valor,
    'Porcentaje' as descripcion
FROM transactions

UNION ALL

SELECT
    'Ratio Desbalanceo' as metrica,
    ROUND(COUNT(*) * 1.0 / SUM(Class), 0) as valor,
    'Normal:Fraude' as descripcion
FROM transactions
WHERE Class IN (0, 1)

UNION ALL

SELECT
    'Monto Total' as metrica,
    ROUND(SUM(Amount), 2) as valor,
    'Suma Montos' as descripcion
FROM transactions

UNION ALL

SELECT
    'Monto Promedio' as metrica,
    ROUND(AVG(Amount), 2) as valor,
    'Media Montos' as descripcion
FROM transactions;

-- =====================================================================
-- FIN DE QUERIES DE ANÁLISIS
-- =====================================================================
-- Desarrollado por: Ing. Daniel Varela Perez
-- Email: bedaniele0@gmail.com | Tel: +52 55 4189 3428
-- =====================================================================