CREATE OR REPLACE PROCEDURE PRC_GEN_RPT_LIQ_DET (
    p_anio_desde IN NUMBER,
    p_mes_desde IN NUMBER,
    p_anio_hasta IN NUMBER,
    p_mes_hasta IN NUMBER,
    o_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN o_cursor FOR
    SELECT DESCRIPCION, ANIO, MES, SUM(HM) AS HABER_MENSUAL, SUM(TITULO) AS TITULO
    FROM (
        SELECT 
            LIQ.ID,
            LIQ.DESCRIPCION,
            LIQ.ANIO,
            LIQ.MES,
            C.NOMBRE,
            CASE 
                WHEN C.NOMBRE = 'Haber mensual' THEN SUM(TC.MONTO)
                ELSE 0
            END AS HM,
            CASE 
                WHEN C.NOMBRE = 'Titulo' THEN SUM(TC.MONTO)
                ELSE 0
            END AS TITULO
        FROM LIQUIDACION LIQ
        JOIN TABULADO T ON T.ID_LIQUIDACION = LIQ.ID
        JOIN TABULADO_CONCEPTO TC ON TC.ID_TABULADO = T.ID
        JOIN CONCEPTO C ON C.ID = TC.ID_CONCEPTO
        WHERE LIQ.ANIO > p_anio_desde AND LIQ.ANIO < p_anio_hasta
          AND LIQ.MES > p_mes_desde AND LIQ.MES < p_mes_hasta
        GROUP BY LIQ.ID, LIQ.DESCRIPCION, LIQ.ANIO, LIQ.MES, C.NOMBRE
    ) TABLA
    GROUP BY DESCRIPCION, ANIO, MES;
END;
/