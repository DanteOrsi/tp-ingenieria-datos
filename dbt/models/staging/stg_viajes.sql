with deduplicados as (
    select distinct *
    from {{ source('tp_raw', 'viajes') }}
)

select
    vendor_id,
    -- Leemos el formato americano o el argentino[cite: 50]
    coalesce(
        safe.parse_datetime('%Y-%m-%d %H:%M:%S', pickup_datetime),
        safe.parse_datetime('%d/%m/%Y %H:%M:%S', pickup_datetime)
    ) as pickup_datetime,
    coalesce(
        safe.parse_datetime('%Y-%m-%d %H:%M:%S', dropoff_datetime),
        safe.parse_datetime('%d/%m/%Y %H:%M:%S', dropoff_datetime)
    ) as dropoff_datetime,
    passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    cast(fare_amount as numeric) as fare_amount,
    cast(tip_amount as numeric) as tip_amount,
    cast(total_amount as numeric) as total_amount
from deduplicados