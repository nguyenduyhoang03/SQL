--INNER JOIN
SELECT 
 product_name,
 category_name,
 brand_name,
 list_price
FROM production.products p

INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
ORDER BY
product_name;

SELECT 
cu.last_name customer_name,
item_id,
product_name,
quantity,
store_name,
st.last_name
FROM sales.customers cu
inner join sales.orders o on o.customer_id = cu.customer_id
inner join sales.order_items oi on oi.order_id = o.order_id
inner join production.products p on p.product_id = oi.product_id
inner join sales.stores s on s.store_id = o.order_id
inner join sales.staffs st on st.staff_id = o.staff_id


SELECT * FROM production.products
 WHERE
	category_id = 1 AND category_id=1
 ORDER BY
	list_price DESC;
--where + in  = trong khoang
SELECT * FROM production.products
	where list_price in (80,489,99,109,99,89,99)

select p.product_id,product_name,list_price
from production.stocks s
inner join production.products p on p.product_id = s.store_id
 where
	store_id=1 and quantity >= 20;


CREATE VIEW sales.daily_sales
as 
	select
	day(order_date) d,
	month(order_date) m,
	year(order_date) y,
	p.product_id,
	p.product_name,
	quantity*i.list_price sales
from sales.orders o
join sales.order_items i ON o.order_id = i.order_id
join production.products p ON p.product_id = i.product_id

--query
select* from sales.daily_sales
