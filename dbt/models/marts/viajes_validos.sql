{{ config(
    materialized='table',
    partition_by={
        'field': 'fecha_subida',
        'data_type': 'date',
        'granularity': 'day'
    },
    cluster_by=['pickup_location_id']
) }}

with viajes as (
    select * 
    from {{ ref('stg_viajes') }}
),

clima as (
    select * 
    from {{ ref('stg_clima') }}
),

zonas as (
    select distinct 
        zone_id, 
        borough, 
        zone_name
    from {{ source('new_york_taxi_trips', 'taxi_zone_geom') }}
)

select
    v.vendor_id,
    v.pickup_datetime,
    date(v.pickup_datetime) as fecha_subida,
    v.dropoff_datetime,
    v.trip_distance,
    v.pickup_location_id,
    z.borough as zona_subida_distrito,
    z.zone_name as zona_subida_nombre,
    v.total_amount,
    v.fare_amount,
    c.precipitacion_mm,
    if(c.precipitacion_mm > 0, true, false) as con_lluvia
from viajes v

inner join zonas z 
    on cast(v.pickup_location_id as string) = z.zone_id

left join clima c 
    on datetime_trunc(v.pickup_datetime, hour) = c.fecha_hora
where 
    date(v.pickup_datetime) between '2026-09-14' and '2026-10-11'
    and v.dropoff_datetime > v.pickup_datetime
    and v.fare_amount > 0
    and v.trip_distance > 0