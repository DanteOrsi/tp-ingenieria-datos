with deduplicados as (
    select distinct *
    from {{ source('tp_raw', 'clima') }}
)

select
    coalesce(
        safe.parse_datetime('%Y-%m-%d %H:%M:%S', fecha_hora),
        safe.parse_datetime('%d/%m/%Y %H:%M:%S', fecha_hora)
    ) as fecha_hora,
    cast(temperatura_c as numeric) as temperatura_c,
    cast(precipitacion_mm as numeric) as precipitacion_mm,
    cast(viento_kmh as numeric) as viento_kmh,
    codigo_clima
from deduplicados