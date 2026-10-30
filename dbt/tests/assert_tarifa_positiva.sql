select *
from {{ ref('viajes_validos') }}
where fare_amount <= 0