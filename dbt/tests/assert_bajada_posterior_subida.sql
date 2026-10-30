select *
from {{ ref('viajes_validos') }}
where dropoff_datetime <= pickup_datetime