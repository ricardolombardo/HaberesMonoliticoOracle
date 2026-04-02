CREATE OR REPLACE PROCEDURE PRC_GEN_TABULADOS (
    p_idLiquidacion IN NUMBER
)
AS
    v_anio NUMBER;
    v_mes NUMBER;
    v_fechaInicio DATE;
BEGIN
    -- Obtener año y mes desde LIQUIDACION
    SELECT L.ANIO, L.MES
    INTO v_anio, v_mes
    FROM LIQUIDACION L
    WHERE L.ID = p_idLiquidacion;

    -- Calcular fecha (equivalente a DATEFROMPARTS)
    v_fechaInicio := TO_DATE(v_anio || '-' || v_mes || '-01', 'YYYY-MM-DD');

    -- Insertar en TABULADO
    INSERT INTO TABULADO (ID_LIQUIDACION, ID_NOU)
    SELECT p_idLiquidacion, N.ID
    FROM PERSONA P
    JOIN NOU N ON N.ID_PERSONA = P.ID
    JOIN EVENTO_NOU EN ON EN.NOU_ID = N.ID
    JOIN EVENTO E ON E.ID = EN.EVENTO_ID
    WHERE EN.FECHA_INICIO <= v_fechaInicio
      AND EN.FECHA_FIN > v_fechaInicio
      AND E.IDENTIFICADOR = 'PlantaPermanente';

END;
/