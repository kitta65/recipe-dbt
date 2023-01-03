{{
  config(
    params='snapshot_dt_ DATE',
  )
}}

with
  customers as (
    select * from {{ ref("stg_dummy__customers") }}
    where snapshot_dt = snapshot_dt_
  ),
  user_orders as (
    select
      customer_id,
      sum(amount) as ltv,
      min(order_dt) as first_order_dt,
    from {{ ref("stg_dummy__orders")}}
    where snapshot_dt = snapshot_dt_
    group by 1
  )
select
  c.*,
  coalesce(uo.ltv, 0) as ltv,
  uo.first_order_dt,
from
  customers as c
  left join user_orders as uo using(customer_id)
