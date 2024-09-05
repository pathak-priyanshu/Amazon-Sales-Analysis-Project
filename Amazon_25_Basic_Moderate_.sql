---Amazon Sales Data ANalysis:-


select * from customers;
select * from products;
select * from sellers;
select * from orders;
select * from returns;
/*
Amazon Sales Data Analysis using SQL (PostgreSQL)
Solve below business Problems
*/


--1. Retrieve the total number of customers in the database.

select 
      count(*) as tot_cx
from customers


--2. Calculate the total number of sellers registered on Amazon.

select 
       count(*) as tot_seller
from sellers

--3. List all unique product categories available. 

select
		distinct(category) 
from orders
where category is not null

--4Find the top 5 best-selling products by quantity sold.

select 
	  distinct (product_id),
	  count(*) AS TOTAL_qty_sold
from orders
group by 1
order by 2 desc 
limit 5

--5. Determine the total revenue generated from sales.

select sum(sale) as total_revenue
from orders

--6. List all customers who have made at least one return.

select * from returns
select
		o.order_id,
		c.customer_name,
		count(return_id) as total_return
from orders AS o
left join returns as r
on o.order_id = r.order_id
join customers as c
on o.customer_id = c.customer_id
group by 1,2
having count(return_id) >=1

--7. Calculate the average price of products sold.

select 
		product_id,
		avg(sale) as avg_ordr_price
from orders
group by 1
order by 2 desc

--8. Identify the top 3 states with the highest total sales.

select 
       o.state,
       sum(o.sale) as tot_sale
from orders as o 
 join customers as cx
on o.customer_id = cx.customer_id
group by 1
order by 2 desc
limit 3

--9. Find the product category with the highest average sale price.
-- cat,avg(sale)

select category,
       avg(sale) as avg_sale_price
from orders
group by 1
order by 2 desc
limit 1

--10. List all orders with a sale amount greater than $100. 

select * 
from orders
where sale > 100

--11. Calculate the total number of returns processed.

select count(return_id) as tot_returns from returns


--12. Identify the top-selling seller based on total sales amount.

select * from sellers
select 
		o.seller_id,
		s.seller_name,
        sum(sale) as top_selling_seller
from orders as o
join sellers as s 
on o.seller_id = s.seller_id
group by 1,2
order by 3 desc 
-- use limit for getting top n seller--

--13. List the products with the highest quantity sold in each category.
--category wise --> count(order_id) --> dense rank partition by category

select * 
from  
(select category,
       product_id,
       sum(quantity) as qty_sold,
	   dense_rank() over(partition by category order by sum(quantity) desc ) as drnk
from orders 
group by 1,2
)as t1
where drnk = 1 and category is not null
order by 3 desc

--14. Determine the average sale amount per order.--

select 
		order_id,
		avg(sale)as avg_sale_per_odr
from orders
group by 1
order by 2 desc

--15. Find the top 5 customers who have spent the most money.

select 
        o.customer_id,
		cx.customer_name,
		sum(sale) as Tot_revenue
from orders as o
join customers as cx
on o.customer_id = cx.customer_id
group by 1,2	
order by 3 desc
limit 5

--16. Calculate the total number of orders placed in each state.

select sum(Odr_Qty) as Tot_odr_placed
from 
     (
     select 
             cx.state,
     		count(*) as Odr_Qty
     from orders as o
     join customers as cx
     on o.customer_id = cx.customer_id
     group by 1
     order by 2 desc
     )
	 
--17. Identify the product sub-category with the highest total sales.

select
      sub_category,
	  count(*) as tot_odr_qty,
	  sum(sale) as tot_rev
from orders
group by 1
order by 3 desc
  
--18. List the orders with the highest total sale amount.

select 
      *
from orders as o
where sale = (select max(sale) from orders)

--19. Calculate the total sales revenue for each seller.

select 
             s.seller_id,
        	   s.seller_name,
      	sum(sale) as tot_revenue_each_seller	 
from sellers as s
inner join orders as o
on s.seller_id = o.seller_id
group by 1,2
order by 3 desc
      
--20. Find the top 3 states with the highest average sale per order.

select 
      state,
	  avg(sale) as tot_avg_rev
from orders 
group by 1
order by 2 desc
limit 3

--21. Identify the product category with the highest total quantity sold.

select category,
       count(order_id) as tot_odr_qty,
	   sum(sale) as tot_revenue
from orders
group by 1
order by 2 desc
limit 1

--22. List the orders with the highest quantity of products purchased.


with highest_odr_qty
as
(select
       distinct(o.product_id),
	   product_name,
	   count(o.order_id	) as tot_odrs
from orders as o
join products as p 
on o.product_id = p.product_id
group by 1,2
),
cte_2
as 
(select 
		product_name ,
		tot_odrs,
		dense_rank() over(order by tot_odrs desc ) as dranks
from highest_odr_qty
)
select * from cte_2
where dranks = 1
------------------------------------------------------------------------------------------------------------
/* with this approach we made this querry dynamic, just put the value in the where clause to see nth 
highest quantity of products purchased*/
------------------------------------------------------------------------------------------------------------

--23. Calculate the average sale amount for each product category.
--> category wise avg sale

select 
	  category,
	  avg(sale) as avg_cat_sale,
	  count(*) as tot_odrs,
	  avg(quantity) as avg_qty_sld_by_cat
from orders
where category is not null
group by 1
order by 2 desc

--24. Find the top-selling seller based on the number of orders processed.

select * from sellers
select
		sum( TOT_odr_processed) as amazon_tot_odrs
from
    (
       select   
       		s.seller_name,
       		s.seller_id,	
       		count(o.order_id) as TOT_odr_processed
       from orders as o
       inner join sellers as s
       on o.seller_id = s.seller_id
       group by 1,2
       order by 3 desc
     )

--25. Identify the customers who have made returns more than once.

select
		c.customer_name,
		c.customer_id,
		count(r.return_id) as returning_cx

from orders as o
join customers as c
on o.customer_id = c.customer_id
left join returns as r
on o.order_id= r.order_id
group by 1,2
having count(r.return_id) > 1
order by returning_cx desc -- we can use alias with 'order by'.

----------------------------------------END-----------------------------------------------------------------







  