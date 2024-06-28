WITH customers AS (

  SELECT * 
  
  FROM {{ ref('customers')}}

),

orders AS (

  SELECT * 
  
  FROM {{ ref('orders')}}

),

customers_orders_join AS (

  SELECT 
    customers.customer_id AS CUSTOMER_ID,
    customers.first_name AS FIRST_NAME,
    customers.last_name AS LAST_NAME,
    orders.amount
  
  FROM customers
  INNER JOIN orders
     ON customers.customer_id = orders.customer_id

),

total_amount_by_customer AS (

  SELECT 
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    SUM(amount) AS TOTAL_AMOUNT
  
  FROM customers_orders_join
  
  GROUP BY 
    CUSTOMER_ID, FIRST_NAME, LAST_NAME

),

total_amount_desc_nulls_first AS (

  SELECT * 
  
  FROM total_amount_by_customer
  
  ORDER BY TOTAL_AMOUNT DESC NULLS FIRST

),

limit_50 AS (

  SELECT * 
  
  FROM total_amount_desc_nulls_first
  
  LIMIT 50

)

SELECT *

FROM limit_50
