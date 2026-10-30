Trabajo Practico Integrador - Ingenieria de Datos

1. Diseño fisico: particion y clustering
Particione la tabla por la columna fecha_subida con granularidad de dia. Esto lo decidi porque las consultas analíticas del negocio suelen filtrar por fechas especificas. De esta forma, BigQuery aplica partition pruning (descarte de particiones antes de ejecutar) y solo lee los bytes de los dias consultados, reduciendo drasticamente el costo de la consulta.

Aplique clustering por pickup_location_id. Elegi esta columna porque contiene muchos valores distintos (zonas de taxis) y es un campo por el cual se filtra y agrupa constantemente. El clustering ordena internamente cada particion por zona, permitiendo un block pruning muy eficiente al saltear los bloques que no corresponden a la zona buscada.


2. Decision de diseño propia:
Para la limpieza de fechas en la capa de Staging (stg_viajes.sql y stg_clima.sql), decidi utilizar COALESCE combinando la funcion SAFE.PARSE_DATETIME en dos formatos distintos (estadounidense "%Y-%m-%d" y argentino "%d/%m/%Y").

Alternativa descartada: utilizar la función estándar CAST(columna AS DATETIME) directamente sobre la cadena de texto original.
Descarte el CAST simple porque es estricto y al haber formatos de fecha mezclados en los archivos originales, un solo valor que no coincida con el formato esperado hace fallar la consulta entera e interrumpe la construccion del modelo. Al usar SAFE.PARSE_DATETIME, los valores que fallan se convierten temporalmente en NULL sin romper la consulta, y al envolverlos en un COALESCE, logramos rescatar ambos formatos en la misma pasada sin perder ninguna fila de los viajes originales.