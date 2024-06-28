WITH source AS (

  {#-
  Normally we would select from the table here, but we are using seeds to load
  our data in this project
  #}
  SELECT * 
  
  FROM {{ ref('raw_customers')}}

),

renamed AS (

  {#Renames the 'id' column as 'customer_id' and selects 'first_name' and 'last_name' from the 'source' table.#}
  SELECT 
    id AS customer_id,
    first_name,
    last_name
  
  FROM source

)

SELECT *

FROM renamed
