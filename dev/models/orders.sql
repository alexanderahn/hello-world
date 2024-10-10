WITH raw_payments AS (

  SELECT * 
  
  FROM {{ ref('raw_payments')}}

),

renamed_2 AS (

  SELECT 
    id AS order_id,
    order_id AS customer_id,
    NULL AS order_date,
    NULL AS status
  
  FROM raw_payments AS source

),

order_payments_1 AS (

  SELECT 
    order_id,
    {% for payment_method in payment_methods %}
      sum(CASE
        WHEN payment_method = '{{ payment_method }}'
          THEN amount
        ELSE 0
      END) AS {{payment_method}}_amount,
    {% endfor %}
    
    sum(amount) AS total_amount
  
  FROM renamed_2 AS payments
  
  GROUP BY order_id

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

final AS (

  SELECT 
    orders.order_id_3,
    orders.customer_id,
    orders.order_date,
    orders.status,
    {% for payment_method in payment_methods %}
      order_payments.{{payment_method}}_amount,
    {% endfor %}
    
    order_payments.total_amount AS amount
  
  FROM renamed AS orders
  LEFT JOIN order_payments_1 AS order_payments
     ON orders.order_id = order_payments.order_id

)

SELECT *

FROM final
