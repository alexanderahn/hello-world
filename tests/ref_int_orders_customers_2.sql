WITH Reformat_1 AS (

  SELECT * 
  
  FROM in0

),

orders AS (

  SELECT * 
  
  FROM {{ ref('orders')}}

),

customers AS (

  SELECT * 
  
  FROM {{ ref('customers')}}

),

Join_1 AS (

  SELECT 
    in0.order_id AS order_id,
    in0.customer_id AS customer_id0,
    in0.order_date AS order_date,
    in0.status AS status,
    in0.credit_card_amount AS credit_card_amount,
    in0.coupon_amount AS coupon_amount,
    in0.bank_transfer_amount AS bank_transfer_amount,
    in0.gift_card_amount AS gift_card_amount,
    in0.amount AS amount,
    in1.customer_id AS customer_id,
    in1.first_name AS first_name,
    in1.last_name AS last_name,
    in1.first_order AS first_order,
    in1.most_recent_order AS most_recent_order,
    in1.number_of_orders AS number_of_orders,
    in1.customer_lifetime_value AS customer_lifetime_value
  
  FROM orders AS in0
  LEFT JOIN customers AS in1
     ON in0.customer_id = in1.customer_id

),

Filter_1 AS (

  SELECT * 
  
  FROM Join_1
  
  WHERE customer_id0 IS NULL

)

SELECT *

FROM Filter_1
