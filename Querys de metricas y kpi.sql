-- Informe 2
--se ejecuta el archivo de opeeraciones_2023.sql

SELECT COUNT(*) FROM vista_operaciones;
SELECT* FROM vista_operaciones;

SELECT COUNT(*) FROM operaciones;
SELECT DISTINCT region FROM vista_operaciones;



DROP VIEW IF EXISTS vista_operaciones;
 
 

SELECT * FROM regiones;

 

CREATE VIEW vista_operaciones AS
SELECT 
    ope.id_registro,

    dep.nombre AS departamento,
    ope.id_departamento,

    mun.nombre AS municipio,
    ope.id_municipio,

    pro.nombre AS producto,
    ope.id_producto,

    r.nombre AS region,

    CASE 
        WHEN ope.fecha LIKE '____-__-__'
        THEN TO_DATE(ope.fecha, 'YYYY-MM-DD')
        ELSE NULL
    END AS fecha,

    CASE 
        WHEN ope.cantidad < 0 THEN ABS(ope.cantidad)
        WHEN ope.cantidad = 0 THEN 1
        ELSE ope.cantidad
    END AS cantidad,

    pro.precio,

    CASE 
        WHEN ope.cantidad < 0 THEN ABS(ope.cantidad)
        WHEN ope.cantidad = 0 THEN 1
        ELSE ope.cantidad
    END * pro.precio AS venta,

    ope.estado

FROM operaciones ope
JOIN departamentos dep ON dep.id_departamento = ope.id_departamento
JOIN municipios mun ON mun.id_municipio = ope.id_municipio
JOIN productos pro ON pro.id_producto = ope.id_producto
LEFT JOIN regiones r ON ope.id_region = r.id_region;


SELECT COUNT(*)
FROM operaciones
WHERE fecha LIKE '2024%';


SELECT COUNT(*)
FROM operaciones
WHERE fecha LIKE '2023%';

SELECT DISTINCT EXTRACT(YEAR FROM fecha)
FROM vista_operaciones
WHERE fecha IS NOT NULL;

-----------------------------------------------------
 --metricas

--MÉTRICA 1 --

SELECT municipio, SUM(cantidad) AS total_vendido
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
GROUP BY municipio
ORDER BY total_vendido DESC
LIMIT 10;

--- metrica 2--

SELECT departamento, SUM(venta) AS total_ventas
FROM vista_operaciones
WHERE EXTRACT(YEAR FROM fecha) = 2023
GROUP BY departamento
ORDER BY total_ventas ASC
LIMIT 5;

-- metrica 3

SELECT municipio, SUM(cantidad) AS total
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
AND EXTRACT(MONTH FROM fecha) = 5
GROUP BY municipio
ORDER BY total DESC
LIMIT 10;


-- metrica 4
-- unica metrica que no trae datos

SELECT producto, SUM(venta) AS total_ventas
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
AND region = 'Caribe'
GROUP BY producto;

--Validacion
SELECT *
FROM vista_operaciones
WHERE EXTRACT(YEAR FROM fecha) = 2023
AND region = 'Caribe'
LIMIT 10;


-- metrica 5 
SELECT producto, SUM(cantidad) AS total_vendido
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
AND region = 'Centro Sur'
GROUP BY producto;




-- metrica 6

SELECT EXTRACT(MONTH FROM fecha) AS mes, SUM(cantidad) AS total
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
GROUP BY mes
ORDER BY mes;

--- metrica 7 
SELECT producto, SUM(cantidad) AS total_vendido
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
GROUP BY producto
ORDER BY total_vendido DESC
LIMIT 10;

--- metrica 8

SELECT departamento, SUM(cantidad) AS total_vendido
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND EXTRACT(YEAR FROM fecha) = 2023
GROUP BY departamento
ORDER BY total_vendido DESC
LIMIT 15;


------ KPI 1
--  Productos con incremento en cantidad
SELECT producto,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN cantidad ELSE 0 END) AS ventas_2023,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN cantidad ELSE 0 END) AS ventas_2024
FROM vista_operaciones
WHERE fecha IS NOT NULL
GROUP BY producto
HAVING SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN cantidad ELSE 0 END) >
       SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN cantidad ELSE 0 END);


-------kpis 2
--Productos con incremento en dinero

SELECT producto,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END) AS ventas_2023,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) AS ventas_2024
FROM vista_operaciones
WHERE fecha IS NOT NULL
GROUP BY producto
HAVING SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) >
       SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END);

--- kpis 3
--Top 5 municipios con mejor desempeño

SELECT municipio,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) -
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END) AS crecimiento
FROM vista_operaciones
WHERE fecha IS NOT NULL
GROUP BY municipio
ORDER BY crecimiento DESC
LIMIT 5;

--------- kps 4
-- Peor desempeño producto NARANJITA Caribe

SELECT departamento,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN cantidad ELSE 0 END) -
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN cantidad ELSE 0 END) AS diferencia
FROM vista_operaciones
WHERE fecha IS NOT NULL
AND producto = 'NARANJITA'
AND region = 'Caribe'
GROUP BY departamento
ORDER BY diferencia ASC
LIMIT 5;




--- kpi 5 inventado

SELECT producto,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END) AS v2023,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) AS v2024
FROM vista_operaciones
WHERE producto = 'COLOMBIANITA'
GROUP BY producto;



--SELECT DISTINCT producto
--FROM vista_operaciones;


--kps 6
--mes específico)


SELECT EXTRACT(MONTH FROM fecha) AS mes,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END) AS v2023,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) AS v2024
FROM vista_operaciones
WHERE EXTRACT(MONTH FROM fecha)=5
GROUP BY mes;


---- kpi 7

SELECT 
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END) AS v2023,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) AS v2024
FROM vista_operaciones
WHERE EXTRACT(MONTH FROM fecha) IN (1,2,3);


----- kpi 8

SELECT 
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2023 THEN venta ELSE 0 END) AS v2023,
SUM(CASE WHEN EXTRACT(YEAR FROM fecha)=2024 THEN venta ELSE 0 END) AS v2024
FROM vista_operaciones
WHERE EXTRACT(MONTH FROM fecha) IN (10,11,12);

------

