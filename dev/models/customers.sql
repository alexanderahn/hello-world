WITH raw_customers AS (

  SELECT * 
  
  FROM {{ ref('raw_customers')}}

),

renamed_1 AS (

  SELECT 
    id AS customer_id,
    first_name,
    last_name
  
  FROM raw_customers AS source

),

raw_orders AS (

  SELECT * 
  
  FROM {{ ref('raw_orders')}}

),

renamed AS (

  SELECT 
    id AS order_id,
    user_id AS customer_id,
    order_date,
    status
  
  FROM raw_orders AS source

),

customer_orders AS (

  SELECT 
    customer_id,
    min(order_date) AS first_order,
    max(order_date) AS most_recent_order,
    count(order_id) AS number_of_orders
  
  FROM renamed AS orders
  
  GROUP BY customer_id

),

Join_1 AS (

  {#Links customer IDs from two sources to identify common customers.#}
  SELECT 
    in0.CUSTOMER_ID AS CUSTOMER_ID,
    in1.CUSTOMER_ID AS CUSTOMER_ID
  
  FROM renamed_1 AS in0
  INNER JOIN customer_orders AS in1

),

Deduplicate_1 AS (

  SELECT DISTINCT *
  
  FROM Join_1 AS in0

)

SELECT *

FROM Deduplicate_1
