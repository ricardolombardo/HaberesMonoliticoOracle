MERGE INTO CONCEPTO c
USING (
    SELECT 'Haber mensual' AS NOMBRE, 'D' AS SALDO, 'D0001' AS CODIGO FROM DUAL
    UNION ALL
    SELECT 'Titulo', 'D', 'D0002' FROM DUAL
    UNION ALL
    SELECT 'Presentismo', 'D', 'D0003' FROM DUAL
    UNION ALL
    SELECT 'Horas extras', 'D', 'D0004' FROM DUAL
    UNION ALL
    SELECT 'Aporte jubilatorio', 'A', 'A0001' FROM DUAL
    UNION ALL
    SELECT 'Aporte obra social', 'A', 'A0002' FROM DUAL
    UNION ALL
    SELECT 'Antiguedad', 'D', 'D0005' FROM DUAL
) src
ON (c.CODIGO = src.CODIGO)
WHEN NOT MATCHED THEN
    INSERT (NOMBRE, SALDO, CODIGO)
    VALUES (src.NOMBRE, src.SALDO, src.CODIGO);