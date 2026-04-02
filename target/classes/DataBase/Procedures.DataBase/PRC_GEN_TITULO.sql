CREATE OR REPLACE PROCEDURE PRC_GEN_TITULO (
    p_idLiquidacion IN NUMBER
)
AS
    v_anio NUMBER;
    v_mes NUMBER;
    v_fechaInicioLiquidacion DATE;
    v_idConcepto NUMBER;
BEGIN
    -- Obtener año y mes desde LIQUIDACION
    SELECT L.ANIO, L.MES
    INTO v_anio, v_mes
    FROM LIQUIDACION L
    WHERE L.ID = p_idLiquidacion;

    -- Calcular fecha (equivalente a DATEFROMPARTS)
    v_fechaInicioLiquidacion := TO_DATE(v_anio || '-' || v_mes || '-01', 'YYYY-MM-DD');

    -- Obtener ID del concepto 'D0002'
    SELECT ID INTO v_idConcepto
    FROM CONCEPTO
    WHERE CODIGO = 'D0002';

    -- Insertar en TABULADO_CONCEPTO
    INSERT INTO TABULADO_CONCEPTO (ID_TABULADO, ID_CONCEPTO, MONTO, SENTIDO)
    SELECT 
        T.ID, 
        v_idConcepto,
        CASE 
            WHEN TI.TIPO = 'INGENIERO' THEN J.MONTO * 0.6
            WHEN TI.TIPO = 'CONTADOR' THEN J.MONTO * 0.5
            WHEN TI.TIPO = 'ABOGADO' THEN J.MONTO * 0.4
            WHEN TI.TIPO = 'LIC_ADMINISTRACION' THEN J.MONTO * 0.3
            WHEN TI.TIPO = 'TEC_HIGIENE' THEN J.MONTO * 0.2
            WHEN TI.TIPO = 'TEC_INFO' THEN J.MONTO * 0.1
            ELSE 0
        END AS MONTO,
        'D'
    FROM PERSONA P
    JOIN NOU N ON N.ID_PERSONA = P.ID
    JOIN EVENTO_NOU EN ON EN.NOU_ID = N.ID
    JOIN EVENTO E ON E.ID = EN.EVENTO_ID
    JOIN TABULADO T ON T.ID_NOU = N.ID
    JOIN JERARQUIA J ON J.ID = P.ID_JERARQUIA
    JOIN TITULO TI ON TI.ID = P.ID_TITULO
    WHERE EN.FECHA_INICIO <= v_fechaInicioLiquidacion
      AND EN.FECHA_FIN > v_fechaInicioLiquidacion
      AND T.ID_LIQUIDACION = p_idLiquidacion
      AND E.IDENTIFICADOR = 'TITULO';

END;
/