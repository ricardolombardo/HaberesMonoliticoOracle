MERGE INTO TAREAS t
USING (
    SELECT 'Planta Permanente' AS NOMBRE, 
           'Tarea que efectua la liquidacion de la remuneracion permanente' AS DESCRIPCION, 
           'PLANTA_PERMANENTE' AS TIPO 
    FROM DUAL
    UNION ALL
    SELECT 'Titulo', 
           'Tarea que efectua la liquidacion por titulo', 
           'TITULO' 
    FROM DUAL
    UNION ALL
    SELECT 'Antiguedad', 
           'Tarea que efectua la liquidacion por antiguedad', 
           'ANTIGUEDAD' 
    FROM DUAL
    UNION ALL
    SELECT 'Aportes', 
           'Tarea que genera los aportes', 
           'APORTES' 
    FROM DUAL
) src
ON (t.TIPO = src.TIPO)
WHEN NOT MATCHED THEN
    INSERT (NOMBRE, DESCRIPCION, TIPO)
    VALUES (src.NOMBRE, src.DESCRIPCION, src.TIPO);