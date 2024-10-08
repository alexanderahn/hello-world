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

final AS (

  SELECT 
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order,
    customer_orders.most_recent_order,
    customer_orders.number_of_orders,
    customer_payments.total_amount AS customer_lifetime_value
  
  FROM renamed_1 AS customers
  LEFT JOIN customer_orders
     ON customers.customer_id = customer_orders.customer_id
  LEFT JOIN customer_orders AS customer_payments
     ON customers.customer_id = customer_payments.customer_id

)

SELECT *

FROM final
