CREATE OR REPLACE PROCEDURE PRC_GEN_APORTES (
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
    WHERE CODIGO = 'A0001';

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
        SUM(CASE WHEN C.REMUNERATIVO = 1 THEN TC.MONTO * 0.08 ELSE 0 END),
        'A'
    FROM PERSONA P
    JOIN NOU N ON N.ID_PERSONA = P.ID
    JOIN EVENTO_NOU EN ON EN.NOU_ID = N.ID
    JOIN EVENTO E ON E.ID = EN.EVENTO_ID
    JOIN TABULADO T ON T.ID_NOU = N.ID
    JOIN TABULADO_CONCEPTO TC ON TC.ID_TABULADO = T.ID
    JOIN CONCEPTO C ON TC.ID_CONCEPTO = C.ID
    WHERE EN.FECHA_INICIO <= v_fechaInicioLiquidacion
      AND EN.FECHA_FIN > v_fechaInicioLiquidacion
      AND T.ID_LIQUIDACION = p_idLiquidacion
      AND E.IDENTIFICADOR = 'APORTES'
    GROUP BY T.ID;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el concepto o liquidación.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: se esperaba solo un concepto o liquidación.');
END;
/