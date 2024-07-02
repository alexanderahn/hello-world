WITH source AS (

  SELECT * 
  
  FROM {{ ref('raw_customers')}}

),

renamed AS (

  SELECT 
    id,
    first_name,
    last_name
  
  FROM source

)

SELECT *

FROM renamed
