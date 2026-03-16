{{ config(materialized='table') }}

with countries as (

    select distinct
        country_iso,
        country_name
    from {{ ref('stg_world_bank_indicators') }}
    where country_iso is not null

)

select
    country_iso,
    country_name,
    case
        when country_iso in ('ZA','BW','NA','ZW','ZM','MW','MZ','LS','SZ')
            then 'Southern Africa'
        when country_iso in ('NG','GH','SN','CI','CM','ML','BF','NE','TD',
                             'SL','LR','GN','GW','CV','GM','TG','BJ')
            then 'West and Central Africa'
        when country_iso in ('KE','ET','TZ','UG','RW','BI','SO','ER','DJ')
            then 'East Africa'
        when country_iso in ('AO','CD','CG','GA','GQ','CF','ST')
            then 'Central Africa'
        when country_iso in ('MG','MU','SC','KM')
            then 'Indian Ocean Islands'
        else 'Other'
    end as region

from countries
order by country_iso