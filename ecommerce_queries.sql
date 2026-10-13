SELECT ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)),0) AS total_revenue,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100))/COUNT(DISTINCT o.order_id),0) AS avg_order_value
FROM orders o JOIN products p ON o.product_id=p.product_id
WHERE o.order_status='Delivered';

SELECT p.category,
       ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)),0) AS revenue,
       ROUND(100*SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)) /
             SUM(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100))) OVER(),1) AS pct_share
FROM orders o JOIN products p ON o.product_id=p.product_id
WHERE o.order_status='Delivered'
GROUP BY p.category ORDER BY revenue DESC;	


       ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)),0) AS revenue
FROM orders o JOIN products p ON o.product_id=p.product_id
WHERE o.order_status='Delivered'
GROUP BY month ORDER BY month;

SELECT c.city, ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)),0) AS revenue
FROM orders o JOIN products p ON o.product_id=p.product_id
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_status='Delivered'
GROUP BY c.city ORDER BY revenue DESC;

SELECT p.product_name,
       ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)),0) AS revenue
FROM orders o JOIN products p ON o.product_id=p.product_id
WHERE o.order_status='Delivered'
GROUP BY p.product_name ORDER BY revenue DESC LIMIT 5;

SELECT ROUND(100*SUM(order_count>1)/COUNT(*),1) AS repeat_customer_pct
FROM (SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
      FROM orders WHERE order_status='Delivered' GROUP BY customer_id) t;
      
SELECT ROUND(100*SUM(order_status='Cancelled')/COUNT(*),1) AS cancel_rate,
       ROUND(100*SUM(order_status='Returned')/COUNT(*),1)  AS return_rate
FROM orders;
      
SELECT customer_id, revenue, RANK() OVER (ORDER BY revenue DESC) AS rnk
FROM (SELECT o.customer_id,
             ROUND(SUM(p.unit_price*o.quantity*(1-o.discount_pct/100)),0) AS revenue
      FROM orders o JOIN products p ON o.product_id=p.product_id
      WHERE o.order_status='Delivered' GROUP BY o.customer_id) t
ORDER BY rnk LIMIT 10;  


SELECT COALESCE(NULLIF(TRIM(payment_method),''),'Unknown') AS payment_method,
       ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER(),1) AS pct
FROM orders WHERE order_status='Delivered'
GROUP BY 1 ORDER BY pct DESC;

