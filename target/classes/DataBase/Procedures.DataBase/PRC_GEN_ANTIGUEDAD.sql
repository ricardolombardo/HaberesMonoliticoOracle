CREATE OR REPLACE PROCEDURE PRC_GEN_ANTIGUEDAD (
    p_idLiquidacion IN NUMBER
)
AS
    v_anio NUMBER;
    v_mes NUMBER;
    v_fechaInicioLiquidacion DATE;
    v_idConcepto NUMBER;
BEGIN
    -- Obtener el ID del concepto
    SELECT ID
    INTO v_idConcepto
    FROM CONCEPTO
    WHERE CODIGO = 'D0005';

    -- Obtener año y mes desde LIQUIDACION
    SELECT L.ANIO, L.MES
    INTO v_anio, v_mes
    FROM LIQUIDACION L
    WHERE L.ID = p_idLiquidacion;

    -- Calcular fecha (equivalente a DATEFROMPARTS)
    v_fechaInicioLiquidacion := TO_DATE(v_anio || '-' || v_mes || '-01', 'YYYY-MM-DD');

    -- Insertar en TABULADO_CONCEPTO
    INSERT INTO TABULADO_CONCEPTO (ID_TABULADO, ID_CONCEPTO, MONTO, SENTIDO)
    SELECT 
        T.ID,
        v_idConcepto,
        P.ANTIGUEDAD * J.MONTO / 100,
        'D'
    FROM PERSONA P
    JOIN NOU N ON N.ID_PERSONA = P.ID
    JOIN EVENTO_NOU EN ON EN.NOU_ID = N.ID
    JOIN EVENTO E ON E.ID = EN.EVENTO_ID
    JOIN TABULADO T ON T.ID_NOU = N.ID
    JOIN JERARQUIA J ON J.ID = P.ID_JERARQUIA
    WHERE EN.FECHA_INICIO <= v_fechaInicioLiquidacion
      AND EN.FECHA_FIN > v_fechaInicioLiquidacion
      AND T.ID_LIQUIDACION = p_idLiquidacion
      AND E.IDENTIFICADOR = 'ANTIGUEDAD';

END;
/