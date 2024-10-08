WITH raw_payments AS (

  SELECT * 
  
  FROM {{ ref('raw_payments')}}

),

raw_orders AS (

  SELECT * 
  
  FROM {{ ref('raw_orders')}}

),

renamed_1 AS (

  SELECT 
    id AS payment_id,
    order_id,
    payment_method,
    -- `amount` is currently stored in cents, so we convert it to dollars
    amount / 100 AS amount
  
  FROM raw_payments AS source

),

order_payments AS (

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
  
  FROM renamed_1 AS payments
  
  GROUP BY order_id

),

final AS (

  SELECT 
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    orders.status,
    {% for payment_method in payment_methods %}
      order_payments.{{payment_method}}_amount,
    {% endfor %}
    
    order_payments.total_amount AS amount
  
  FROM renamed AS orders
  LEFT JOIN order_payments
     ON orders.order_id = order_payments.order_id

)

SELECT *

FROM final
